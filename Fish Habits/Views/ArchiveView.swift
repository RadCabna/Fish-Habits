import SwiftUI

struct ArchiveView: View {
    @Bindable var viewModel: HabitsListViewModel

    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenHeight * 0.012),
            GridItem(.flexible(), spacing: screenHeight * 0.012),
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(localized: "Archive"))
                .font(AppFont.fredoka(28))
                .foregroundStyle(Color("textColor_1"))
                .padding(.top, screenHeight * 0.009852)

            if viewModel.archivedFish.isEmpty {
                Spacer(minLength: 0)
                VStack(spacing: screenHeight * 0.016) {
                    Text(String(localized: "Your collection is empty"))
                        .font(AppFont.nunitoBold(18))
                        .italic()
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)

                    Text(String(localized: "Complete a 30-day habit streak to grow your first fish"))
                        .font(AppFont.nunitoRegular(15))
                        .italic()
                        .foregroundStyle(Color.white.opacity(0.92))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, screenHeight * 0.06)
                Spacer(minLength: 0)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridColumns, spacing: screenHeight * 0.012) {
                        ForEach(viewModel.archivedFish) { record in
                            ArchiveFishCardView(record: record)
                        }
                    }
                    .padding(.top, screenHeight * 0.016)
                    .padding(.bottom, screenHeight * 0.16)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, screenHeight * 0.024631)
    }
}

#Preview {
    ZStack {
        AppBackgroundLayer()
        ArchiveView(viewModel: HabitsListViewModel())
    }
}
