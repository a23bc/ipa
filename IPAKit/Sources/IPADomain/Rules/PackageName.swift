import Foundation

public enum PackageName {
    private static let fileSafe = CharacterSet(
        charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-")
    private static let folderSafe = CharacterSet(
        charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._@-")

    public static func file(bundleID: String, appID: Int64, version: String) -> String {
        let safe = [bundleID, String(appID), version]
            .map { $0.replacingCharacters(notIn: fileSafe, with: "_") }
            .filter { !$0.isEmpty }
        return safe.joined(separator: "_") + ".ipa"
    }

    public static func folder(email: String) -> String {
        let safe = email.lowercased().replacingCharacters(notIn: folderSafe, with: "_")
        return safe.isEmpty ? "account" : safe
    }
}
