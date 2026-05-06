import SwiftUI

enum AppFont {
    static func fredoka(_ designPoints: CGFloat) -> Font {
        let s = designPoints * ScreenMetrics.screenHeight * 0.0012315271
        return .custom("FredokaOne-Regular", size: s, relativeTo: .title)
    }

    static func nunitoBold(_ designPoints: CGFloat) -> Font {
        let s = designPoints * ScreenMetrics.screenHeight * 0.0012315271
        return .custom("Nunito-Bold", size: s, relativeTo: .body)
    }

    static func nunitoRegular(_ designPoints: CGFloat) -> Font {
        let s = designPoints * ScreenMetrics.screenHeight * 0.0012315271
        return .custom("Nunito-Regular", size: s, relativeTo: .caption)
    }
}
