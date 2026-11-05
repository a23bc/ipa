import FeatureCore
import SwiftUI

struct InspectorScreen: View {
    @EnvironmentObject private var navigation: IPANavigation
    let inspector: IPANavigation.Inspector

    var body: some View {
        NavigationView {
            RouteScreen(route: inspector.route)
                .background(
                    PathLinks(
                        path: navigation.inspectorPath,
                        depth: 1,
                        onPop: { count in
                            navigation.inspectorPath = Array(navigation.inspectorPath.prefix(count))
                        },
                        destination: { RouteScreen(route: $0) }
                    )
                )
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Close", systemImage: "xmark") { navigation.closeInspector() }
                    }
                }
        }
        .navigationViewStyle(.stack)
        .environment(\.navigationSection, inspector.section)
        .environment(
            \.close,
            CloseAction { navigation.close(in: inspector.section, inspecting: true) }
        )
        #if os(macOS)
            .inspectorColumnWidth(min: 320, ideal: 400, max: 480)
        #endif
    }
}
