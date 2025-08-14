//
//  PlacesDetailsViewModel.swift
//  Tee It Up
//
//  Created by Jake Sussner on 7/10/25.
//

// File for handling all Google Places API related processes

import Foundation
import GooglePlaces
import UIKit
import CoreLocation


// Decodable structs for API return data


struct PlaceResult: Codable, Identifiable {
    let id = UUID() // For SwiftUI list use
    let name: String
    let vicinity: String?
    // other fields as needed

    enum CodingKeys: String, CodingKey {
        case name, vicinity
    }
}

struct NearbySearchResponse: Decodable {
    let results: [PlaceResult]
}

class PlacesDetailsViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var websiteURL: String? = nil
    @Published var placeLocation: CLLocationCoordinate2D?
    @Published var places: [PlaceResult] = []
    let apiKey = Bundle.main.infoDictionary?["GMSPlacesAPIKey"] as! String

    // Functiont to search for a place given a query and a mile radius
    func search(query: String, near userLocation: CLLocation, maxMiles: Double = 50.0) async -> [GMSAutocompletePrediction] {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment

        return await withCheckedContinuation { continuation in
            GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
                guard let results = results else {
                    print("Autocomplete error: \(error?.localizedDescription ?? "Unknown error")")
                    continuation.resume(returning: [])
                    return
                }

                Task {
                    // If results are found, store them
                    var nearbyPredictions: [GMSAutocompletePrediction] = []

                    for prediction in results {
                        if let place = await self.fetchDetails(placeID: prediction.placeID) {
                            let placeLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                            let distance = userLocation.distance(from: placeLocation) / 1609.34
                            
                            if distance <= maxMiles {
                                nearbyPredictions.append(prediction)
                            }
                        }
                    }

                    continuation.resume(returning: nearbyPredictions)
                }
            }
        }
    }

    // Function to fetch details of a given place, like an image and website url
    func fetchDetails(placeID: String) async -> GMSPlace? {
        return await withCheckedContinuation { continuation in
            let placesClient = GMSPlacesClient.shared()
            let fields: GMSPlaceField = [.name, .website, .placeID, .coordinate]

            placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil) { place, error in
                if let place = place {
                    DispatchQueue.main.async {
                        self.websiteURL = place.website?.absoluteString
                    }
                    continuation.resume(returning: place)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    // Function to get a places' Coordinates
    func getPlaceLocation(placeID: String) async -> CLLocationCoordinate2D? {
        guard let details = await fetchDetails(placeID: placeID) else {
            return nil
        }
        return details.coordinate
    }

    // Function to grab a places' website URL
    func fetchWebsiteURL(for placeID: String) async -> URL? {
        guard let details = await fetchDetails(placeID: placeID),
              let url = details.website else {
            return nil
        }
        return url
    }

    // Function to grab a places' image
    func fetchImage(placeID: String) async -> UIImage? {
        let fields: GMSPlaceField = [.photos]
        return await withCheckedContinuation { continuation in
            GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil) { place, error in
                if let photoMetadata = place?.photos?.first {
                    GMSPlacesClient.shared().loadPlacePhoto(photoMetadata) { img, _ in
                        continuation.resume(returning: img)
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
