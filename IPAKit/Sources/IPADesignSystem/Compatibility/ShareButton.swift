import SwiftUI

extension UIApplication {
    private static var compatibleKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static func presentActivitySheet(items: [Any]) {
        guard !items.isEmpty, let window = compatibleKeyWindow else { return }
        var presenter = window.rootViewController
        while let presented = presenter?.presentedViewController { presenter = presented }
        guard let presenter else { return }
        let sheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
        sheet.popoverPresentationController?.sourceView = presenter.view
        sheet.popoverPresentationController?.sourceRect = CGRect(
            x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 1, height: 1)
        presenter.present(sheet, animated: true)
    }
}

/// iOS 15 stand-in for `ShareLink`, presenting `UIActivityViewController` from a button.
public struct ShareButton<Label: View>: View {
    private let items: [Any]
    private let label: Label

    public init(items: [Any], @ViewBuilder label: () -> Label) {
        self.items = items
        self.label = label()
    }

    public var body: some View {
        Button(action: { UIApplication.presentActivitySheet(items: items) }) { label }
    }
}
