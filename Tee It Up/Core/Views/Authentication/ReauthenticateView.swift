//
//  ReauthenticateView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/28/25.
//


// View Page for Re-authentication //
// Used for Deleting Account //

import SwiftUI

struct ReauthenticateView: View {
    // Variables
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack (spacing: 30) {
            // Title
            Text("Please Reauthenticate")
                .font(.title2)
                .fontWeight(.semibold)
            // Form fields
            VStack (spacing: 24) {
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                HStack {
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
            }
            .padding(.top, 12)
            // Button to delete account
            Button {
                Task {
                    // Use Firebase to handle account deletion
                    authViewModel.deleteAccount(email: email, password: password)
                    print("Account deleted successfully.")
                }
                dismiss()
            } label : {
                HStack {
                    Text("DELETE ACCOUNT")
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

// Make sure form is valid
extension ReauthenticateView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && password.count >= 6
    }
}
