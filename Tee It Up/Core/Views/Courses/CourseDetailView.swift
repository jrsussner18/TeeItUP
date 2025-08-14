//
//  CourseDetailView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//


// View for Details of Each Course //
// Parent to TeeView //

import SwiftUI
import GooglePlaces

struct CourseDetailView: View {
    // Variables
    var club: Club
    var courseWebsite: URL? = nil
    var golfCourse: GolfCourse
    @State private var placeID: String? = nil
    @State private var courseInfo: GCData = GCData(courses: [])
    @EnvironmentObject var viewModel: PlacesDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                // Course name
                Text(club.club_name ?? "")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.vertical, 10)
                // Course par and holes
                HStack {
                    Spacer()
                    Text("\(golfCourse.holes ?? 0) holes")
                    Spacer()
                    Text("Par \(golfCourse.par ?? 0)")
                    Spacer()
                }
                .font(.title2)
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.vertical, 10)
                // Tee information
                HStack {
                    Text("Tees:")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()
                }
                // If course tee info available, display it
                if !courseInfo.courses.isEmpty {
                    ForEach(courseInfo.courses) { course in
                        ForEach(course.tees.male) { tee in
                            TeeView(tee: tee)
                        }
                        .padding()
                    }
                } else {
                    Text("No tee data available.")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.top)
                }
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.vertical, 10)
                // Pricing
                HStack {
                    Text("Pricing:")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)
                    Spacer()
                }
                HStack {
                    Text("Weekday: $\(golfCourse.weekday_price ?? "")")
                    Spacer()
                    Text("Weekend: $\(golfCourse.weekend_price ?? "")")
                }
                .padding()
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.vertical, 10)
                // Buttonto route to course website
                Button {
                } label : {
                    HStack {
                        if let url = courseWebsite, !url.absoluteString.isEmpty {
                            Link("Visit the Course Website", destination: url)
                                .fontWeight(.semibold)
                        } else {
                            Text("This course doesn't have a website.")
                        }
                        Image(systemName: "arrow.right")
                    }
                }
                // Styling
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2))
                .padding(.top, 10)
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .task {
            do {
                // Grab the information of the course
                self.courseInfo = try await DataService().getClubsDetails(query: club.club_name ?? "")
            } catch {
                print("Error finding the course")
            }
        }
    }
}

