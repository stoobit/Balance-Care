import SwiftUI
import UniformTypeIdentifiers

struct MachineLearningView: View {
    @State var ml: MachineLearningModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if ml.isTraining == false {
                Button(action: { ml.showPicker = true}) {
                    Label("Train Model", systemImage: "dumbbell.fill")
                        .font(.headline)
                        .padding(8)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
            } else {
                ProgressView()
                    .controlSize(.large)
            }
            
            Spacer()
            AlertView()
        }
        .scenePadding()
        .frame(width: 800, height: 600)
        .fileImporter(isPresented: $ml.showPicker, allowedContentTypes: [.folder]) { result in
            switch result {
            case .success(let url):
                if let _ = ml.model {
                    ml.save(to: url)
                } else {
                    ml.train(using: url)
                }
            case .failure(_):
                print("No URL selected.")
            }
        }
    }
    
    @ViewBuilder
    func AlertView() -> some View {
        Label {
            Text("This is the machine learning tool. To run Balance Care, select an iPhone as the target device.")
                .foregroundStyle(Color.secondary)
                .font(.footnote)
        } icon: {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.yellow)
                .font(.footnote)
        }
    }
}

#Preview {
    MachineLearningView()
}
