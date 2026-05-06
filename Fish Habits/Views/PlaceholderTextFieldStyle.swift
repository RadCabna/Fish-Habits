import SwiftUI

private let placeholderTint = Color(red: 0.56, green: 0.56, blue: 0.58)

struct PlaceholderTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppFont.nunitoRegular(17))
            .textInputAutocapitalization(.sentences)
            .autocorrectionDisabled(false)
    }
}

extension View {
    func habitTextFieldChrome() -> some View {
        modifier(PlaceholderTextFieldStyle())
    }
}

extension Text {
    func habitPlaceholder() -> Text {
        foregroundColor(placeholderTint)
    }
}

#Preview("Placeholder fields") {
    Form {
        Section {
            TextField(
                "",
                text: .constant(""),
                prompt: Text(String(localized: "Sample placeholder")).habitPlaceholder()
            )
            .habitTextFieldChrome()
        }
    }
}

#Preview("Placeholder fields, dark") {
    Form {
        Section {
            TextField(
                "",
                text: .constant(""),
                prompt: Text(String(localized: "Sample placeholder")).habitPlaceholder()
            )
            .habitTextFieldChrome()
        }
    }
    .preferredColorScheme(.dark)
}
