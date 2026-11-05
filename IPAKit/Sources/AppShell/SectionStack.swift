import FeatureCore
import SwiftUI

struct SectionStack: View {
    @EnvironmentObject private var navigation: IPANavigation
    let section: AppSection

    private var path: [Route] { navigation.paths[section, default: []] }

    private var closeAction: CloseAction {
        CloseAction { navigation.close(in: section, inspecting: false) }
    }

    var body: some View {
        NavigationView {
            SectionScreen(section: section)
                .environment(\.close, closeAction)
                .background(
                    PathLinks(
                        path: path,
                        depth: 1,
                        onPop: { count in navigation.paths[section] = Array(path.prefix(count)) },
                        destination: { route in
                            RouteScreen(route: route).environment(\.close, closeAction)
                        }
                    )
                )
        }
        .navigationViewStyle(.stack)
        .environment(\.navigationSection, section)
    }
}
