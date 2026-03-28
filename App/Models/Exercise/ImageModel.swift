import SwiftUI
import SwiftData

@Model final class ImageModel {
    var exercise: String
    
    init(exercise: String, image: Data?) {
        self.exercise = exercise
        self.image = image
    }
    
    var image: Data?
}
