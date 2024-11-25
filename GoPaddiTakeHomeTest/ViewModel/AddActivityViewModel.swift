//
//  AddActivityViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class AddActivityViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var name = ""
    @Published var description = ""
    @Published var location = ""
    @Published var rating: Double = 0
    @Published var reviews: Int = 0
    @Published var duration = ""
    @Published var timeSlot = Date()
    @Published var day = "Day 1 (Activity 1)"
    @Published var price: Double = 0
    
    var isValid: Bool {
        !name.isEmpty &&
        !description.isEmpty &&
        !location.isEmpty &&
        !duration.isEmpty &&
        rating > 0 &&
        reviews >= 0 &&
        !day.isEmpty &&
        price > 0
    }
    
    func createActivity() -> Activity? {
        guard isValid else { return nil }
        return Activity(
            id: UUID().uuidString,
            name: name,
            description: description,
            location: location,
            rating: rating,
            reviews: reviews,
            duration: duration,
            timeSlot: timeSlot,
            day: day,
            price: price,
            images: []
        )
    }
}
