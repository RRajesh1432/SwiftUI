import Foundation

@Observable
final class Screen2ViewModel {

    var model = Screen2Model()

    let useCase: Screen2UseCaseProtocol = Screen2UseCase()

    func getScheduledEvents() {

        isLoading = true
        errorMessage = ""

        useCase.getScheduledEvents { [weak self] result in

            DispatchQueue.main.async {

                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.eventsResponse = response.scheduleItems

                    print("Scheduled Events API Response:")
                    print(response)

                case .failure(let error):

                    self.errorMessage =
                        "Failed to load events: \(error.localizedDescription)"

                    print(self.errorMessage)
                }
            }
        }
    }


    func getTeams() {

        isLoading = true
        errorMessage = ""

        useCase.getTeams { [weak self] result in

            DispatchQueue.main.async {

                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):

                    self.teamsResponse = response.teams

//                    print("Teams API Response:")
//                    print(response.teams)

                case .failure(let error):

                    self.errorMessage =
                        "Failed to load teams: \(error.localizedDescription)"

                    print(self.errorMessage)
                }
            }
        }
    }


    func loadHomeData() {

        getScheduledEvents()
        getTeams()
    }
}

extension Screen2ViewModel {

    var eventsResponse: [ScheduleItem] {
        get { model.eventsResponse }
        set { model.eventsResponse = newValue }
    }

    var teamsResponse: [TeamElement] {
        get { model.teamsResponse }
        set { model.teamsResponse = newValue }
    }

    var isLoading: Bool {
        get { model.isLoading }
        set { model.isLoading = newValue }
    }

    var errorMessage: String {
        get { model.errorMessage }
        set { model.errorMessage = newValue }
    }

    var teams: String {
        get { model.teams }
        set { model.teams = newValue }
    }
}

