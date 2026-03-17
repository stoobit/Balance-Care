import SwiftUI

struct ExerciseWrapper: Identifiable {
    var id: String { exercise.name }
    
    var exercise: ExerciseModel
    var image: UIImage?
    
    init(
        isStandard: Bool = false, name: String, model: String, explanation: String,
        seconds: TimeInterval?, type: ExerciseType, difficulty: ExerciseDifficulty
    ) {
        self.exercise = ExerciseModel(
            isStandard: isStandard, name: name, model: model, explanation: explanation,
            seconds: seconds, type: type, difficulty: difficulty
        )
    }
}

struct ExerciseModel: Identifiable, Hashable, Codable {
    // Exercise Structure
    var id: String { name }
    var isStandard: Bool = false
    
    let name: String
    let model: String
    let explanation: String
    
    let seconds: TimeInterval?
    
    let type: ExerciseType
    let difficulty: ExerciseDifficulty
    
    // Time of Exercise
    var time: Timestamp?
}

extension ExerciseModel {
    init(exercise: Self, time: Timestamp) {
        self = exercise
        self.time = time
    }
}

extension [ExerciseModel] {
    var times: [Timestamp?] {
        self.map { $0.time }
    }
}


