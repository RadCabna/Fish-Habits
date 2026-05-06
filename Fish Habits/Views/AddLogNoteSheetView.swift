import SwiftUI

struct AddLogNoteSheetView: View {
    let entryDate: Date
    @Binding var noteText: String
    let onSave: () -> Void
    let onClose: () -> Void

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.018) {
            HStack {
                Text(String(localized: "Add Note"))
                    .font(AppFont.fredoka(24))
                    .foregroundStyle(Color("textColor_1"))
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: screenHeight * 0.016, weight: .semibold))
                        .foregroundStyle(Color("textColor_1").opacity(0.6))
                        .frame(width: screenHeight * 0.046, height: screenHeight * 0.046)
                        .background(Circle().fill(Color.white.opacity(0.35)))
                }
                .buttonStyle(.plain)
            }

            Text(formatter.string(from: entryDate))
                .font(AppFont.nunitoRegular(16))
                .foregroundStyle(Color("textColor_1").opacity(0.7))
                .padding(.horizontal, screenHeight * 0.02)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: screenHeight * 0.055)
                .background(Color.white.opacity(0.35), in: RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous))

            TextEditor(text: $noteText)
                .font(AppFont.nunitoRegular(16))
                .foregroundStyle(Color("textColor_1"))
                .scrollContentBackground(.hidden)
                .padding(screenHeight * 0.01)
                .frame(height: screenHeight * 0.13)
                .background(Color.white.opacity(0.35), in: RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                        .stroke(Color("textColor_1").opacity(0.16), lineWidth: 1)
                )
                .overlay(alignment: .topLeading) {
                    if noteText.isEmpty {
                        Text(String(localized: "e.g. \"Ran in the morning\" or \"Missed due to illness\""))
                            .font(AppFont.nunitoRegular(14))
                            .foregroundStyle(Color("textColor_1").opacity(0.45))
                            .padding(.top, screenHeight * 0.022)
                            .padding(.leading, screenHeight * 0.02)
                            .allowsHitTesting(false)
                    }
                }

            Button(action: onSave) {
                Image("saveButton")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.078)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, screenHeight * 0.04)
        .padding(.top, screenHeight * 0.03)
        .padding(.bottom, screenHeight * 0.035)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.75), in: RoundedRectangle(cornerRadius: screenHeight * 0.04, style: .continuous))
        .dismissKeyboardOnTap()
    }
}

#Preview {
    AddLogNoteSheetView(entryDate: .now, noteText: .constant(""), onSave: {}, onClose: {})
        .padding()
        .background(AppBackgroundLayer())
}
