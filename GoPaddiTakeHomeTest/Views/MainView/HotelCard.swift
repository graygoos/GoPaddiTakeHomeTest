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
    @State private var showRemoveAlert = false
    
    private var hotelImages: [String] {
        ["hotel-1", "hotel-2", "hotel-3", "hotel-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ZStack {
                // Image
                if let imageName = hotelImages[safe: currentImageIndex] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }
                
                // Navigation arrows
                HStack {
                    Button {
                        withAnimation {
                            currentImageIndex = (currentImageIndex - 1 + hotelImages.count) % hotelImages.count
                        }
                    } label: {
                        CircleButton(icon: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            currentImageIndex = (currentImageIndex + 1) % hotelImages.count
                        }
                    } label: {
                        CircleButton(icon: "chevron.right")
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // Hotel details
            VStack(alignment: .leading, spacing: 12) {
                // Name and address
                Text(hotel.name)
                    .font(.system(size: 16, weight: .medium))
                Text(hotel.address)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                // Rating and amenities
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Label("Show in map", systemImage: "map")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", hotel.rating))
                        Text("(\(hotel.reviews))")
                            .foregroundColor(.secondary)
                    }
                    .font(.system(size: 14))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double")
                        Text(hotel.roomType)
                    }
                    .font(.system(size: 14))
                }
                
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
                .font(.system(size: 14))
                
                // Action links and price
                HStack {
                    ForEach(["Hotel details", "Price details", "Edit details"], id: \.self) { text in
                        Button(action: {}) {
                            Text(text)
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                        if text != "Edit details" {
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("₦\(hotel.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(16)
            
            // Remove button
            Button {
                showRemoveAlert = true
            } label: {
                HStack {
                    Text("Remove")
                        .foregroundColor(.red)
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red.opacity(0.1))
            }
        }
        .modifier(RemoveAlertModifier(
            showAlert: $showRemoveAlert,
            title: "Remove Hotel",
            message: "Are you sure you want to remove this hotel?",
            onConfirm: onRemove
        ))
        .background(Color(hex: "0D1139"))
        .foregroundColor(.white)
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
