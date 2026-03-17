import SwiftUI

struct ExerciseItemView: View {
    @Environment(\.dynamicTypeSize) var typeSize
    
    let type: ViewType
    var exercise: ExerciseWrapper
    
    init(_ type: ViewType = .standard, exercise: ExerciseWrapper) {
        self.type = type
        self.exercise = exercise
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if type == .standard, let image = exercise.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: typeSize.height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(5)
                
                Divider()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.exercise.name)
                        .foregroundStyle(Color.primary)
                        .font(.headline)
                    
                    Text(exercise.exercise.difficulty.rawValue.uppercased())
                        .font(.footnote)
                        .foregroundStyle(
                            exercise.exercise.difficulty.color
                        )
                }
                
                Spacer()
                
                if type == .standard {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.primary.tertiary)
                        .font(.headline)
                }
            }
            .padding(20)
        }
    }

    enum ViewType {
        case standard
        case recommendation
    }
}

fileprivate extension DynamicTypeSize {
    var height: CGFloat {
        switch self {
        case .xSmall:
            200
        case .small:
            200
        case .medium:
            200
        case .large:
            250
        case .xLarge:
            250
        case .xxLarge:
            300
        case .xxxLarge:
            300
        case .accessibility1:
            350
        case .accessibility2:
            350
        case .accessibility3:
            350
        case .accessibility4:
            350
        case .accessibility5:
            350
        default:
            250
        }
    }
}
