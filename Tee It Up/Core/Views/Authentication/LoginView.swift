//
//  LoginView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/7/25.
//

// View Page for Login //

import SwiftUI

struct LoginView: View {
    // Variables
    @State private var email = ""
    @State private var password = ""
    @State private var askPasswordReset: Bool = false
    @State private var otpText: String = ""
    @State private var successfulLogin: Bool = true
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("TeeItUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
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
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign in button
                Button {
                    Task {
                        successfulLogin = try await authViewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
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
                .padding(.bottom, 30)
                
                
                // Sign up button
                // Navigates to RegistrationView
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack (spacing: 3) {
                        Text("Don't have an account? ")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(.white))
                }
                
                // Forgot password button
                Button {
                    askPasswordReset.toggle()
                } label: {
                    Text("Forgot Password?")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
                .foregroundColor(Color(.white))
                .padding(.top, 10)
                
                
                // Add red text if unable to login
                if !successfulLogin {
                    Text("Username or password is incorrect.")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.red))
                        .padding(.top, 10)
                    Spacer()
                }
                Spacer()
            }
            .sheet(isPresented: $askPasswordReset) {
                ForgotPasswordView()
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            }
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

// Make sure form is valid
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 5
    }
    
    // Allow user to hide keyboard once screen is tapped again
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
