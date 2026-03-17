import Foundation
import TabularData
import CoreML
import CreateMLComponents
import UniformTypeIdentifiers

/// Note: To compile the `.mlpackage` into a `.mlmodelc`, run:
/// `xcrun coremlcompiler compile path/to/BalanceScoreClassifier.mlpackage path/to/output_directory`

/// Time Series Classifier:
/// https://developer.apple.com/documentation/createmlcomponents/creating-a-time-series-classifier

@MainActor
@Observable final class MachineLearningModel {
    var showPicker: Bool = false
    var isTraining: Bool = false
    
    var model: TimeSeriesClassifier<Float, String>.Model?
    
    private func train(url: URL) async throws {
        let annotatedFiles = try AnnotatedFiles(
            labeledBySubdirectoryNamesAt: url,
            type: .commaSeparatedText,
            continueOnFailure: true
        )
        
        var configuration = TimeSeriesClassifierConfiguration()
        configuration.maximumSequenceLength = 2000
        
        let featureColumns = ["roll", "pitch", "yaw"]
        
        let options = CSVReadingOptions(floatingPointType: .float)
        var result = [AnnotatedFeature<MLShapedArray<Float>, String>]()
        
        for file in annotatedFiles {
            let df = try DataFrame(
                contentsOfCSVFile: file.feature, columns: featureColumns, options: options
            )
            
            var arrays = [MLShapedArray<Float>]()
            
            for featureColumn in featureColumns {
                let featureValues = df[featureColumn, Float.self].filled(with: .nan)
                let processedFeatureValues: MLShapedArray<Float>
                
                if featureValues.count > configuration.maximumSequenceLength {
                    processedFeatureValues = MLShapedArray(
                        scalars: featureValues[..<configuration.maximumSequenceLength],
                        shape: [configuration.maximumSequenceLength, 1]
                    )
                } else {
                    processedFeatureValues = MLShapedArray(
                        scalars: featureValues,
                        shape: [featureValues.count, 1]
                    )
                }
                
                arrays.append(processedFeatureValues)
            }
            
            let feature = MLShapedArray(concatenating: arrays, alongAxis: 1)
            result.append(AnnotatedFeature(feature: feature, annotation: file.annotation))
        }
        
//        result.shuffle()
        
        let sampleCount = Double(result.count)
        let training = result[2 ..< Int(sampleCount * 0.9)]
        let validation = result[Int(sampleCount * 0.9) ..< Int(sampleCount)]
        let testing = result[0...1]
        
        configuration.maximumIterationCount = 20
        
        let uniqueLabels = Set(result.map { $0.annotation })
        let estimator = TimeSeriesClassifier<Float, String>(
            labels: uniqueLabels, configuration: configuration
        )

        model = try await estimator.fitted(to: training, validateOn: validation) { event in
            if let trainingAccuracy = event.metrics[MetricsKey.trainingAccuracy] as? Double {
                print("Training accuracy: \(String(format: "%.2f", trainingAccuracy * 100))%")
            }
        }
        
        guard let model else { return }
        
        let classificationDistributions = try await model
            .applied(to: testing.map(\.feature))
        
        let predictedLabels = classificationDistributions
            .map(\.mostLikelyLabel!)
        
        let metrics = ClassificationMetrics(
            predictedLabels, testing.map(\.annotation)
        )

        print("Accuracy: \(metrics.accuracy)")
        showPicker = true
    }
    
    public func train(using url: URL) {
        isTraining = true
        
        if url.startAccessingSecurityScopedResource() {
            defer { url.stopAccessingSecurityScopedResource() }
            
            Task {
                do {
                    try await train(url: url)
                } catch {
                    print(error)
                    isTraining = false
                }
            }
        }
    }
    
    public func save(to url: URL) {
        do {
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                let url = url.appending(component: "BalanceScoreClassifier.mlpackage")
                try model!.export(to: url)
                
                model = nil
                isTraining = false
            }
        } catch {
            print(error)
        }
    }
}
