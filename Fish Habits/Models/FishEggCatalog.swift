import Foundation

enum FishEggCatalog {
    static let levelOneAssets: [String] = [
        "Angelfish_1",
        "Betta_Fish_1",
        "Blue_Tang_1",
        "Butterflyfish_1",
        "Clownfish_1",
        "Discus_1",
        "Emperor_Angelfish_1",
        "Fire_Goby_1",
        "Goldfish_1",
        "Guppy_1",
        "Koi_1",
        "Lionfish_1",
        "Mandarin_Fish_1",
        "Moorish_Idol_1",
        "Neon_Tetra_1",
        "Parrotfish_1",
        "Pufferfish_1",
        "Rainbowfish_1",
        "Seahorse_1",
        "Zebrafish_1",
    ]

    static func displayName(for asset: String) -> String {
        asset
            .replacingOccurrences(of: "_1", with: "")
            .split(separator: "_")
            .map { String($0).capitalized }
            .joined(separator: " ")
    }
}
