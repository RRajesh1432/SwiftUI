import Foundation
import Moya

final class NetworkManager {

    static let shared = NetworkManager()

    private let provider: MoyaProvider<ResponseAPI>

    private init() {
        self.provider = MoyaProvider<ResponseAPI>()
    }


    func sendSMSCode(
        phoneNumber: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        provider.request(.sendSMSCode(phoneNumber: phoneNumber)) { result in

            switch result {

            case .success(let response):
                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    let apiResponse = APIResponse(
                        statusCode: validResponse.statusCode,
                        rawJSON: String(
                            data: validResponse.data,
                            encoding: .utf8
                        ) ?? ""
                    )

                    completion(.success(apiResponse))

                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Verify SMS Code

    func verifySMSCode(
        phoneNumber: String,
        code: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        provider.request(
            .verifySMSCode(
                phoneNumber: phoneNumber,
                code: code
            )
        ) { result in

            switch result {

            case .success(let response):
                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    let apiResponse = APIResponse(
                        statusCode: validResponse.statusCode,
                        rawJSON: String(
                            data: validResponse.data,
                            encoding: .utf8
                        ) ?? ""
                    )

                    completion(.success(apiResponse))

                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signIn(
        phoneNumber: String,
        otp: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        provider.request(
            .signIn(
                phoneNumber: phoneNumber,
                otp: otp
            )
        ) { result in

            switch result {

            case .success(let response):
                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    let apiResponse = APIResponse(
                        statusCode: validResponse.statusCode,
                        rawJSON: String(
                            data: validResponse.data,
                            encoding: .utf8
                        ) ?? ""
                    )

                    completion(.success(apiResponse))

                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTeams(
        completion: @escaping (Result<Team, Error>) -> Void
    ) {
        provider.request(.teamsList) { result in

            switch result {

            case .success(let response):
                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    let teams = try JSONDecoder().decode(
                        Team.self,
                        from: validResponse.data
                    )

                    completion(.success(teams))

                } catch {
                    completion(.failure(error))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
 
    func getScheduledEvents(
        completion: @escaping (Result<Event, Error>) -> Void
    ) {
        provider.request(.scheduledEvents) { result in

            switch result {

            case .success(let response):

                do {
                    let validResponse =
                        try response.filterSuccessfulStatusCodes()

                    print("STATUS CODE:", validResponse.statusCode)

                    print("RAW JSON:")
                    print(
                        String(
                            data: validResponse.data,
                            encoding: .utf8
                        ) ?? "Unable to read response"
                    )

                    let events = try JSONDecoder().decode(
                        Event.self,
                        from: validResponse.data
                    )

                    DispatchQueue.main.async {
                        completion(.success(events))
                    }

                }catch {
                    print("FULL DECODING ERROR:")
                    dump(error)

                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                

            case .failure(let error):
                print("NETWORK ERROR:", error.localizedDescription)

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
