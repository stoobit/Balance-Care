import SwiftUI

struct AboutModel: Identifiable {
    var id: Int
    
    var title: String
    var image: String
    
    var description: String
}

let cards: [AboutModel] = [
    AboutModel(
        id: 0,
        title: "Balance and Aging",
        image: "figure.taichi",
        description: """
                     As we age, our sense of balance naturally declines. This is often due to age-related changes in muscles, joints, and the nervous system. In many older adults, the situation is further worsened by conditions such as polyneuropathy, which impairs nerve function and makes it even harder to maintain stability.
                     """
    ),
    AboutModel(
        id: 1,
        title: "Train Your Balance",
        image: "figure.cross.training",
        description: """
                     Even though aging and conditions like polyneuropathy can make balance harder, these challenges can be improved with targeted exercises. Balance Care guides you through simple routines that strengthen stability, boost confidence, and reduce the risk of falls – helping you stay active and independent longer.
                     """
    ),
    AboutModel(
        id: 2,
        title: "How It Works",
        image: "app.badge",
        description: """
                     Each day, you'll get three reminders (morning, midday, and afternoon) to do exercises that fit your current balance level. Once a week, you'll be prompted to do a short Balance Check to see your progress and adjust the exercises. Multiple sessions throughout the day help strengthen your balance more effectively over time.
                     """
    ),
]
