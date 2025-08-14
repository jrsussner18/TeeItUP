//
//  CourseRowView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

// View for Course Row //
// Parent to CourseDetailView // 

import SwiftUI
import GooglePlaces

struct CourseRowView: View {
    // Variables
    var course: GolfCourse
    var club: Club
    var photo: UIImage
    @State var courseDistance: Double
    @EnvironmentObject var viewModel: PlacesDetailsViewModel
    @EnvironmentObject var locationManager: LocationManager
    @State private var favorite: Bool = false
    @Binding var favorites: [Club]
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Spacer()
                // Display course image only if the course is public or resort
                if club.club_membership == "Public" || club.club_membership == "Resort" {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(16)
                }
                Spacer()
                }
                // Display basic course information, name, par, holes, and distance to user
                HStack {
                    Text("\(club.club_name ?? "")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(String(format: "%.1f", courseDistance)) mi")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
            HStack {
                VStack (alignment: .leading, spacing: 4) {
                    Text("Par: \(course.par ?? 0)")
                    Text("Holes: \(course.holes ?? 0)")
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                
                Spacer()
                // Favorites button
                Button {
                    withAnimation {
                        if let index = favorites.firstIndex(where: { $0.club_name == club.club_name }) {
                            favorites.remove(at: index)
                            favorite = false
                        } else {
                            favorites.append(club)
                            favorite = true
                        }
                        print("Favorite button tapped for \(club.club_name ?? "Unknown")")
                    }
                } label: {
                    Image(systemName: favorite ? "star.fill" : "star")
                        .foregroundColor(.black)
                        .padding()
                        .contentShape(Rectangle())
                }
            }
            }
            // Styling
            .padding(.vertical)
            .frame(maxWidth: UIScreen.main.bounds.width - 32)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 10)
            .task {
                // For each golf course, calculate its distance from the user
                let query = club.club_name ?? ""
                let currentLocation = CLLocation(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let results = await viewModel.search(query: query, near: currentLocation)
                if let first = results.first {
                    if courseDistance == 0 {
                        let distance = await viewModel.getPlaceLocation(placeID: first.placeID)
                        let clubLocation = CLLocation(latitude: distance!.latitude, longitude: distance!.longitude)
                        courseDistance = currentLocation.distance(from: clubLocation) / 1609.34
                    }
                }
            }
    }
}
