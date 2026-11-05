import Foundation
import IPADomain

/// SwiftData needs iOS 17, so records live in one JSON file behind an actor.
actor DownloadJournal {
    private let fileURL: URL?
    private var records: [DownloadRecord]?

    init(fileURL: URL?) {
        self.fileURL = fileURL
    }

    func all() throws -> [DownloadRecord] {
        loaded().sorted {
            if $0.downloadedAt != $1.downloadedAt { return $0.downloadedAt > $1.downloadedAt }
            return $0.id < $1.id
        }
    }

    func save(_ record: DownloadRecord) throws {
        var current = loaded()
        if let index = current.firstIndex(where: { $0.id == record.id }) {
            current[index] = record
        } else {
            current.append(record)
        }
        try store(current)
    }

    func remove(id: String) throws {
        var current = loaded()
        guard let index = current.firstIndex(where: { $0.id == id }) else {
            throw IPAError.missingRecord
        }
        current.remove(at: index)
        try store(current)
    }

    func removeAll() throws {
        try store([])
    }

    private func loaded() -> [DownloadRecord] {
        if let records { return records }
        guard let fileURL, let data = try? Data(contentsOf: fileURL),
            let decoded = try? JSONDecoder().decode([DownloadRecord].self, from: data)
        else {
            records = []
            return []
        }
        records = decoded
        return decoded
    }

    private func store(_ value: [DownloadRecord]) throws {
        records = value
        guard let fileURL else { return }
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            try encoder.encode(value).write(to: fileURL, options: .atomic)
        } catch {
            throw IPAError.onSave
        }
    }
}

struct JSONDownloadRepository: DownloadRepository {
    private let journal: DownloadJournal

    init(fileURL: URL?) {
        journal = DownloadJournal(fileURL: fileURL)
    }

    func records() async throws -> [DownloadRecord] { try await journal.all() }

    func save(_ record: DownloadRecord) async throws { try await journal.save(record) }

    func delete(id: String) async throws { try await journal.remove(id: id) }

    func deleteAll() async throws {
        do {
            try await journal.removeAll()
        } catch {
            throw IPAError.onRemove
        }
    }
}
