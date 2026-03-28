import SwiftUI

struct BalanceActionsView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(BalanceManager.self) var manager
    
    @Namespace private var namespace
    
    var showProgress: Bool
    var color: Color
    
    var body: some View {
        @Bindable var manager = manager
        
        GlassEffectContainer {
            if manager.isAbout {
                BalanceScoreAboutView()
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 30)
                    )
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .glassEffectID("balance.score.about", in: namespace)
                    .glassEffectTransition(.matchedGeometry)
            } else if manager.isExpanded {
                BalanceScoreView(color: color, selection: score)
                    .padding()
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 30)
                    )
                    .glassEffectID("balance.score.score", in: namespace)
                    .glassEffectTransition(.matchedGeometry)
            } else {
                HStack {
                    if manager.isPlaying {
                        BalanceProgressView()
                            .frame(height: 50)
                            .padding(.horizontal)
                            .glassEffect(.regular.interactive(), in: Capsule())
                            .glassEffectID("balance.score.progress", in: namespace)
                            .glassEffectTransition(.matchedGeometry)
                    } else {
                        HStack(spacing: 10) {
                            Circle()
                                .foregroundStyle(color)
                                .frame(width: 7, height: 7)
                            
                            Text(score.title)
                            
                            if showProgress {
                                Image(systemName: progress.image)
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .glassEffect(.regular.interactive(), in: Capsule())
                        .onTapGesture { manager.isExpanded = true }
                        .glassEffectID("balance.score.info", in: namespace)
                        .glassEffectTransition(.matchedGeometry)
                    }
                    
                    Image(systemName: manager.isPlaying ? "xmark" : "play")
                        .symbolVariant(.fill)
                        .imageScale(.large)
                        .contentTransition(.symbolEffect)
                        .frame(width: 50, height: 50)
                        .onTapGesture(perform: onPlay)
                        .glassEffect(.regular.interactive(), in: Circle())
                        .glassEffectID("balance.score.play", in: namespace)
                        .glassEffectTransition(.matchedGeometry)
                }
                .padding(.horizontal, 40)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Your balance is \(score.title.lowercased())."))
        .dynamicTypeSize(accessibilitySize())
        .animation(.bouncy, value: manager.isExpanded)
        .animation(.bouncy, value: manager.isPlaying)
        .animation(.smooth, value: manager.isAbout)
        .scenePadding(.horizontal)
        .padding(.bottom, 20)
    }
    
    private var score: BalanceScore {
        manager.selection?.score ?? .none
    }
    
    private var progress: BalanceProgress {
        manager.selection?.progress ?? .unchanged
    }
    
    private func onPlay() {
        manager.isPlaying.toggle()
        
        if manager.isPlaying {
            manager.id = UUID()
        }
    }
    
    private func accessibilitySize() -> DynamicTypeSize {
        if [.xSmall, .small, .medium, .large, .xLarge].contains(typeSize) {
            return typeSize
        }
        
        return .xxLarge
    }
}
