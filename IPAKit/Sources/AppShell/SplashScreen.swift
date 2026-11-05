import Combine
import FeatureCore
import FeatureSettings
import IPADesignSystem
import SwiftUI

@MainActor
public final class LaunchProgress: ObservableObject {
    public enum Step: CaseIterable, Sendable {
        case database, content

        var status: LocalizedStringKey {
            switch self {
            case .database: "Preparing your data"
            case .content: "Loading your content"
            }
        }
    }

    @Published public private(set) var finished: Set<Step> = []
    @Published public private(set) var isDismissed = false

    public init() {}

    public var fraction: Double { Double(finished.count) / Double(Step.allCases.count) }
    public var isComplete: Bool { finished.count == Step.allCases.count }
    public var status: LocalizedStringKey {
        (Step.allCases.first { !finished.contains($0) } ?? .content).status
    }

    public func finish(_ step: Step) {
        finished.insert(step)
    }

    public func dismiss() {
        isDismissed = true
    }
}

public struct SplashScreen<Footer: View>: View {
    @EnvironmentObject private var settings: SettingsModel
    @Environment(\.appTint) private var appTint
    private let progress: Double?
    private let status: LocalizedStringKey?
    private let footer: Footer

    public init(
        progress: Double? = nil, status: LocalizedStringKey? = nil,
        @ViewBuilder footer: () -> Footer
    ) {
        self.progress = progress
        self.status = status
        self.footer = footer()
    }

    public var body: some View {
        VStack(spacing: .spaceL) {
            AppIconImage(icon: settings.appIcon, size: .badgeXL * 2)
                .shadow(color: .black.opacity(.opacityFill), radius: .spaceM, y: .spaceS)
            Text(verbatim: "IPA")
                .font(.titleLarge)
            VStack(spacing: .spaceS) {
                if let progress {
                    ProgressView(value: progress)
                        .accentColor(appTint)
                        .frame(maxWidth: .ring * 2)
                }
                if let status {
                    Text(status)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .animation(.easeOut(duration: 0.25), value: progress)
            footer
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.groupedBackground)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Opening IPA")
    }
}

extension SplashScreen where Footer == EmptyView {
    public init(progress: Double? = nil, status: LocalizedStringKey? = nil) {
        self.init(progress: progress, status: status) { EmptyView() }
    }
}
