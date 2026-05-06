import Foundation

struct Habit: Identifiable, Hashable, Codable {
    struct LogEntry: Identifiable, Hashable, Codable {
        let id: UUID
        let date: Date
        var note: String

        init(id: UUID = UUID(), date: Date, note: String = "") {
            self.id = id
            self.date = date
            self.note = note
        }
    }

    enum Stage: String, Codable {
        case egg = "Egg"
        case fry = "Fry"
        case adult = "Adult"
        case spawn = "Spawn"
    }

    let id: UUID
    var title: String
    var fishIconName: String
    var streakDays: Int
    var lastLoggedAt: Date?
    var logEntries: [LogEntry]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case fishIconName
        case streakDays
        case lastLoggedAt
        case logEntries
    }

    init(
        id: UUID = UUID(),
        title: String,
        fishIconName: String,
        streakDays: Int = 0,
        lastLoggedAt: Date? = nil,
        logEntries: [LogEntry] = []
    ) {
        self.id = id
        self.title = title
        self.fishIconName = fishIconName
        self.streakDays = streakDays
        self.lastLoggedAt = lastLoggedAt
        self.logEntries = logEntries
    }

    var stage: Stage {
        switch streakDays {
        case 0:
            .egg
        case 1...6:
            .fry
        case 7...29:
            .adult
        default:
            .spawn
        }
    }

    var stageIconName: String {
        let base = fishIconName.replacingOccurrences(of: "_1", with: "")
        switch stage {
        case .egg:
            return "\(base)_1"
        case .fry:
            return "\(base)_2"
        case .adult:
            return "\(base)_3"
        case .spawn:
            return "\(base)_3"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        fishIconName = try container.decode(String.self, forKey: .fishIconName)
        streakDays = try container.decodeIfPresent(Int.self, forKey: .streakDays) ?? 0
        lastLoggedAt = try container.decodeIfPresent(Date.self, forKey: .lastLoggedAt)
        logEntries = try container.decodeIfPresent([LogEntry].self, forKey: .logEntries) ?? []
    }
}
