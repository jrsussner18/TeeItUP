//
//  DataService.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/16/25.
//

import Foundation

struct GCData: Decodable {
    let courses: [Courses]
}

struct DataService {
    
    private let apiKey1 = Bundle.main.infoDictionary?["GolfCourseAPIKey"] as! String
    
    func getClubsDetails(query: String) async throws -> GCData {
        guard let url = URL(string: "https://api.golfcourseapi.com/v1/search?search_query=\(query)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Key \(apiKey1)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let fullData = try JSONDecoder().decode(GCData.self, from: data)

            // Filter exact matches on club_name
            let filteredCourses = fullData.courses.filter { $0.course_name.lowercased() == query.lowercased() }

            // Debug output
            if filteredCourses.isEmpty {
                print("No exact matches for '\(query)'")
            } else {
                print("Found \(filteredCourses.count) exact match(es) for '\(query)'")
                for course in filteredCourses {
                    
                    for tee in course.tees.male {
                        print("This course has \(tee.number_of_holes) holes with a par of \(tee.par_total)")
                        print("The \(tee.tee_name) tees are \(tee.total_yards) yds (slope: \(tee.slope_rating), rating: \(tee.course_rating))")
                    }
                }
            }

            // Return only the filtered courses
            return GCData(courses: filteredCourses)

        } catch {
            print("Error decoding: \(error.localizedDescription)")
            throw error
        }
    }


    // Safely grab and store api key
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func getClubs(lat: Double, long: Double, miles: Int = 10) async -> [Club] {
         
        // Make sure api key exists
        guard apiKey != nil else {
            return []
        }
        
        // Headers for API request
        let headers = [
            "x-rapidapi-key": "\(apiKey ?? "")",
            "x-rapidapi-host": "golf-course-finder.p.rapidapi.com"
        ]

        // Initialize URL with parameters
        guard let url = URL(string: "https://golf-course-finder.p.rapidapi.com/api/golf-clubs/?miles=\(miles)&latitude=\(lat)&longitude=\(long)") else {
            print("Invalid URL")
            return []
        }
        
        // Initialize request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        request.cachePolicy = .useProtocolCachePolicy
        request.allHTTPHeaderFields = headers
        
        do {
            // Send the request, store the data and decode it
            let (data, _) = try await URLSession.shared.data(for: request)
            let clubs = try JSONDecoder().decode([Club].self, from: data)

            return clubs
        } catch {
            print(error)
            return []
        }
    }
}
