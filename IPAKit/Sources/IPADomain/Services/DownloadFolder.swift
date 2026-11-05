import Foundation

public struct DownloadFolder: Hashable, Sendable {
    public let root: URL

    public init(root: URL) {
        self.root = root
    }

    public static var documents: DownloadFolder {
        DownloadFolder(root: URL.compatibleDocumentsDirectory.appendingPathComponent("Downloads"))
    }

    public func folder(for email: String) -> URL {
        root.appendingPathComponent(PackageName.folder(email: email))
    }

    public func fileURL(for record: DownloadRecord) -> URL {
        folder(for: record.accountEmail).appendingPathComponent(record.fileName)
    }

    public func prepareFolder(for email: String) throws -> URL {
        let url = folder(for: email)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    public func remove(_ record: DownloadRecord) throws {
        let url = fileURL(for: record)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }

    public func removeAll() throws {
        guard FileManager.default.fileExists(atPath: root.path) else {
            return
        }
        try FileManager.default.removeItem(at: root)
    }
}
