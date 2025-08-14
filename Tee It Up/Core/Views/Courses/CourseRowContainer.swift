//
//  CourseRowContainer.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/25/25.


// Container for the Course View //
// Created for better run-time optimization within the Course View //
// Parent to CourseRowView //

import SwiftUI
import GooglePlaces

struct CourseRowContainer: View {
    // Variables
    let course: GolfCourse
    let club: Club
    let prediction: GMSAutocompletePrediction?

    @State private var photo: UIImage? = nil
    @EnvironmentObject var viewModel: PlacesDetailsViewModel
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedClub: Club?
    @State private var courseDistance: Double?
    @Binding var favorites: [Club]

    var body: some View {
        // Get course photo
        rowContent()
            .task {
                if let prediction = prediction, photo == nil {
                    photo = await viewModel.fetchImage(placeID: prediction.placeID)
                }
            }
    }

    @ViewBuilder
    private func rowContent() -> some View {
        // If course exists, send it to the row view
        if prediction != nil {
            if let photo = photo {
                CourseRowView(
                    course: course,
                    club: club,
                    photo: photo,
                    courseDistance: 0,
                    favorites: $favorites
                )
                .simultaneousGesture (
                    // selectedClub is for telling the app what course to show a detailed view for
                    TapGesture().onEnded {
                        selectedClub = club
                    }
                )
            } else {
                ProgressView()
                    .frame(height: 50)
            }
        // If the image does not exist, send it to the row view with a placeholder image
        } else {
            Button {
                selectedClub = club
            } label: {
                CourseRowView(
                    course: course,
                    club: club,
                    photo: UIImage(named: "placeholder")!,
                    courseDistance: 0,
                    favorites: $favorites
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

