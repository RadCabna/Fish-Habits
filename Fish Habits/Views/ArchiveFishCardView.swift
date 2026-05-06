import SwiftUI

struct ArchiveFishCardView: View {
    let record: ArchivedFishRecord

    private var dateLine: String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "MMM d, yy"
        return f.string(from: record.archivedAt)
    }

    private var dividerGold: Color {
        Color(red: 1, green: 0.82, blue: 0.25)
    }

    var body: some View {
        VStack(spacing: screenHeight * 0.01) {
            HStack {
                Label {
                    Text(String(localized: "Completed"))
                        .font(AppFont.nunitoBold(13))
                        .foregroundStyle(.white)
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: screenHeight * 0.013, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, screenHeight * 0.012)
                .padding(.vertical, screenHeight * 0.006)
                .background(Color.green.opacity(0.82), in: Capsule())

                Spacer(minLength: 0)
            }

            Image(record.spawnStageIconName)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.072)
                .shadow(color: Color.black.opacity(0.15), radius: screenHeight * 0.01, y: screenHeight * 0.003)

            Text(FishEggCatalog.displayName(for: record.fishIconName))
                .font(AppFont.nunitoBold(22))
                .foregroundStyle(Color("textColor_1"))
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)

            Spacer(minLength: 0)

            Rectangle()
                .fill(dividerGold.opacity(0.95))
                .frame(height: screenHeight * 0.002)
                .padding(.horizontal, screenHeight * 0.006)

            Text(dateLine)
                .font(AppFont.nunitoRegular(16))
                .foregroundStyle(Color("textColor_1").opacity(0.5))

            Text(record.habitTitle)
                .font(AppFont.nunitoRegular(16))
                .italic()
                .foregroundStyle(Color("textColor_1"))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, screenHeight * 0.017)
        .padding(.vertical, screenHeight * 0.013)
        .frame(height: ScreenMetrics.habitAquariumCardHeight, alignment: .top)
        .background(Color("appColor_4"), in: RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous)
                .stroke(Color.white.opacity(0.95), lineWidth: screenHeight * 0.0037)
        )
    }
}

#Preview {
    ZStack {
        AppBackgroundLayer()
        HStack(spacing: ScreenMetrics.screenHeight * 0.012) {
            ArchiveFishCardView(
                record: ArchivedFishRecord(fishIconName: "Angelfish_1", habitTitle: String(localized: "Read 20 min"))
            )
            ArchiveFishCardView(
                record: ArchivedFishRecord(
                    fishIconName: "Clownfish_1",
                    habitTitle: String(localized: "Very long habit title example")
                )
            )
        }
        .padding(.horizontal, ScreenMetrics.screenHeight * 0.025)
    }
}
