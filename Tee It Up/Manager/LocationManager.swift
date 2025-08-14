//
//  LocationManager.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/18/25.
//

// File to store the data of the user's locaiton // 
import Foundation
import CoreLocation

class LocationManager: ObservableObject {
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
}
