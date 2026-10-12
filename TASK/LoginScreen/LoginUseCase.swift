import Foundation

protocol ScreenUseCaseProtocol {

    func sendSMSCode(
        phoneNumber: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    )

    func verifySMSCode(
        phoneNumber: String,
        code: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    )

    func signIn(
        phoneNumber: String,
        otp: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    )
}

final class ScreenUseCase: ScreenUseCaseProtocol {

   

    func sendSMSCode(
        phoneNumber: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        NetworkManager.shared.sendSMSCode(
            phoneNumber: phoneNumber,
            completion: completion
        )
    }

    func verifySMSCode(
        phoneNumber: String,
        code: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        NetworkManager.shared.verifySMSCode(
            phoneNumber: phoneNumber,
            code: code,
            completion: completion
        )
    }



    func signIn(
        phoneNumber: String,
        otp: String,
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        NetworkManager.shared.signIn(
            phoneNumber: phoneNumber,
            otp: otp,
            completion: completion
        )
    }
}
