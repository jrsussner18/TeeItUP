//
//  ForgotPasswordView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/11/25.
//


// POP UP View UI for Forgot Password // 

import SwiftUI

struct ForgotPasswordView: View {
    // Variables
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    var body: some View {
        VStack (spacing: 30) {
            // Title
            Text("Password Reset")
                .font(.title)
                .fontWeight(.semibold)
            // Input Field
            InputView(text: $email, title: "Enter your email to change password", placeholder: "name@example.com", showTitle: false, customTitle: true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
            // Button to reset password
            Button {
                Task {
                    // User Firebase to send email to reset password
                    try await authViewModel.passwordReset(email: email) { result in
                        switch result {
                        case .success:
                            print("Check email for a reset link")
                        case .failure(let error):
                            print("DEBUG: Failed to send reset email with error: \(error.localizedDescription)")
                        }
                    }
                }
                dismiss()
            } label : {
                HStack {
                    Text("RESET PASSWORD")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
            }
            // Styling
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            .background(Color.clear)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white, lineWidth: 2))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1 : 0.5)
            .padding(.top, 10)
        }
        .padding(.horizontal)
    }
}

// Make sure the form for resseting password is valid
extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@")
    }
}
