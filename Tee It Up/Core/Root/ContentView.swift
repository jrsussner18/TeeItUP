//
//  ContentView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showApp: Bool = true
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                AppContainerView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
