import SwiftUI
import QuickLook

struct ExerciseDetailView: View {
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.dynamicTypeSize) private var typeSize
    
    var exercise: ExerciseWrapper
    
    @State private var showTimer: Bool = false
    @State private var url: URL?
    
    var body: some View {
        List {
            Section {
                if let image = exercise.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .listRowBackground(
                            (contrast == .standard ? Color.clear : Color.primary)
                                .colorInvert()
                        )
                }
            }
            .listSectionSpacing(contrast == .standard ? 0 : 21)
            
            Section {
                HStack {
                    Group {
                        if [.xSmall, .small, .medium, .large, .xLarge].contains(typeSize) {
                            Label(
                                exercise.exercise.difficulty.rawValue,
                                systemImage: "figure.cross.training"
                            )
                        } else {
                            Text(exercise.exercise.difficulty.rawValue)
                        }
                    }
                    .foregroundStyle(exercise.exercise.difficulty.color)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("DefaultListRowColor"))
                    .clipShape(ClipShape())
                    
                    Spacer()
                    
                    Group {
                        if [.xSmall, .small, .medium, .large, .xLarge].contains(typeSize) {
                            Label(
                                exercise.exercise.type.rawValue.capitalized,
                                systemImage: exercise.exercise.type.image
                            )
                        } else {
                            Text(exercise.exercise.type.rawValue.capitalized)
                        }
                    }
                    .foregroundStyle(Color.primary)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("DefaultListRowColor"))
                    .clipShape(ClipShape())
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            Section {
                Text(exercise.exercise.explanation)
                    .lineSpacing(10)
            } header: {
                Text("Description")
            } footer: {
                if exercise.exercise.type == .asymmetric {
                    Text("Because this exercise focuses on one side at a time, remember to repeat the movement on your opposite leg to ensure you build even balance and strength.")
                }
            }
        }
        .navigationTitle(exercise.exercise.name)
        .scrollIndicators(.hidden)
        .quickLookPreview($url)
        .sheet(isPresented: $showTimer) {
            if let seconds = exercise.exercise.seconds {
                TimerView(seconds: seconds)
            }
        }
        .toolbar {
            if let _ = exercise.exercise.seconds {
                Button("Timer", systemImage: "timer") {
                    url = nil
                    showTimer.toggle()
                }
            }
            
            Button("View in AR", systemImage: "arkit") {
                showTimer = false
                url = Bundle.main.url(
                    forResource: exercise.exercise.model, withExtension: "usdz"
                )
            }
        }
    }
    
    
    func ClipShape() -> some Shape {
        if [.xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge].contains(typeSize) {
            return AnyShape(Capsule())
        }
        
        return AnyShape(RoundedRectangle(cornerRadius: 21))
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: ExerciseManager().exercises[0])
    }
}
