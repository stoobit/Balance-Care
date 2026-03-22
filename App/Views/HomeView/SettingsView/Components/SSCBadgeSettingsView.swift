import SwiftUI

struct SwiftStudentChallengeBadge: View {
    var body: some View {
        Section {
            Label(title: {
                Text("Swift Student Challenge 2026 Project")
                    .foregroundStyle(Color.secondary)
            }, icon: {
                Image(systemName: "swift")
                    .foregroundStyle(Color.orange)
            })
            .labelIconToTitleSpacing(6)
            .font(.caption)
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
        }
        .listSectionSpacing(15)
    }
}
