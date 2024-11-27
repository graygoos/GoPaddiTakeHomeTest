//
//  Ext+Trip.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Sample Data

extension Trip {
   /// Collection of sample trips for development and testing purposes
   static let sampleTrips = [
       /// Sample family trip to the Bahamas
       Trip(
           id: "1",
           name: "Bahamas Family Trip",
           destination: "Nassau, Bahamas",
           // Schedule trip to start in 30 days
           date: Date().addingTimeInterval(86400 * 30),
           // End date 7 days after start (37 days from now)
           endDate: Date().addingTimeInterval(86400 * 37),
           details: "A wonderful family vacation in the Bahamas with beach activities and water sports.",
           price: 2450.00,
           // Sample image URLs (not functional)
           images: [
               "https://example.com/bahamas1.jpg",
               "https://example.com/bahamas2.jpg"
           ],
           // Associated location details
           location: Location(
               id: "1",
               name: "Nassau",
               country: "Bahamas",
               flag: "🇧🇸",
               subtitle: nil
           ),
           travelStyle: .family
       ),
       
       /// Sample couple's trip to Dubai
       Trip(
           id: "2",
           name: "Dubai Resort Visit",
           destination: "Dubai, UAE",
           // Schedule trip to start in 60 days
           date: Date().addingTimeInterval(86400 * 60),
           // End date 7 days after start (67 days from now)
           endDate: Date().addingTimeInterval(86400 * 67),
           details: "Luxury resort stay in Dubai with desert safari and city tours.",
           price: 3850.00,
           // Sample image URLs (not functional)
           images: [
               "https://example.com/dubai1.jpg",
               "https://example.com/dubai2.jpg"
           ],
           // Associated location details
           location: Location(
               id: "2",
               name: "Dubai",
               country: "United Arab Emirates",
               flag: "🇦🇪",
               subtitle: nil
           ),
           travelStyle: .couple
       )
   ]
}
