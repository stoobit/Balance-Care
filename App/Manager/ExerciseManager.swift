import SceneKit.ModelIO
import Foundation
import SwiftData

@Observable final class ExerciseManager {
    var exercises: [ExerciseWrapper] = [
        // Easy Exercises (3)
        ExerciseWrapper(
            name: "Heel-Toe Rock",
            model: "heeltoerock",
            explanation: "Stand tall near a chair. Gently rock back on your heels and then forward onto your toes in a slow rhythm.",
            seconds: 30, type: .symmetric,
            difficulty: .easy
        ),
        ExerciseWrapper(
            name: "Supported Leg Lift",
            model: "supportedleglift",
            explanation: "Hold a chair for support and lift one foot slightly off the floor. Keep your back straight and look forward.",
            seconds: 20, type: .asymmetric,
            difficulty: .easy
        ),
        ExerciseWrapper(
            name: "Side Sway",
            model: "sidesway",
            explanation: "Stand with feet shoulder-width apart. Slowly shift your weight from right to left without moving your feet.",
            seconds: 30, type: .symmetric,
            difficulty: .easy
        ),
        
        // Medium Exercises (3)
        ExerciseWrapper(
            name: "Tandem Stance",
            model: "tandemstance",
            explanation: "Place one foot directly in front of the other so heel touches toe. Hold onto a wall if needed, then try to let go.",
            seconds: 20, type: .asymmetric,
            difficulty: .medium
        ),
        ExerciseWrapper(
            name: "Wall Sit",
            model: "wallsit",
            explanation: "Lean your back against a wall. Slide down slightly by bending your knees and hold the position steadily.",
            seconds: 20, type: .symmetric,
            difficulty: .medium
        ),
        ExerciseWrapper(
            name: "Clock Reach",
            model: "clockreach",
            explanation: "Stand on one leg and lightly hold a chair. With your other foot tap the floor in front, to the side, and behind you.",
            seconds: 30, type: .asymmetric,
            difficulty: .medium
        ),
        
        // Difficult Exercises (3)
        ExerciseWrapper(
            name: "Tightrope Walk",
            model: "tandemstance",
            explanation: "Walk slowly in a straight line placing one foot directly in front of the other. Keep your head up and look forward.",
            seconds: 40, type: .symmetric,
            difficulty: .difficult
        ),
        ExerciseWrapper(
            name: "Flamingo Stand",
            model: "flamingostand",
            explanation: "Stand near a wall but try not to touch it. Lift one foot and balance using only your legs and core strength.",
            seconds: 15, type: .asymmetric,
            difficulty: .difficult
        ),
        ExerciseWrapper(
            name: "High March Pause",
            model: "highmarchpause",
            explanation: "March in place lifting your knees high. Pause for one second every time your leg is in the air before lowering it.",
            seconds: 45, type: .symmetric,
            difficulty: .difficult
        )
    ]
    
    // Images
    var showError: Bool = false
    
    @MainActor
    func images(context: ModelContext) async {
        do {
            if try generationNeeded(context: context) {
                try await generateImages(context: context)
            } else {
                try loadImages(context: context)
            }
        } catch {
            showError = true
        }
    }
    
    @MainActor
    private func loadImages(context: ModelContext) throws {
        let request = FetchDescriptor<ImageModel>()
        let images: [ImageModel] = try context.fetch(request)
        
        for index in 0..<exercises.count {
            let exercise = exercises[index].exercise
            
            if let image = images.first(where: { $0.exercise == exercise.name }),
               let image = image.image {
                
                exercises[index].image = UIImage(data: image)
            }
        }
    }
    
    @MainActor
    private func generateImages(context: ModelContext) async throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        for index in 0..<exercises.count {
            let exercise = exercises[index].exercise
            
            guard let url = Bundle.main.url(
                forResource: exercise.model, withExtension: "usdz"
            ) else {
                continue
            }
            
            let renderer = SCNRenderer(device: device, options: [:])
            renderer.autoenablesDefaultLighting = true
            
            let asset = MDLAsset(url: url)
            asset.loadTextures()
            
            let scene = SCNScene(mdlAsset: asset)
            renderer.scene = scene
            
            let size = CGSize(width: 1024, height: 1024)
            let image = renderer
                .snapshot(atTime: 0, with: size, antialiasingMode: .multisampling4X)
            
            
            exercises[index].image = image
            
            let model = ImageModel(exercise: exercise.name, image: image.pngData())
            context.insert(model)
        }
    }
    
    private func generationNeeded(context: ModelContext) throws -> Bool {
        let request = FetchDescriptor<ImageModel>()
        let count = try context.fetchCount(request)
        
        return count != exercises.count
    }
}
