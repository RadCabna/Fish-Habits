import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: AppTab

    private var spring: Animation {
        .spring(response: 0.42, dampingFraction: 0.76, blendDuration: 0.2)
    }

    var body: some View {
        GeometryReader { geo in
            let columns = CGFloat(AppTab.allCases.count)
            let cellW = geo.size.width / columns
            let pillW = cellW * 0.46
            let pillH = screenHeight * 0.0049
            let pillX = cellW * CGFloat(selectedTab.rawValue) + (cellW - pillW) * 0.5

            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Color.clear
                        .frame(height: screenHeight * 0.016)

                    RoundedRectangle(cornerRadius: pillH / 2, style: .continuous)
                        .fill(selectedTab.accentColor)
                        .frame(width: pillW, height: pillH)
                        .shadow(color: selectedTab.accentColor.opacity(0.92), radius: screenHeight * 0.0062, x: 0, y: 0)
                        .shadow(color: selectedTab.accentColor.opacity(0.65), radius: screenHeight * 0.0148, x: 0, y: screenHeight * 0.0012)
                        .offset(x: pillX, y: screenHeight * 0.0049)
                }

                HStack(spacing: 0) {
                    ForEach(AppTab.allCases) { tab in
                        Button {
                            withAnimation(spring) {
                                selectedTab = tab
                            }
                        } label: {
                            tabColumn(tab: tab, isSelected: selectedTab == tab)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, screenHeight * 0.004)
                .padding(.bottom, screenHeight * 0.014)
            }
            .background(
                Color(.textColor1)
            )
        }
        .frame(maxHeight: screenHeight * 0.075, alignment: .bottom)
//        .frame(height: screenHeight * 0.075)
    }

    @ViewBuilder
    private func tabColumn(tab: AppTab, isSelected: Bool) -> some View {
        VStack(spacing: screenHeight * 0.002) {
            Image(tab.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.032)
                .opacity(isSelected ? 1 : 0.42)
                .shadow(color: tab.accentColor.opacity(isSelected ? 0.95 : 0), radius: isSelected ? screenHeight * 0.012315 : 0, x: 0, y: 0)
                .shadow(color: tab.accentColor.opacity(isSelected ? 0.55 : 0), radius: isSelected ? screenHeight * 0.019704 : 0, x: 0, y: screenHeight * 0.002463)
                .offset(y: -screenHeight * 0.002)

            Text(tab.title)
                .font(AppFont.nunitoRegular(11))
                .foregroundStyle(isSelected ? tab.accentColor : Color.white.opacity(0.42))
                .shadow(color: tab.accentColor.opacity(isSelected ? 0.7 : 0), radius: isSelected ? screenHeight * 0.006 : 0, x: 0, y: 0)
                .offset(y: -screenHeight * 0.003)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(tab.title)
    }
}

#Preview("Aquarium selected") {
    ZStack {
        AppBackgroundLayer()
        VStack {
            Spacer()
            CustomTabBarView(selectedTab: .constant(.aquarium))
        }
    }
}
