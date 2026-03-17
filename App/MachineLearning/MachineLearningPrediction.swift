import Foundation
import CoreML

extension MachineLearningModel {
    static func prediction(using measurements: [BalanceMeasurement]) async throws -> String {
        guard let url = Bundle.main.url(
            forResource: "BalanceScoreClassifier",
            withExtension: "mlmodelc"
        )  else {
            throw Error.modelNotFound
        }
        
        let model = try MLModel(contentsOf: url)
        let sequenceLength = measurements.count
        
        let scalars = measurements.flatMap {
            [Float($0.roll), Float($0.pitch), Float($0.yaw)]
        }
        
        let shape = [sequenceLength, 3]
        let features = MLShapedArray(scalars: scalars, shape: shape)
        
        let featureValue = MLFeatureValue(shapedArray: features)
        let featureProvider = try MLDictionaryFeatureProvider(
            dictionary: [
                "input": featureValue,
                "sequenceLength": MLFeatureValue(
                    shapedArray: MLShapedArray(scalars: [Int32(sequenceLength)], shape: [1])
                ),
            ]
        )
        
        let modelOutput = try await model.prediction(from: featureProvider)
        
        let probabilities = modelOutput
            .featureValue(for: "labelProbabilities")?.dictionaryValue as? [String: NSNumber]
        
        guard let label = probabilities?
            .max(by: { $0.value.doubleValue < $1.value.doubleValue })?.key
        else {
            throw Error.predictionError
        }
        
        return label
    }
    
    enum Error: Swift.Error {
        case modelNotFound
        case predictionError
    }
}
