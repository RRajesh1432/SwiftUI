
import Foundation

protocol Screen2UseCaseProtocol {

    func getScheduledEvents(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    )

    func getTeams(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    )
}

final class Screen2UseCase: Screen2UseCaseProtocol {

    func getScheduledEvents(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        NetworkManager.shared.getScheduledEvents(
            completion: completion
        )
    }

    func getTeams(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        NetworkManager.shared.getTeams(
            completion: completion
        )
    }
}
