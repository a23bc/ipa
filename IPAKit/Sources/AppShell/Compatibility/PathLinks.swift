import FeatureCore
import SwiftUI

/// Emulates `NavigationStack(path:)` on iOS 15: one hidden `NavigationLink` per path level, each
/// hosting the next level so pushes and interactive pops both keep working.
struct PathLinks<Destination: View>: View {
    let path: [Route]
    let depth: Int
    let onPop: (Int) -> Void
    let destination: (Route) -> Destination

    var body: some View {
        if depth <= path.count {
            NavigationLink(
                destination: destination(path[depth - 1])
                    .background(PathLinks(
                        path: path, depth: depth + 1, onPop: onPop, destination: destination)),
                isActive: Binding(
                    get: { depth <= path.count },
                    set: { open in if !open { onPop(depth - 1) } })
            ) {
                EmptyView()
            }
            .hidden()
        } else {
            EmptyView()
        }
    }
}
