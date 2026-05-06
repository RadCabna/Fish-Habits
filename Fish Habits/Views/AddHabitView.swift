import SwiftUI
import UIKit

struct AddHabitView: View {
    @Bindable var viewModel: HabitsListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var confirmedFishAsset: String?
    @State private var sheetDraftFish: String?
    @State private var showFishSheet = false
    @State private var keyboardHeight: CGFloat = 0

    private var canSaveHabit: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && confirmedFishAsset != nil
    }

    private let teaserEggAssets: [String] = [
        "Angelfish_1",
        "Betta_Fish_1",
        "Blue_Tang_1",
        "Butterflyfish_1",
        "Clownfish_1",
        "Discus_1",
        "Goldfish_1",
        "Guppy_1",
    ]

    var body: some View {
        ZStack {
            AppBackgroundLayer()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: screenHeight * 0.02) {
                    HStack(spacing: screenHeight * 0.012) {
                        Button {
                            dismiss()
                        } label: {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenHeight * 0.052, height: screenHeight * 0.052)
                        }
                        .buttonStyle(.plain)

                        Text(String(localized: "New Habit"))
                            .font(AppFont.fredoka(26))
                            .foregroundStyle(Color("textColor_1"))
                    }

                    Text(String(localized: "Habit Name"))
                        .font(AppFont.fredoka(16))
                        .foregroundStyle(.white)

                    TextField(
                        "",
                        text: $title,
                        prompt: Text(String(localized: "e.g. \"Reading 20 min\"")).habitPlaceholder()
                    )
                    .habitTextFieldChrome()
                    .padding(.horizontal, screenHeight * 0.02)
                    .frame(height: screenHeight * 0.06)
                    .background(Color.white.opacity(0.44), in: RoundedRectangle(cornerRadius: screenHeight * 0.025, style: .continuous))

                    HStack(alignment: .top, spacing: screenHeight * 0.01) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: screenHeight * 0.016))
                            .foregroundStyle(Color("textColor_1").opacity(0.45))
                        Text(String(localized: "Cannot be changed after saving"))
                            .font(AppFont.nunitoRegular(14))
                            .foregroundStyle(Color("textColor_1").opacity(0.45))
                    }

                    Text(String(localized: "Choose Fish"))
                        .font(AppFont.fredoka(16))
                        .foregroundStyle(.white)
                        .padding(.top, screenHeight * 0.012)

                    Button {
                        dismissKeyboard()
                        sheetDraftFish = confirmedFishAsset
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                            showFishSheet = true
                        }
                    } label: {
                        Group {
                            if let asset = confirmedFishAsset {
                                VStack(spacing: screenHeight * 0.018) {
                                    Image(asset)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenHeight * 0.078, height: screenHeight * 0.078)

                                    Text(FishEggCatalog.displayName(for: asset))
                                        .font(AppFont.nunitoBold(18))
                                        .foregroundStyle(Color("textColor_1"))

                                    Text(String(localized: "Tap to change"))
                                        .font(AppFont.nunitoRegular(14))
                                        .foregroundStyle(Color("textColor_1").opacity(0.55))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, screenHeight * 0.032)
                                .padding(.horizontal, screenHeight * 0.028)
                                .background(Color.white.opacity(0.34), in: RoundedRectangle(cornerRadius: screenHeight * 0.03, style: .continuous))
                            } else {
                                VStack(spacing: screenHeight * 0.015) {
                                    LazyVGrid(
                                        columns: Array(repeating: GridItem(.flexible(), spacing: screenHeight * 0.018), count: 4),
                                        spacing: screenHeight * 0.015
                                    ) {
                                        ForEach(teaserEggAssets, id: \.self) { asset in
                                            Image(asset)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: screenHeight * 0.05, height: screenHeight * 0.05)
                                                .opacity(0.68)
                                        }
                                    }
                                    .padding(.horizontal, screenHeight * 0.06)
                                    .allowsHitTesting(false)

                                    Text(String(localized: "Tap to choose your fish"))
                                        .font(AppFont.nunitoBold(18))
                                        .foregroundStyle(Color("textColor_1"))

                                    Text(String(localized: "20 species available"))
                                        .font(AppFont.nunitoRegular(14))
                                        .foregroundStyle(Color("textColor_1").opacity(0.45))
                                }
                                .padding(.horizontal, screenHeight * 0.035)
                                .padding(.vertical, screenHeight * 0.025)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.34), in: RoundedRectangle(cornerRadius: screenHeight * 0.03, style: .continuous))
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        guard let confirmedFishAsset else { return }
                        viewModel.addHabit(title: title, fishIconName: confirmedFishAsset)
                        dismiss()
                    } label: {
                        Image("saveButton")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: screenHeight * 0.078)
                            .opacity(canSaveHabit ? 1 : 0.55)
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSaveHabit)
                }
                .padding(.horizontal, screenHeight * 0.04)
                .padding(.top, screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.05 + keyboardHeight)
            }
            .dismissKeyboardOnTap()

            if showFishSheet {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                            showFishSheet = false
                        }
                    }

                VStack {
                    Spacer()
                    FishPickerSheetView(
                        draftFish: $sheetDraftFish,
                        onCommit: {
                            confirmedFishAsset = sheetDraftFish
                        },
                        onClose: {
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                                showFishSheet = false
                            }
                        }
                    )
                    .frame(height: screenHeight * 0.82)
                    .shadow(color: Color.black.opacity(0.24), radius: screenHeight * 0.025, y: -screenHeight * 0.004)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .animation(.spring(response: 0.34, dampingFraction: 0.86), value: showFishSheet)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard
                let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
            withAnimation(.easeOut(duration: 0.2)) {
                keyboardHeight = frame.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                keyboardHeight = 0
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview("Add habit") {
    NavigationStack {
        AddHabitView(viewModel: HabitsListViewModel())
    }
}

#Preview("Add habit, dark") {
    NavigationStack {
        AddHabitView(viewModel: HabitsListViewModel())
    }
    .preferredColorScheme(.dark)
}
