import Combine
import Foundation

public final class LanguageSetting: ObservableObject, Sendable {
    public static let shared = LanguageSetting()

    private let storage: LockedValue<Resolved>

    public init(language: AppLanguage = .system) {
        storage = LockedValue(Resolved(language))
    }

    public var language: AppLanguage {
        get {
            storage.withLock { $0.language }
        }
        set {
            objectWillChange.send()
            storage.withLock { $0 = Resolved(newValue) }
        }
    }

    public var locale: Locale {
        storage.withLock { $0.locale }
    }

    public var bundle: Bundle {
        storage.withLock { $0.bundle }
    }

    private struct Resolved: @unchecked Sendable {
        let language: AppLanguage
        let locale: Locale
        let bundle: Bundle

        init(_ language: AppLanguage) {
            self.language = language
            locale = language.locale
            bundle = language.bundle
        }
    }
}

extension Locale {
    public static var app: Locale { LanguageSetting.shared.locale }
}

extension String {
    public init(appLocalized key: String.LocalizationValue) {
        let setting = LanguageSetting.shared
        self.init(localized: key, bundle: setting.bundle, locale: setting.locale)
    }

    public static func localizations(of key: String.LocalizationValue) -> Set<String> {
        Set(
            AppLanguage.languages.map {
                String(localized: key, bundle: $0.bundle, locale: $0.locale)
            })
    }
}
