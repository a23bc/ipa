import Foundation

extension URL {
    /// Stand-in for `URL.documentsDirectory`, which requires iOS 16.
    static var compatibleDocumentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension String {
    /// Stand-ins for the iOS 16 regex literals, which only match single characters here.
    func replacingCharacters(in set: CharacterSet, with replacement: String) -> String {
        unicodeScalars.map { set.contains($0) ? replacement : String($0) }.joined()
    }

    func replacingCharacters(notIn set: CharacterSet, with replacement: String) -> String {
        replacingCharacters(in: set.inverted, with: replacement)
    }
}
