//
//  CourseView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

// File for Course View //
// Parent to CourseRowView, CourseDetailView, and CourseRowContainer //

import SwiftUI
import GooglePlaces

struct CourseView: View {
    // Variables
    @State private var golfCourses = [GCData]()
    @State private var clubs: [Club] = []
    @State private var selectedClub: Club?
    @State private var placeID: String? = nil
    @State private var websiteDictionary: Dictionary = [String: URL]()
    @State private var placeResults: [GMSAutocompletePrediction] = []
    @State private var searchTerm: String = ""
    @State private var showFilter: Bool = false
    @State private var milesFilter: Float = 10
    @State private var favorites: [Club] = []
    @State private var showFavorites: Bool = false
    
    // Initialize environment object to track users location upon request, is shared by all views
    @EnvironmentObject var locationManager: LocationManager
    
    // Initialize state object property wrapper for places details, will cause view to update when its published variables are updated
    @StateObject var viewModel = PlacesDetailsViewModel()
    
    // Filter the golf courses based on whether public or private, if it is searched for within the view, or if the user favorited it
    var filteredClubs: [Club] {
        let base: [Club]

        if showFavorites {
            base = clubs.filter { club in
                favorites.contains(where: { $0.club_name == club.club_name })
            }
        } else {
            base = clubs.filter { club in
                club.club_membership == "Public" || club.club_membership == "Resort"
            }
        }


        guard !searchTerm.isEmpty else { return base }
        return base.filter { $0.club_name?.localizedCaseInsensitiveContains(searchTerm) ?? false }
    }

    var body: some View {

        NavigationStack {
            VStack {
                HStack {
                    // Search Bar
                    TextField("Search courses", text: $searchTerm)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    // Filter menu
                    Menu {
                        // Miles slider
                        Slider(value: $milesFilter, in: 10...50, step: 1)
                        Text("Miles: \(milesFilter, specifier: "%.0f")")
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        // Show favorites toggle
                        Toggle("Show Favorites", isOn: $showFavorites)
                        // Button to apply the filter
                        Button("Apply Course Filter") {
                            Task {
                                await grabCourses(miles: Int(milesFilter), showFavoriteCourses: showFavorites)
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                // Iterate over each club, passing it into its corresponding view
                List {
                    ForEach(filteredClubs, id: \.club_name) { club in
                        ForEach(club.golf_courses) { course in
                            CourseRowContainer(
                                course: course,
                                club: club,
                                prediction: placeResults.first { fuzzyMatch(clubName: club.club_name, prediction: $0) },
                                selectedClub: $selectedClub,
                                favorites: $favorites
                            )
                        }
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .scrollIndicators(.hidden)
                .padding(.horizontal)
                .task {
                    // Call function to grab the courses
                    await grabCourses()
                }
            }
            // Display a pop up for a selected course in a detailed view of that course
            .sheet(item: $selectedClub) {c in
                CourseDetailView(club: c, courseWebsite: websiteDictionary[c.club_name ?? ""], golfCourse: c.golf_courses.first!)
            }
        }
        .navigationTitle("Golf Courses")
    }
    
    // Function to grab golf courses based on miles from user
    func grabCourses(miles: Int = 10, showFavoriteCourses: Bool = false) async {
        
         // Get course data based on miles away from user
        self.clubs = await DataService().getClubs(
            lat: locationManager.latitude,
            long: locationManager.longitude,
            miles: miles
        )
         //Initialize a list to store information about the clubs via Google Places
        var allPredictions: [GMSAutocompletePrediction] = []
        // Iterate through clubs public courses
        for club in filteredClubs {
            // For each course, search it via Google Places API, storing its prediction in an array
            let query = club.club_name ?? ""
            let currentLocation = CLLocation(latitude: locationManager.latitude, longitude: locationManager.longitude)
            if showFavoriteCourses {
                if favorites.contains(where: {$0.club_name == query}) {
                    let results = await viewModel.search(query: query, near: currentLocation)
                    if let first = results.first {
                        allPredictions.append(first)
                        // If the course has a website, store it in a website dictionary for the detail view
                        if let url = await viewModel.fetchWebsiteURL(for: first.placeID) {
                            self.websiteDictionary[club.club_name ?? ""] = url
                            // Debug print statement
                            print("Storing website for \(club.club_name ?? ""): \(url.absoluteString)")
                        }
                    } else {
                        // Debug print statements
                        print("No prediction for \(club.club_name ?? "")")
                        print("Removing \(club.club_name ?? "") from list of golf courses")
                        // If there isnt a prediction for the course, remove it from the list
                        clubs.removeAll { $0.club_name == club.club_name }
                    }
                }
            } else {
                let results = await viewModel.search(query: query, near: currentLocation)
                if let first = results.first {
                    allPredictions.append(first)
                    // If the course has a website, store it in a website dictionary for the detail view
                    if let url = await viewModel.fetchWebsiteURL(for: first.placeID) {
                        self.websiteDictionary[club.club_name ?? ""] = url
                        // Debug print statement
                        print("Storing website for \(club.club_name ?? ""): \(url.absoluteString)")
                    }
                } else {
                    // Debug print statements
                    print("No prediction for \(club.club_name ?? "")")
                    print("Removing \(club.club_name ?? "") from list of golf courses")
                    // If there isnt a prediction for the course, remove it from the list
                    clubs.removeAll { $0.club_name == club.club_name }
                }
            }
        }
        
        // Store course prediction
        self.placeResults = allPredictions
    }
     
    // Function to help with less restrictive search queries within the Google Places API
    func fuzzyMatch(clubName: String?, prediction: GMSAutocompletePrediction) -> Bool {
        guard let clubName = clubName else { return false }
        
        let normalizedClub = normalize(clubName)
        let predictionText = normalize(prediction.attributedPrimaryText.string)
        
        let match = predictionText.contains(normalizedClub) || normalizedClub.contains(predictionText)
        return match
    }
    
    // Helper function to fuzzyMatch
    func normalize(_ text: String) -> String {
        return text
            .lowercased()
            .replacingOccurrences(of: "golf club", with: "")
            .replacingOccurrences(of: "golf course", with: "")
            .replacingOccurrences(of: "club", with: "")
            .replacingOccurrences(of: "course", with: "")
            .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
        
}
