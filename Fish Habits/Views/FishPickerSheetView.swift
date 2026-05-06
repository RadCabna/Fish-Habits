import SwiftUI

struct FishPickerSheetView: View {
    @Binding var draftFish: String?
    let onCommit: () -> Void
    let onClose: () -> Void

    private let accent = Color("appColor_1")
    private let sheetBg = Color(red: 0.07, green: 0.1, blue: 0.18)

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(String(localized: "Choose Fish"))
                    .font(AppFont.fredoka(22))
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: ScreenMetrics.screenHeight * 0.015, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(width: ScreenMetrics.screenHeight * 0.042, height: ScreenMetrics.screenHeight * 0.042)
                        .background(Circle().fill(Color.white.opacity(0.12)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, screenHeight * 0.04)
            .padding(.top, screenHeight * 0.022)
            .padding(.bottom, screenHeight * 0.018)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: screenHeight * 0.012), count: 4),
                spacing: screenHeight * 0.01
            ) {
                ForEach(FishEggCatalog.levelOneAssets, id: \.self) { asset in
                    fishTile(asset: asset)
                }
            }
            .padding(.horizontal, screenHeight * 0.024)

            Spacer(minLength: screenHeight * 0.01)
        }
        .frame(maxWidth: .infinity)
        .background(sheetBg)
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: draftFish)
        .clipShape(
            RoundedRectangle(cornerRadius: screenHeight * 0.032, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.032, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                if draftFish != nil {
                    onCommit()
                    onClose()
                }
            } label: {
                Image("selectButton")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.072)
                    .opacity(draftFish == nil ? 0.45 : 1)
                    .shadow(color: accent.opacity(draftFish == nil ? 0.12 : 0.4), radius: screenHeight * 0.012, y: screenHeight * 0.004)
            }
            .buttonStyle(.plain)
            .disabled(draftFish == nil)
            .padding(.horizontal, screenHeight * 0.04)
            .padding(.top, screenHeight * 0.018)
            .padding(.bottom, screenHeight * 0.04)
            .background(sheetBg.opacity(0.98))
        }
    }

    private func fishTile(asset: String) -> some View {
        let selected = draftFish == asset
        let eggSize = screenHeight * 0.042
        return Button {
            draftFish = asset
        } label: {
            VStack(spacing: screenHeight * 0.008) {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: eggSize, height: eggSize)
                    .opacity(selected ? 1 : 0.72)
                    .shadow(color: accent.opacity(selected ? 0.85 : 0), radius: screenHeight * 0.018)
                    .shadow(color: accent.opacity(selected ? 0.5 : 0), radius: screenHeight * 0.026)

                Text(FishEggCatalog.displayName(for: asset))
                    .font(AppFont.nunitoRegular(11))
                    .foregroundStyle(.white.opacity(selected ? 0.95 : 0.72))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .padding(.vertical, screenHeight * 0.012)
            .padding(.horizontal, screenHeight * 0.008)
            .frame(height: screenHeight * 0.112)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: screenHeight * 0.022, style: .continuous)
                    .stroke(selected ? accent : Color.white.opacity(0.18), lineWidth: selected ? screenHeight * 0.0035 : screenHeight * 0.0015)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FishPickerSheetView(draftFish: .constant("Clownfish_1"), onCommit: {}, onClose: {})
}
