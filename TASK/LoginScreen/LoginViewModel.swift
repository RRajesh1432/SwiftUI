import Foundation
import Observation

@Observable
final class ScreenViewModel {

    var model = ScreenModel()

    let useCase: ScreenUseCaseProtocol = ScreenUseCase()

  


    func sendSMSCode() {

        let phone = phoneNumber.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !phone.isEmpty else {
            errorMessage = "Enter your phone number."
            return
        }

        isLoading = true
        errorMessage = ""
        message = ""

        useCase.sendSMSCode(
            phoneNumber: phone
        ) { [weak self] result in

            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):
                    self.message = response.rawJSON

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

 

    func verifySMSCode() {

        let phone = phoneNumber.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let code = otp.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !phone.isEmpty, !code.isEmpty else {
            errorMessage = "Enter your phone number and OTP."
            return
        }

        isLoading = true
        errorMessage = ""
        message = ""

        useCase.verifySMSCode(
            phoneNumber: phone,
            code: code
        ) { [weak self] result in

            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):
                    self.message = response.rawJSON

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signIn() {

        let phone = phoneNumber.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let code = otp.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !phone.isEmpty, !code.isEmpty else {
            errorMessage = "Enter your phone number and OTP."
            return
        }

        isLoading = true
        errorMessage = ""
        message = ""

        useCase.signIn(
            phoneNumber: phone,
            otp: code
        ) { [weak self] result in

            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):
                    self.message = response.rawJSON

                    // Navigate only after HTTP success.
                    self.isShowingHome = true

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

extension ScreenViewModel {
    
    var phoneNumber: String {
        get { model.phoneNumber }
        set { model.phoneNumber = newValue }
    }

    var otp: String {
        get { model.otp }
        set { model.otp = newValue }
    }

    var isLoading: Bool {
        get { model.isLoading }
        set { model.isLoading = newValue }
    }

    var isShowingHome: Bool {
        get { model.isShowingHome }
        set { model.isShowingHome = newValue }
    }

    var message: String {
        get { model.message }
        set { model.message = newValue }
    }

    var errorMessage: String {
        get { model.errorMessage }
        set { model.errorMessage = newValue }
    }

}
