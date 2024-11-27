//
//  HotelCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays hotel details in a trip itinerary
/// Shows hotel information, dates, amenities, and related actions
struct HotelCard: View {
    /// The hotel data to display
    let hotel: Hotel
    /// Index tracking the currently displayed image in the carousel
    @State private var currentImageIndex = 0
    /// Callback executed when the remove action is confirmed
    var onRemove: () -> Void
    /// Controls visibility of the remove confirmation alert
    @State private var showRemoveAlert = false
    
    /// Collection of image assets to display in the carousel
    private var hotelImages: [String] {
        ["hotel-1", "hotel-2", "hotel-3", "hotel-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel section with navigation controls
            ZStack {
                if let imageName = hotelImages[safe: currentImageIndex] {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                }
                
                // Left/Right navigation buttons
                HStack {
                    Button {
                        withAnimation {
                            currentImageIndex = (currentImageIndex - 1 + hotelImages.count) % hotelImages.count
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
                            currentImageIndex = (currentImageIndex + 1) % hotelImages.count
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // Hotel details section
            VStack(alignment: .leading, spacing: 12) {
                // Name and address
                Text(hotel.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(hotel.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Rating and amenities information
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Label("Show in map", systemImage: "map")
                            .foregroundColor(.appBlue)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", hotel.rating))
                        Text("(\(hotel.reviews))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double")
                        Text(hotel.roomType)
                    }
                }
                .font(.system(size: 14))
                
                Divider()
                
                // Check-in/out dates
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                        Text("In:")
                        Text(hotel.checkIn.formatted(date: .numeric, time: .omitted))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                        Text("Out:")
                        Text(hotel.checkOut.formatted(date: .numeric, time: .omitted))
                    }
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                
                Divider()
                
                // Action buttons
                HStack {
                    ForEach(["Hotel details", "Price details", "Edit details"], id: \.self) { text in
                        Button(action: {}) {
                            Text(text)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.appBlue)
                        }
                        if text != "Edit details" {
                            Spacer()
                        }
                    }
                }
                
                Divider()
                
                // Price display
                Text("₦\(hotel.price, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .padding(16)
            .background(Color.white)
            
            // Remove button
            Button {
                showRemoveAlert = true
            } label: {
                HStack(spacing: 8) {
                    Text("Remove")
                    Image(systemName: "xmark")
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red.opacity(0.1))
            }
        }
        .modifier(RemoveAlertModifier(
            showAlert: $showRemoveAlert,
            title: "Remove Hotel",
            message: "Are you sure you want to remove this hotel?",
            onConfirm: onRemove
        ))
        .background(Color.white)
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
