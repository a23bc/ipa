import Foundation
import IPADomain

public struct IPADatabase: RepositoryProvider {
    private let downloads: JSONDownloadRepository

    private init(storeURL: URL?) {
        downloads = JSONDownloadRepository(fileURL: storeURL)
    }

    public static func open(inMemory: Bool = false, storeURL: URL? = nil) throws -> IPADatabase {
        if inMemory { return IPADatabase(storeURL: nil) }
        return IPADatabase(storeURL: storeURL ?? Self.journalURL)
    }

    public var storeURL: URL? { Self.journalURL }

    public var repositories: Repositories { Repositories(downloads: downloads) }

    private static var journalURL: URL {
        let folder = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return folder.appendingPathComponent("IPA", isDirectory: true)
            .appendingPathComponent("downloads.json")
    }
}
