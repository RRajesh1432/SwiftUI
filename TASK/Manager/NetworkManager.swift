import Foundation
import Moya

final class NetworkManager {

    static let shared = NetworkManager()

    private let provider = MoyaProvider<ResponseAPI>()

    private init() {}

    private func request(
        _ api: ResponseAPI,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        provider.request(api) { result in

            switch result {

            case .success(let response):

                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    let responseString = String(
                        data: validResponse.data,
                        encoding: .utf8
                    ) ?? ""

                    let apiResponse = APIResponse(
                        statusCode: validResponse.statusCode,
                        rawJSON: responseString
                    )

                    DispatchQueue.main.async {
                        completion(.success(apiResponse))
                    }

                } catch {

                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            case .failure(let error):

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func sendSMSCode(
        phoneNumber: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        request(
            .sendSMSCode(phoneNumber: phoneNumber),
            completion: completion
        )
    }

    func verifySMSCode(
        phoneNumber: String,
        code: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        request(
            .verifySMSCode(
                phoneNumber: phoneNumber,
                code: code
            ),
            completion: completion
        )
    }

    // MARK: - API 3: Sign In

    func signIn(
        phoneNumber: String,
        otp: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        request(
            .signIn(
                phoneNumber: phoneNumber,
                otp: otp
            ),
            completion: completion
        )
    }


    func getScheduledEvents(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        request(
            .scheduledEvents,
            completion: completion
        )
    }

    func getTeams(
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        request(
            .teamsList,
            completion: completion
        )
    }
}
