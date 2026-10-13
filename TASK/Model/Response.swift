
import Foundation

struct Response {

    static func formatJSON(_ data: Data) -> String {

        do {
            let json = try JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            )

            let formattedData = try JSONSerialization.data(
                withJSONObject: json,
                options: [.prettyPrinted, .fragmentsAllowed]
            )

            if let responseText = String(
                data: formattedData,
                encoding: .utf8
            ) {
                return responseText
            }

            return "Unable to convert response to text"

        } catch {
            return String(
                data: data,
                encoding: .utf8
            ) ?? "Unable to read response"
        }
    }
}


struct VerifyModel: Codable {
    let status: String
    let valid: Bool
    let playerExist: Bool
    let isSignedUp: Bool
    let verificationCode: String

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case valid = "valid"
        case playerExist = "player_exist"
        case isSignedUp = "is_signed_up"
        case verificationCode = "verification_code"
    }
}

struct APIResponse {
    let statusCode: Int
    let rawJSON: String
}

import Foundation

// MARK: - Team
struct Team: Codable {
    let teams: [TeamElement]
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case teams = "teams"
        case meta = "meta"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let total: Int
    let archivedCount: Int

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case archivedCount = "archived_count"
    }
}

// MARK: - TeamElement
struct TeamElement: Codable  {
    let id: Int
    let archived: Bool
    let archivedAt: JSONNull?
    let competitionID: JSONNull?
    let currentUserTeamPlayers: [CurrentUserTeamPlayer]
    let enablePlayerRanking: Bool
    let memberCount: Int
    let name: String
    let samplePlayerAvatarsForTeam: [SamplePlayerAvatarsForTeam]
    let teamSports: [TeamSport]
    let teamType: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case archived = "archived"
        case archivedAt = "archived_at"
        case competitionID = "competition_id"
        case currentUserTeamPlayers = "current_user_team_players"
        case enablePlayerRanking = "enable_player_ranking"
        case memberCount = "member_count"
        case name = "name"
        case samplePlayerAvatarsForTeam = "sample_player_avatars_for_team"
        case teamSports = "team_sports"
        case teamType = "team_type"
    }
}


struct CurrentUserTeamPlayer: Codable {
    let id: Int
    let inactivatedAt: JSONNull?
    let isCaptain: Bool
    let isCoach: Bool
    let isPlayer: Bool
    let user: CurrentUserTeamPlayerUser
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case inactivatedAt = "inactivated_at"
        case isCaptain = "is_captain"
        case isCoach = "is_coach"
        case isPlayer = "is_player"
        case user = "user"
        case userID = "user_id"
    }
}

// MARK: - CurrentUserTeamPlayerUser
struct CurrentUserTeamPlayerUser: Codable {
    let id: Int
    let avatarFileAttachmentURL: JSONNull?
    let clubDetails: [JSONAny]
    let email: JSONNull?
    let firstName: String
    let isSignedUp: Bool
    let lastName: String
    let mobileNumber: String
    let parent: JSONNull?
    let parentUserID: JSONNull?
    let roles: [String]
    let thumbnailAttachmentURL: String
    let uid: String
    let userRoles: [UserRole]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case avatarFileAttachmentURL = "avatar_file_attachment_url"
        case clubDetails = "club_details"
        case email = "email"
        case firstName = "first_name"
        case isSignedUp = "is_signed_up"
        case lastName = "last_name"
        case mobileNumber = "mobile_number"
        case parent = "parent"
        case parentUserID = "parent_user_id"
        case roles = "roles"
        case thumbnailAttachmentURL = "thumbnail_attachment_url"
        case uid = "uid"
        case userRoles = "user_roles"
    }
}

// MARK: - UserRole
struct UserRole: Codable {
    let id: Int
    let role: String
    let userID: Int
    let userRoleSports: [UserRoleSport]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case role = "role"
        case userID = "user_id"
        case userRoleSports = "user_role_sports"
    }
}

// MARK: - UserRoleSport
struct UserRoleSport: Codable {
    let id: Int
    let userRoleID: Int
    let sportType: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userRoleID = "user_role_id"
        case sportType = "sport_type"
    }
}

// MARK: - SamplePlayerAvatarsForTeam
struct SamplePlayerAvatarsForTeam: Codable {
    let id: Int
    let user: SamplePlayerAvatarsForTeamUser

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "user"
    }
}

// MARK: - SamplePlayerAvatarsForTeamUser
struct SamplePlayerAvatarsForTeamUser: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatarFileAttachmentURL: JSONNull?
    let thumbnailAttachmentURL: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarFileAttachmentURL = "avatar_file_attachment_url"
        case thumbnailAttachmentURL = "thumbnail_attachment_url"
    }
}

// MARK: - TeamSport
struct TeamSport: Codable {
    let id: Int
    let sportType: String
    let teamID: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sportType = "sport_type"
        case teamID = "team_id"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}





import Foundation

struct Event: Codable {

    let scheduleItems: [ScheduleItem]

    enum CodingKeys: String, CodingKey {
        case scheduleItems = "schedule_items"
    }
}


import Foundation

struct ScheduleItem: Codable {
    let eventID: Int
    let eventDate: String
    let eventStatus: String
    let eventStatusLabel: String
    let endTimeText: String

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case eventDate = "event_date"
        case eventStatus = "event_status"
        case eventStatusLabel = "event_status_label"
        case endTimeText = "end_time_text"
    }
}
