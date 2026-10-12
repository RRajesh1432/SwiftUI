import Foundation
import Moya
import Alamofire

enum ResponseAPI {

    case sendSMSCode(phoneNumber: String)

    case verifySMSCode(
        phoneNumber: String,
        code: String
    )

    case signIn(
        phoneNumber: String,
        otp: String
    )

    case scheduledEvents
    case teamsList
}

extension ResponseAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://api-qa.racketmatesapp.com")!
    }

    var path: String {
        switch self {

        case .sendSMSCode:
            return "/verifications/send_sms_code"

        case .verifySMSCode:
            return "/verifications/verify_sms_code"

        case .signIn:
            return "/oauth/token"

        case .scheduledEvents:
            return "/schedule/scheduled_events"

        case .teamsList:
        
            return "/teams"
        }
    }

    var method: Moya.Method {
        switch self {

        case .sendSMSCode, .verifySMSCode, .signIn:
            return .post

        case .scheduledEvents, .teamsList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {

        case .sendSMSCode(let phoneNumber):

            return .requestParameters(
                parameters: [
                    "mobile_number": phoneNumber,
                    "code" : "123456",
                    "country_code": "91",
                    "region_code": "IN"
                ],
                encoding: JSONEncoding.default
            )

        case .verifySMSCode(let phoneNumber, let code):

            return .requestParameters(
                parameters: [
                    "mobile_number": phoneNumber,
                    "country_code": "91",
                    "region_code": "IN",
                    "code": code
                ],
                encoding: JSONEncoding.default
            )

        case .signIn:

            return .requestParameters(
                parameters: [
                    "grant_type": "password",
                    "client_id": "aq8q0cMEcG6uNEy6XDhkSVyJDeFb196QNuUZFqycPDA",
                    "client_secret": "4_rZycZz95HGIFa4z3c1-06Q5Bih76mVxKbv0z04b2U",
                    "username": "9676959866",
                    "verification_code": "9d56d7"
                ],
                encoding: URLEncoding.default
            )

        case .scheduledEvents:

            return .requestParameters(
                parameters: [
                    "events_for": "upcoming"
                ],
                encoding: URLEncoding.queryString
            )

        case .teamsList:

            return .requestParameters(
                parameters: [
                    "page": 1,
                    "query_type": "user_teams",
                    "achived" : false,
                    "per_page": 100,
                    "user_ids[]": 6083,
                    "captain_teams" : true
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {

        switch self {

        case .sendSMSCode, .verifySMSCode:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]

        case .signIn:
            return [
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]

        case .scheduledEvents, .teamsList:
            return [
                "Accept": "application/vnd.appsmaker.io; version=1",
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJhY2UtYXBpIiwiaWF0IjoxNzkxODA5MTkxLCJ0aSI6IjYyZWQ5ZWMyLTE3M2UtNGNlNy1hNjVlLTM0M2QyNGQ4ZjUwMyIsInVzZXIiOnsiaWQiOjYwODQsImVtYWlsIjpudWxsfX0.i4YpbOvPcpQVcxRET1r5tDf0sjBeeSTXm6KvVZOY3NcMrw6RAv10pka8S9_cXuMjJKD-qNd2bqUGiaGmZukkrA"
                
            ]
        }
    }

    var sampleData: Data {
        return Data()
    }
}
