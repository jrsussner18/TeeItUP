//
//  AppDelegate.swift
//  Tee It Up
//
//  Created by Jake Sussner on 6/25/25.
//  App Delegate File to handle major app events

import Foundation
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(Bundle.main.infoDictionary?["GMSPlacesAPIKey"] as! String)
        return true
    }
}
