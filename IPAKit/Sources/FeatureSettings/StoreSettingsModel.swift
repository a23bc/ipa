import Combine
import FeatureCore
import Foundation
import IPADomain

@MainActor
public final class StoreSettingsModel: ObservableObject {
    public enum EraseStep: Int, CaseIterable, Sendable {
        case confirm, done
    }

    @Published public private(set) var identity: DeviceIdentity?
    @Published public private(set) var isWorking = false
    @Published public var isConfirmingIdentity = false
    @Published public var isErasing = false
    @Published public var eraseStep = EraseStep.confirm
    @Published public var error: IPAError?
    let settings: SettingsModel
    let session: SessionModel
    let preferences: StorePreferences
    let accounts: AccountsModel
    let downloads: DownloadCenter

    public init(
        settings: SettingsModel, session: SessionModel, preferences: StorePreferences,
        accounts: AccountsModel, downloads: DownloadCenter
    ) {
        self.settings = settings
        self.session = session
        self.preferences = preferences
        self.accounts = accounts
        self.downloads = downloads
    }

    var resultsLimit: Int {
        get { preferences.resultsLimit }
        set { preferences.resultsLimit = newValue }
    }

    var availability: EngineAvailability { session.availability }

    func load() async {
        loadIdentity()
        if !downloads.hasLoaded { await downloads.load() }
        await session.refreshAvailability()
    }

    func refreshEngine() async {
        await session.refreshAvailability()
    }

    func startIdentityChange() {
        isConfirmingIdentity = true
    }

    func regenerateIdentity() {
        let vault = session.services.vault
        do {
            for account in try vault.accounts() { try vault.remove(email: account.email) }
            identity = try vault.regenerateIdentity()
            accounts.reset()
            isConfirmingIdentity = false
        } catch {
            self.error = error as? IPAError ?? .onSave
        }
    }

    func startErase() {
        eraseStep = .confirm
        isErasing = true
    }

    func erase() async {
        isWorking = true
        defer { isWorking = false }
        do {
            try session.services.vault.removeAll()
        } catch {
            self.error = error as? IPAError ?? .onRemove
            return
        }
        await downloads.deleteAll()
        accounts.reset()
        preferences.reset()
        loadIdentity()
        session.reload()
        eraseStep = .done
    }

    func closeErase() {
        if eraseStep == .done { settings.reset() }
        eraseStep = .confirm
        isErasing = false
    }

    private func loadIdentity() {
        do {
            identity = try session.services.vault.identity()
        } catch {
            self.error = error as? IPAError ?? .onFetch
        }
    }
}
