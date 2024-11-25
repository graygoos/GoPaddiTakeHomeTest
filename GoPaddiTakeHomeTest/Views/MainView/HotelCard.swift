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
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ZStack(alignment: .center) {
                Color(hex: "0D1139") // Dark blue background
                    .frame(height: 200)
                
                // Placeholder image
                Color.gray.opacity(0.3)
                    .frame(height: 200)
                
                // Navigation arrows
                HStack {
                    Button {
                        withAnimation {
                            currentImageIndex = max(0, currentImageIndex - 1)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            currentImageIndex = min(hotel.images.count - 1, currentImageIndex + 1)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
            }
            
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
                        HStack(spacing: 4) {
                            Image(systemName: "map")
                            Text("Show in map")
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(hotel.rating, specifier: "%.1f")")
                        Text("(\(hotel.reviews))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "bed.double")
                        Text(hotel.roomType)
                    }
                }
                .font(.subheadline)
                
                // Dates
                HStack(spacing: 16) {
                    Label {
                        Text("In: \(hotel.checkIn.formatted(date: .numeric, time: .omitted))")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Label {
                        Text("Out: \(hotel.checkOut.formatted(date: .numeric, time: .omitted))")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                .font(.subheadline)
                
                // Action buttons
                HStack {
                    Button("Hotel details") {
                        // Handle hotel details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    
                    Button("Price details") {
                        // Handle price details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    
                    Button("Edit details") {
                        // Handle edit details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("₦\(hotel.price, specifier: "%.2f")")
                        .font(.headline)
                }
                .font(.subheadline)
                .padding(.top, 8)
            }
            .padding()
            .background(Color(hex: "0D1139"))
            .foregroundColor(.white)
            
            // Remove button
            Button {
                // Handle remove
            } label: {
                Text("Remove")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .background(Color.white.opacity(0.1))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Hotel Card") {
    HotelCard(hotel: Hotel(
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
    ))
    .padding()
}
