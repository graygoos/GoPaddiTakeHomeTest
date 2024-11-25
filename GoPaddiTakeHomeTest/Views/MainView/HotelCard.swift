//
//  HotelCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct HotelCard: View {
    let hotel: Hotel
    @State private var currentImageIndex = 0
    var onRemove: () -> Void
    
    // Generate hotel images array
    private var hotelImages: [String] {
        ["hotel-1", "hotel-2", "hotel-3", "hotel-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ImageCarouselView(
                images: hotelImages,
                currentIndex: $currentImageIndex,
                height: 200
            )
            
            // Hotel details
            VStack(alignment: .leading, spacing: 12) {
                Text(hotel.name)
                    .font(.headline)
                
                Text(hotel.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Rating and amenities
                HStack(spacing: 16) {
                    Button {
                        // Show map
                    } label: {
                        Label("Show in map", systemImage: "map")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(hotel.rating, specifier: "%.1f")")
                        Text("(\(hotel.reviews))")
                            .foregroundColor(.secondary)
                    }
                    
                    Label(hotel.roomType, systemImage: "bed.double")
                }
                .font(.subheadline)
                
                // Dates
                HStack(spacing: 16) {
                    Label("In: \(hotel.checkIn.formatted(date: .numeric, time: .omitted))",
                          systemImage: "calendar")
                    
                    Label("Out: \(hotel.checkOut.formatted(date: .numeric, time: .omitted))",
                          systemImage: "calendar")
                }
                .font(.subheadline)
                
                // Action buttons and price
                HStack {
                    ActionLink(title: "Hotel details")
                    ActionLink(title: "Price details")
                    ActionLink(title: "Edit details")
                    
                    Spacer()
                    
                    Text("₦\(hotel.price, specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .padding()
            .background(Color(hex: "0D1139"))
            .foregroundColor(.white)
            
            // Remove button
            Button(action: onRemove) {
                Text("Remove")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.1))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("HotelCard - Various States") {
    ScrollView {
        VStack(spacing: 20) {
            // Luxury hotel
            HotelCard(
                hotel: Hotel(
                    id: "1",
                    name: "Riviera Resort, Lekki",
                    address: "18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1",
                    rating: 8.5,
                    reviews: 436,
                    roomType: "King size room",
                    checkIn: Date(),
                    checkOut: Date().addingTimeInterval(86400 * 7), // 7 days
                    price: 123450.00,
                    images: []
                )
            ) {
                print("Remove tapped")
            }
            
            // Budget hotel
            HotelCard(
                hotel: Hotel(
                    id: "2",
                    name: "City Lodge",
                    address: "123 Victoria Island, Lagos",
                    rating: 4.0,
                    reviews: 89,
                    roomType: "Standard Double",
                    checkIn: Date(),
                    checkOut: Date().addingTimeInterval(86400 * 3), // 3 days
                    price: 45000.00,
                    images: []
                )
            ) {
                print("Remove tapped")
            }
        }
        .padding()
    }
}
