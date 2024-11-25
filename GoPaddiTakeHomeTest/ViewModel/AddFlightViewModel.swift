//
//  AddFlightViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class AddFlightViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var airline = ""
    @Published var flightNumber = ""
    @Published var origin = ""
    @Published var destination = ""
    @Published var departureTime = Date()
    @Published var arrivalTime = Date().addingTimeInterval(3600)
    @Published var price: Double = 0
    
    var isValid: Bool {
        !airline.isEmpty &&
        !flightNumber.isEmpty &&
        !origin.isEmpty &&
        !destination.isEmpty &&
        arrivalTime > departureTime &&
        price > 0
    }
    
    func createFlight() -> Flight? {
        guard isValid else { return nil }
        return Flight(
            id: UUID().uuidString,
            airline: airline,
            flightNumber: flightNumber,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            origin: origin,
            destination: destination,
            price: price
        )
    }
}
