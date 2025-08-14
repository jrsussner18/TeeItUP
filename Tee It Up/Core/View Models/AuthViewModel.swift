//
//  AuthViewModel.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/10/25.
//


// Handling all account related processes
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import SwiftSMTP

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    // Published variables for user
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // Function for signing in
    func signIn(withEmail email: String, password: String) async throws -> Bool {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            return true
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            return false
        }
    }
    
    // Function for creating user
    func createUser(withEmail email: String, password: String, fullName: String) async throws -> Bool {
        do {
            // Creating a user with firebase
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            return true
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            self.signOut()
            return false
        }
    }
    
    // Function for signing out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // Function for deleting an account
    func deleteAccount(email: String, password: String) {
        // YOUR CODE
        let user = Auth.auth().currentUser
        
        // re-authenticate
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // Prompt the user to re-provide sign-in credentials
        
        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print("DEBUG: Failed to reauthenticate with error \(error.localizedDescription)")
            } else {
                user?.delete { error in
                    if let error = error {
                        print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
                    } else {
                        self.signOut()
                    }
                }
            }
        }
        
        
    }
    
    // Function to fetch the current user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    // Function to reset password
    func passwordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) async throws {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: Failed to send password reset email: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("DEBUG: Password reset email sent to \(email)")
                completion(.success(()))
            }
        }
    }
}
