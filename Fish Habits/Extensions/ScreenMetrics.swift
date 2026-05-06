import SwiftUI
import UIKit

enum ScreenMetrics {
    static var screenHeight: CGFloat { UIScreen.main.bounds.height }
    static var screenWidth: CGFloat { UIScreen.main.bounds.width }
    static var habitAquariumCardHeight: CGFloat { screenHeight * 0.298 }
}

extension View {
    var screenHeight: CGFloat { ScreenMetrics.screenHeight }
    var screenWidth: CGFloat { ScreenMetrics.screenWidth }
}
