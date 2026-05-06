import Foundation

struct ArchivedFishRecord: Identifiable, Hashable, Codable {
    let id: UUID
    let fishIconName: String
    let habitTitle: String
    let archivedAt: Date

    init(id: UUID = UUID(), fishIconName: String, habitTitle: String, archivedAt: Date = .now) {
        self.id = id
        self.fishIconName = fishIconName
        self.habitTitle = habitTitle
        self.archivedAt = archivedAt
    }

    var spawnStageIconName: String {
        let base = fishIconName.replacingOccurrences(of: "_1", with: "")
        return "\(base)_3"
    }
}
