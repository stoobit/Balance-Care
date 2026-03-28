import SwiftUI
import SwiftData

struct CheckInstructionView: View {
    @State var volume = VolumeManager()
    
    @Binding var isPresented: Bool
    var context: BalanceCheckView.Context
    
    @Query(sort: [
        SortDescriptor(\BalanceCheckWrapper.balanceCheck.date, order: .reverse)
    ]) var wrappers: [BalanceCheckWrapper]
    
    @State private var selection: Card? = .exercise
    @State private var balanceCheck: Bool = false
    
    var body: some View {
        ButtonContainer(button: label, disabled: isDisabled) {
            balanceCheck = true
        } content: {
            GeometryReader { proxy in
                let width = proxy.size.width * 0.8
                
                VStack(spacing: 25) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 25) {
                            ForEach(Card.allCases) { card in
                                CheckCardView(
                                    balanceChecks: wrappers,
                                    card: card, width: width
                                )
                                .id(card)
                            }
                        }
                        .padding(.horizontal, proxy.size.width * 0.1)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selection)
                    .scrollIndicators(.hidden)
                    
                    CheckIndicatorView(selection: selection)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
        }
        .navigationDestination(isPresented: $balanceCheck) {
            BalanceCheckView(
                isPresented: $isPresented,
                context: context,
                wrappers: wrappers
            )
        }
    }
    
    private var isDisabled: Bool {
        if wrappers.count < 1 {
            return volumeTooLow || selection != .positioning
        }
        
        return volumeTooLow
    }
    
    private var label: String {
        if wrappers.count < 1 && selection != .positioning {
            return "Continue"
        } else {
            return volumeTooLow ? "Turn Up Your Volume" : "Continue"
        }
    }
    
    private var volumeTooLow: Bool {
        volume.volume < 0.6
    }
}
