//
//  AddHotelViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

class AddHotelViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var name = ""
    @Published var address = ""
    @Published var rating: Double = 0
    @Published var reviews: Int = 0
    @Published var roomType = ""
    @Published var checkIn = Date()
    @Published var checkOut = Date().addingTimeInterval(86400)
    @Published var price: Double = 0
    
    var isValid: Bool {
        !name.isEmpty &&
        !address.isEmpty &&
        !roomType.isEmpty &&
        rating > 0 &&
        reviews >= 0 &&
        checkOut > checkIn &&
        price > 0
    }
    
    func createHotel() -> Hotel? {
        guard isValid else { return nil }
        return Hotel(
            id: UUID().uuidString,
            name: name,
            address: address,
            rating: rating,
            reviews: reviews,
            roomType: roomType,
            checkIn: checkIn,
            checkOut: checkOut,
            price: price,
            images: []
        )
    }
}
