//
//  Tee_It_UpApp.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

import SwiftUI
import Firebase

@main
struct Tee_It_UpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
