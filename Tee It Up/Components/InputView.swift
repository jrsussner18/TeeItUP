//
//  InputView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/10/25.
//


// View Builder file
// Handles the UI for all input fields
import SwiftUI

struct InputView<Trailing: View>: View {
    // Variables
    @State private var showPassword: Bool = false
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var showTitle: Bool = true
    var customTitle: Bool = false
    var trailingOverlay: () -> Trailing

    init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        isSecureField: Bool = false,
        showTitle: Bool = true,
        customTitle: Bool = false,
        @ViewBuilder trailingOverlay: @escaping () -> Trailing = { EmptyView() }
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.isSecureField = isSecureField
        self.showTitle = showTitle
        self.customTitle = customTitle
        self.trailingOverlay = trailingOverlay
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if showTitle {
                Text(title)
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
            }

            if customTitle {
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
            }

            HStack {
                if isSecureField {
                    if showPassword {
                        TextField(placeholder, text: $text)
                            .font(.system(size: 14))
                    } else {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 14))
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                }
                
                trailingOverlay()
                if isSecureField {
                    Button {
                        withAnimation {
                            showPassword.toggle()
                        }
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}
