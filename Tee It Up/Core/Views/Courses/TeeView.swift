//
//  TeeView.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/23/25.
//

// Helper View file to create the UI for Tee Box information //

import SwiftUI

struct TeeView: View {
    let tee: TeeInfo

    var body: some View {
        HStack {
            // Tee Box name
            Text(tee.tee_name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .fontWeight(.medium)

            // Tee Box yards
            Text("\(tee.total_yards) yds")
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)

            // Tee Box course and slope rating
            Text(String(format: "%.1f / %.0f", tee.course_rating, tee.slope_rating))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}
