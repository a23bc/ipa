import FeatureCore
import FeatureGuides
import IPADesignSystem
import IPADomain
import SwiftUI

public struct MainScreen: View {
    @EnvironmentObject private var session: SessionModel
    @EnvironmentObject private var navigation: IPANavigation
    @EnvironmentObject private var launch: LaunchProgress
    @Environment(\.featureFlags) private var flags
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.locale) private var locale
    public init() {}

    @ViewBuilder
    public var body: some View {
        @Bind var navigation = navigation
        TabView(selection: $navigation.selectedSection) {
            ForEach(AppSection.allCases) { section in
                SectionStack(section: section)
                    .tabItem { Label(section.title, systemImage: section.systemImage) }
                    .tag(section)
            }
        }
        .id(locale.identifier)
        .overlay {
            if !launch.isDismissed {
                SplashScreen(progress: launch.fraction, status: launch.status)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.4), value: launch.isDismissed)
        .sheet(item: $navigation.guide) { GuideScreen($0) }
        .environment(\.showGuide, ShowGuideAction { navigation.guide = $0 })
        .routeInspector(isPresented: navigation.isInspecting) {
            if let inspector = navigation.inspector {
                InspectorScreen(inspector: inspector)
            }
        }
        .environment(
            \.open,
            IPADestination { route, section in
                navigation.open(route, in: section, beside: horizontalSizeClass == .regular)
            }
        )
        .change(of: session.generation, initial: true) { launch.finish(.content) }
        .task(id: launch.isComplete) {
            try? await Task.sleep(
                nanoseconds: launch.isComplete ? 600_000_000 : 8_000_000_000)
            launch.dismiss()
        }
        .change(of: navigation.selectedSection) { navigation.closeInspectorOutsideSelection() }
        .modifier(DeepLinks())
    }
}
