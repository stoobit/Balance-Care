import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    @State var status: UNAuthorizationStatus = .notDetermined
    var balanceChecks: [BalanceCheckWrapper]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notifications") {
                    Picker(.morning, selection: $morning, label: "AM")
                    Picker(.midday, selection: $midday, label: "PM")
                    Picker(.afternoon, selection: $afternoon, label: "PM")
                }
                
                if canOpenSettings {
                    Section {
                        Button(action: openSettings) {
                            HStack {
                                let action = status == .authorized ? "Disable" : "Enable"
                                Text("\(action) Notifications")
                                Spacer()
                                
                                if status != .notDetermined {
                                    Image(systemName: "arrow.up.right")
                                        .foregroundStyle(Color.secondary)
                                        .imageScale(.small)
                                }
                            }
                        }
                        .onChange(of: scenePhase, permissionStatus)
                        .onAppear(perform: permissionStatus)
                    }
                    .listSectionSpacing(21)
                }
                
                SwiftStudentChallengeBadge()
            }
            .onChange(of: afternoon, setNotifications)
            .onChange(of: morning, setNotifications)
            .onChange(of: midday, setNotifications)
            .navigationTitle("Settings")
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
    func Picker(_ time: Timestamp, selection: Binding<Date>, label: String) -> some View {
        DatePicker(
            selection: selection, in: self.range(for: time),
            displayedComponents: .hourAndMinute
        ) {
            Label {
                VStack(alignment: .leading) {
                    Text(time.title.capitalized)
                    Text("until \(time.range.upperBound):00 \(label)")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            } icon: {
                Image(systemName: "bell.badge")
            }
        }
    }
    
    @ViewBuilder
    func SwiftStudentChallengeBadge() -> some View {
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
    
    // MARK: - Notifications
    private func range(for timestamp: Timestamp) -> ClosedRange<Date> {
        switch timestamp {
        case .morning:
            let lower = Date.time(hour: Date.morning.lowerBound)
            let upper = Date.time(hour: Date.morning.upperBound - 1, minute: 30)
            
            return lower...upper
        case .midday:
            let lower = Date.time(hour: Date.midday.lowerBound)
            let upper = Date.time(hour: Date.midday.upperBound - 1, minute: 30)
            
            return lower...upper
        case .afternoon:
            let lower = Date.time(hour: Date.afternoon.lowerBound)
            let upper = Date.time(hour: Date.afternoon.upperBound)
            
            return lower...upper
        }
    }
    
    private func setNotifications() {
        if balanceChecks.count > 0 {
            NotificationManager
                .setNotifications(morning, midday, afternoon)
        }
    }
    
    private func permissionStatus() {
        Task {
            status = await NotificationManager.authorizationStatus()
        }
    }
    
    private func openSettings() {
        if status != .notDetermined, canOpenSettings {
            openURL(URL(string: UIApplication.openSettingsURLString)!)
        } else {
            Task {
                await NotificationManager.askPermission()
                setNotifications()
            }
        }
    }
    
    var canOpenSettings: Bool {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            return UIApplication.shared.canOpenURL(appSettings)
        }
        
        return false
    }
    
    @AppStorage("MorningDate")
    var morning: Date = .time(hour: 9)
    
    @AppStorage("MiddayDate")
    var midday: Date = .time(hour: 11)
    
    @AppStorage("AfternoonDate")
    var afternoon: Date = .time(hour: 15)
}

#Preview {
    @Previewable
    @State var isPresented: Bool = true
    
    Button("Present") { isPresented.toggle() }
        .sheet(isPresented: $isPresented) {
            SettingsView(balanceChecks: [])
        }
}
