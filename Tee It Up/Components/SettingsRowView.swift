//
//  SettingsRowView.swift
//  SwiftUIAuthTutorial
//
//  Created by Jake Sussner on 7/10/25.
//

// View Builder
// Handles each row item in the Account View 
import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack (spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
