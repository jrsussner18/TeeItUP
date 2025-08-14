//
//  AboutView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/28/25.
//

// File for the About Page //
// Displays basic info about the project and who I am //

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image
                Image("TeeItUp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 8)
                    .padding(.top)

                // Title
                Text("About This App")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                // Body Text
                Text("""
                Hi, I'm Jake Sussner — a Computer Science student with a Mathematics minor at the University of Tampa.

                This app is a personal passion project combining two things I love: golf and building useful software. I wanted a fast, easy way to explore nearby golf courses and thought, “Why not make it myself?”

                While it’s not perfect, I’m proud of what I’ve created — and I hope it helps you discover your next favorite course.

                P.S. You can favorite a course by tapping and holding the ⭐ icon.
                """)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("About")
    }
}
