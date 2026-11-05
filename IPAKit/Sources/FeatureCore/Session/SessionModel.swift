import Combine
import IPADomain

@MainActor
public final class SessionModel: ObservableObject {
    public let repositories: Repositories
    public let services: StoreServices
    @Published public private(set) var generation = 0
    @Published public private(set) var availability: EngineAvailability = .ready

    public init(repositories: Repositories, services: StoreServices) {
        self.repositories = repositories
        self.services = services
    }

    public func reload() {
        generation += 1
    }

    public func refreshAvailability() async {
        availability = await services.engine.availability()
    }
}
