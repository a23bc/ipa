import Combine
import AppShell
import FeatureCore
import FeatureSettings
import IPAData
import SwiftUI

@main
struct IPAApp: App {
    @StateObject private var settings: SettingsModel
    @StateObject private var bootstrap: IPABootstrap

    init() {
        let settings = SettingsModel()
        _settings = StateObject(wrappedValue: settings)
        _bootstrap = StateObject(wrappedValue: IPABootstrap())
    }

    var body: some Scene {
        WindowGroup {
            IPARootView()
                .environmentObject(bootstrap)
                .featureFlags(bootstrap.flags)
                .ipaSettings(settings)
        }
        #if os(macOS)
            Settings {
                NavigationStack { SettingsScreen() }
                    .featureFlags(bootstrap.flags)
                    .ipaSettings(settings)
            }
        #endif
    }
}

@MainActor
private final class IPABootstrap: ObservableObject {
    @Published private(set) var database: IPADatabase?
    @Published private(set) var error: String?
    let flags: FeatureFlags

    init() {
        flags = FeatureFlags()
    }

    func prepare() async {
        guard database == nil else { return }
        error = nil
        do {
            database = try await IPAServices.shared.database()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

private struct IPARootView: View {
    @EnvironmentObject private var bootstrap: IPABootstrap
    @State private var window: IPAWindow?
    @StateObject private var launch = LaunchProgress()
    @State private var attempt = 0

    var body: some View {
        Group {
            if let window {
                MainScreen().ipaWindow(window).environmentObject(launch)
            } else if let error = bootstrap.error {
                UnavailableState {
                    Label(
                        "Couldn't open IPA",
                        systemImage: "externaldrive.badge.exclamationmark")
                } description: {
                    Text(error)
                } actions: {
                    Button("Try Again") { attempt += 1 }
                }
            } else {
                SplashScreen(progress: launch.fraction, status: launch.status)
            }
        }
        .task(id: attempt) {
            guard window == nil else { return }
            await bootstrap.prepare()
            guard !Task.isCancelled else { return }
            if let database = bootstrap.database {
                window = IPAWindow(provider: database, services: IPAServices.shared.store)
                launch.finish(.database)
            }
        }
    }
}
