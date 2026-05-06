import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case aquarium = 0
    case archive = 1
    case statistics = 2

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .aquarium: String(localized: "Aquarium")
        case .archive: String(localized: "Archive")
        case .statistics: String(localized: "Statistics")
        }
    }

    var imageName: String {
        switch self {
        case .aquarium: "menuIcon_1"
        case .archive: "menuIcon_2"
        case .statistics: "menuIcon_3"
        }
    }

    var accentColor: Color {
        switch self {
        case .aquarium: Color("appColor_1")
        case .archive: Color("appColor_2")
        case .statistics: Color("appColor_3")
        }
    }
}
