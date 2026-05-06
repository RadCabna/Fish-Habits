import SwiftUI

struct AppBackgroundLayer: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.textColor1)
                    .ignoresSafeArea()

                Image("appBG")
                    .resizable()
//                    .frame(width: geo.size.width, height: geo.size.height)
                    .ignoresSafeArea()
            }
        }
    }
}

extension View {
    func appRootBackground() -> some View {
        background {
            AppBackgroundLayer()
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundLayer()
        Text("Layer")
            .foregroundStyle(.white)
    }
}
