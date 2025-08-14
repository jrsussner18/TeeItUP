//
//  GolfCourse.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/18/25.
//

// Stores golf course data that is used in CourseDetailView //

import Foundation

struct GolfCourse: Decodable, Identifiable {
    var id = UUID()
    let course_name: String?
    let par: Int?
    let holes: Int?
    let weekday_price: String?
    let weekend_price: String?
    
    private enum CodingKeys: String, CodingKey {
        case course_name
        case par
        case holes
        case weekday_price
        case weekend_price
    }
}
