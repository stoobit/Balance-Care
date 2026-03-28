import SwiftUI

struct SourcesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    if section.links.isEmpty == false {
                        SectionView(for: section)
                    }
                }
            }
            .navigationTitle("Sources")
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func SectionView(for section: SourceSection) -> some View {
        Section {
            ForEach(section.links) { link in
                if let url = link.link {
                    Link(destination: URL(string: url)!) {
                        ListRowItem(link: link)
                    }
                } else {
                    ListRowItem(link: link, hideArrow: true)
                }
            }
        } header: {
            Text(section.title)
        } footer: {
            if let footer = section.footer {
                Text(footer)
            }
        }
    }
    
    @ViewBuilder
    func ListRowItem(link: SourceLink, hideArrow: Bool = false) -> some View {
        HStack {
            Label {
                VStack(alignment: .leading) {
                    Text(link.title)
                        .foregroundStyle(Color.accentColor)
                    
                    Text(link.source)
                        .foregroundStyle(Color.secondary)
                        .font(.caption)
                }
            } icon: {
                Image(systemName: link.image.rawValue)
            }
            
            Spacer()
            
            if hideArrow == false {
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(Color.secondary)
                    .imageScale(.small)
            } else {
                Image(systemName: "person")
                    .foregroundStyle(Color.secondary)
                    .imageScale(.small)
            }
        }
    }
}

let sections: [SourceSection] = [
    SourceSection(title: "Information", links: [
        SourceLink(
            title: "Movement and Polyneuropathy", source: "NCT Heidelberg", image: .information,
            link: "https://www.nct-heidelberg.de/fileadmin/media/nct-heidelberg/flyer/PNP-Broschuere_NCT_20230604_web-komprimiert.pdf"
        ),
        SourceLink(
            title: "Balance Exercises", source: "Lifeline", image: .information,
            link: "https://www.lifeline.ca/en/resources/14-exercises-for-seniors-to-improve-strength-and-balance/"
        ),
        SourceLink(
            title: "Balance Boards", source: "Surfin Balance", image: .information,
            link: "https://surfinbalance.net/en/blogs/news/welches-balanceboard-fur-senioren-tipps-zur-auswahl-des-richtigen-boards"
        ),
    ]),
    SourceSection(title: "Images", links: [
        SourceLink(
            title: "App Icon", source: "Designed by Philipp Aulinger", image: .image,
            link: nil
        ),
        SourceLink(
            title: "Balance Board", source: "Nano Banana Pro", image: .image,
            link: "https://gemini.google.com/"
        ),
    ]),
    SourceSection(title: "3D Models", links: [
        SourceLink(
            title: "SAM 3D Body", source: "Meta AI Research", image: .model,
            link: "https://aidemos.meta.com/segment-anything/editor/convert-body-to-3d"
        ),
    ]),
]
