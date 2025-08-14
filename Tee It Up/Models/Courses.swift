//
//  Courses.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/17/25.
//

// Stores the information on the course that is used in CourseDetailView //

import Foundation

struct Courses: Codable, Identifiable {
    let id: Int
    let club_name: String
    let course_name: String
    let tees: Tees
}

struct Tees: Codable {
    let female: [TeeInfo]
    let male: [TeeInfo]
}

struct TeeInfo: Codable, Identifiable {
    var id: UUID { UUID() }
    let tee_name: String
    let slope_rating: Double
    let course_rating: Double
    let total_yards: Int
    let number_of_holes: Int
    let par_total: Int
}

