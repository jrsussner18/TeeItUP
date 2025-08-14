//
//  ContentView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

import SwiftUI
import MapKit

// Container to house the Tab View for different Views //

struct AppContainerView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject private var placesViewModel = PlacesDetailsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        TabView {
            AboutView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("About")
                }
            CourseView()
                .tabItem {
                    Image(systemName: "figure.golf")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Courses")
                }
                .environmentObject(placesViewModel)
                .environmentObject(locationManager)
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Account")
                }
                .environmentObject(authViewModel)
            
            
        }
        .padding()
        .ignoresSafeArea(.all)
        .environmentObject(locationManager)
        .onAppear() {
            // Getting users location, storing the longitude and latitude into variables for API use
            CLLocationManager().requestWhenInUseAuthorization()
            if let location = CLLocationManager().location?.coordinate {
                locationManager.latitude = location.latitude
                locationManager.longitude = location.longitude
            }
        }
    }
}

