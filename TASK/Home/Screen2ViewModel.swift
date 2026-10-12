
import Foundation

@Observable
final class Screen2ViewModel {

    var model = Screen2Model()

    let useCase: Screen2UseCaseProtocol = Screen2UseCase()

    // MARK: - Getters and Setters

    var eventsResponse: [[String: String]] {
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

    // MARK: - API Actions

    func getScheduledEvents() {

        isLoading = true
        errorMessage = ""

        useCase.getScheduledEvents { [weak self] result in

            DispatchQueue.main.async {

                guard let self = self else { return }

                self.isLoading = false

                switch result {

                case .success(let response):

                    guard let data = response.rawJSON.data(using: .utf8) else {
                        self.errorMessage = "Unable to read scheduled events."
                        return
                    }

                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data
                        )

                        var eventList: [[String: Any]] = []

                        if let dictionary = json as? [String: Any] {

                            if let events = dictionary["scheduled_events"]
                                as? [[String: Any]] {
                                eventList = events

                            } else if let events = dictionary["events"]
                                as? [[String: Any]] {
                                eventList = events

                            } else if let events = dictionary["data"]
                                as? [[String: Any]] {
                                eventList = events
                            }

                        } else if let events = json as? [[String: Any]] {
                            eventList = events
                        }

                        self.eventsResponse = eventList.map { event in
                            var formattedEvent: [String: String] = [:]

                            for (key, value) in event {
                                formattedEvent[key] = String(
                                    describing: value
                                )
                            }

                            return formattedEvent
                        }

                        if self.eventsResponse.isEmpty {
                            self.errorMessage = "No scheduled events found."
                        }

                    } catch {
                        self.errorMessage =
                            "Failed to read events: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
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

                    self.teams = response.rawJSON

                    guard let data = response.rawJSON.data(using: .utf8) else {
                        self.errorMessage = "Unable to read teams."
                        return
                    }

                    do {
                        let teamData = try JSONDecoder().decode(
                            Team.self,
                            from: data
                        )

                        self.teamsResponse = teamData.teams

                    } catch {
                        self.errorMessage =
                            "Failed to read teams: \(error.localizedDescription)"
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadHomeData() {

        getScheduledEvents()
        getTeams()
    }
}

