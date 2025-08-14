//
//  ProfileView.swift
//  SwiftUIAuthTutorial
//
//  Created by Jake Sussner on 7/10/25.
//

import SwiftUI

struct AccountView: View {
    @State private var askPasswordReset: Bool = false
    @State private var askDeleteAccount: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        if let user = authViewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.black)
                        }
                    }
                }
                
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                    
                }
                
                Section("Account") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .white)
                    }
                    Button {
                        askPasswordReset.toggle()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Change Password", tintColor: .white)
                    }
                    .sheet(isPresented: $askPasswordReset) {
                        ForgotPasswordView()
                            .presentationDetents([.height(300)])
                            .presentationCornerRadius(30)
                    }
                    Button {
                        askDeleteAccount.toggle()
                        print("Deleting account..")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .white)
                    }
                    .sheet(isPresented: $askDeleteAccount) {
                        ReauthenticateView()
                            .presentationDetents([.height(330)])
                            .presentationCornerRadius(30)
                    }
                }
            }
        }
    }
}

#Preview {
    AccountView()
}
