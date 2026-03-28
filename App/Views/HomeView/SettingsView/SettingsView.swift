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
                // Notifications
                Section("Notifications") {
                    Picker(time: .morning, label: "AM", selection: $morning)
                    Picker(time: .midday, label: "PM", selection: $midday)
                    Picker(time: .afternoon, label: "PM", selection: $afternoon)
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
                    .listSectionSpacing(15)
                }
                
                // Analytics & Improvements
                ImprovementsView()
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
    
    // MARK: - Notifications
    @AppStorage("MorningDate")
    var morning: Date = .time(hour: 9)
    
    @AppStorage("MiddayDate")
    var midday: Date = .time(hour: 11)
    
    @AppStorage("AfternoonDate")
    var afternoon: Date = .time(hour: 15)
    
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
    
    private var canOpenSettings: Bool {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            return UIApplication.shared.canOpenURL(appSettings)
        }
        
        return false
    }
}

#Preview {
    @Previewable
    @State var isPresented: Bool = true
    
    Button("Present") { isPresented.toggle() }
        .sheet(isPresented: $isPresented) {
            SettingsView(balanceChecks: [])
        }
}
