//
//  Club.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/18/25.
//

import Foundation

// Struct for storing golf course data

struct Club: Decodable, Identifiable {
    var id: String { club_name ?? UUID().uuidString }
    let club_name: String?
    let club_membership: String?
    let golf_courses: [GolfCourse]
}
