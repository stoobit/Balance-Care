import SwiftUI
import SwiftData

struct BalanceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(BalanceManager.self) var manager
    
    @Query(sort: [
        SortDescriptor(\BalanceCheckWrapper.balanceCheck.date, order: .reverse)
    ]) var wrappers: [BalanceCheckWrapper]
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                let step = $0.size.width / 8.0
                let offset = -1.5 * step
                
                ZStack(alignment: .bottom) {
                    BalanceBackgroundView()
                        .backgroundExtensionEffect()
                        .overlay {
                            BalanceGraphicView(color: relevance)
                                .offset(y: offset)
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .animation(.smooth, value: manager.isAbout)
                    
                    VStack(spacing: 0) {
                        Rectangle()
                            .opacity(0)
                            .contentShape(Rectangle())
                            .onTapGesture { manager.isExpanded = false }
                            .frame(maxHeight: manager.isAbout ? 0 : .infinity)
                        
                        BalanceActionsView(
                            showProgress: showProgress, color: relevance
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .toolbar { BalanceViewToolbar(wrappers: wrappers) }
                .navigationTitle("Balance")
                .navigationSubtitle(date)
                .defaultViewStyle()
            }
            .overlay(alignment: .top) {
                BalanceToastView()
            }
        }
        .environment(manager)
    }
    
    private var showProgress: Bool {
        manager.selection?.id != wrappers.last?.balanceCheck.id
    }

    private var date: String {
        "\(manager.selection?.date.string, default: "")"
    }
    
    private var relevance: Color {
        guard let newest = wrappers.first?.balanceCheck.id else {
            return .gray
        }
        
        let isNewest = newest == manager.selection?.id
        return isNewest ? .accentColor : .secondaryAccentColor
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(.secondarySystemBackground)
    }
}
