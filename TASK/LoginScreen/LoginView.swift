import SwiftUI

struct LoginView: View {

    @State private var viewModel = ScreenViewModel()

    var body: some View {

        NavigationStack {

            Form {

                Section("Login") {

                    TextField(
                        "Phone number",
                        text: $viewModel.phoneNumber
                    )
                    .keyboardType(.phonePad)

                    Button("Send SMS Code") {
                        viewModel.sendSMSCode()
                    }
                    .disabled(viewModel.isLoading)

                    TextField(
                        "Enter OTP",
                        text: $viewModel.otp
                    )
                    .keyboardType(.numberPad)

                    Button("Verify SMS Code") {
                        viewModel.verifySMSCode()
                    }
                    .disabled(viewModel.isLoading)

                    Button("Sign In") {
                        viewModel.signIn()
                    }
                    .disabled(viewModel.isLoading)
                }


                if viewModel.isLoading {
                    Section {
                        ProgressView("Please wait...")
                    }
                }

                if !viewModel.message.isEmpty {
                    Section("Response") {
                        Text(viewModel.message)
                            .font(.caption)
                            .textSelection(.enabled)
                    }
                }

                if !viewModel.errorMessage.isEmpty {
                    Section("Error") {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Login")
            .navigationDestination(
                isPresented: $viewModel.isShowingHome
            ) {
                HomeView()
            }
        }
    }
}
