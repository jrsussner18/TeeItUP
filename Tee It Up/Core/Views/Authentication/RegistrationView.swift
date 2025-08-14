//
//  RegistrationView.swift
//  SwiftUIAuthTutorial
//
//  Created by Jake Sussner on 7/10/25.
//


// View Page for Registration //


import SwiftUI

struct RegistrationView: View {
    // Variables
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var successfulSignUp: Bool = true
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            // Image
            Image("TeeItUp")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            // If unable to sign in, account already exists, display text in red
            if !successfulSignUp {
                Text("Account with this email already exists.")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.red))
                    .padding(.top, 10)
            }
            
            VStack (spacing: 24) {
                // Input fields
                // Email Address
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                
                // Full Name
                InputView(text: $fullName,
                          title: "Full Name",
                          placeholder: "Enter your name")
                
                // Password and Confirm Password
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                HStack {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true) {
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .padding(.trailing, 4)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .onTapGesture {
                self.hideKeyboard()
            }
            
            // Sign up button
            Button {
                Task {
                    // Use Firebase to sign up the user and store the account for later usage
                    successfulSignUp = try await authViewModel.createUser(withEmail: email, password: password, fullName: fullName)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
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
            .padding(.top, 24)
            
            Spacer()
            
            // If the user already has an account, can navigate back to login page
            Button {
                dismiss()
            } label: {
                HStack (spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(.white))
                .font(.system(size: 14))
            }
        }
    }
}

// Make sure the form is valid
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains( "@" )
        && !password.isEmpty
        && password.count >= 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
    
    // Allow the user to hide the keyboard once screen is tapped
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
