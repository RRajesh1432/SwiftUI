
import Foundation

protocol Screen2UseCaseProtocol {

    func getScheduledEvents(
        completion: @escaping (Result<Event, Error>) -> Void
    )

    func getTeams(
        completion: @escaping (Result<Team, Error>) -> Void
    )
}

final class Screen2UseCase: Screen2UseCaseProtocol {

    func getScheduledEvents(
        completion: @escaping (Result<Event, Error>) -> Void
    ) {
        NetworkManager.shared.getScheduledEvents(
            completion: completion
        )
    }

    func getTeams(
        completion: @escaping (Result<Team, Error>) -> Void
    ) {
        NetworkManager.shared.getTeams(
            completion: completion
        )
    }
}
