
import Foundation

struct Screen2Model {

    var eventsResponse: [[String: String]] = []
    var teamsResponse: [TeamElement] = []

    var teams = ""
    var isLoading = false
    var errorMessage = ""
}
