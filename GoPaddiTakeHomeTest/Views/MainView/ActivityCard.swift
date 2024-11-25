//
//  ActivityCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    var onRemove: () -> Void
    @State private var currentImageIndex = 0
    @State private var showRemoveAlert = false
    
    private var activityImages: [String] {
        ["activity-1", "activity-2", "activity-3", "activity-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ZStack {
                if let imageName = activityImages[safe: currentImageIndex] {
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
                            currentImageIndex = (currentImageIndex - 1 + activityImages.count) % activityImages.count
                        }
                    } label: {
                        CircleButton(icon: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            currentImageIndex = (currentImageIndex + 1) % activityImages.count
                        }
                    } label: {
                        CircleButton(icon: "chevron.right")
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // Activity details
            VStack(alignment: .leading, spacing: 12) {
                // Title and description
                Text(activity.name)
                    .font(.system(size: 20, weight: .semibold))
                Text(activity.description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                // Location, rating, and duration
                HStack(spacing: 16) {
                    Label(activity.location, systemImage: "mappin.circle")
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", activity.rating))
                        Text("(\(activity.reviews))")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Label(activity.duration, systemImage: "clock")
                }
                .font(.system(size: 14))
                
                // Time slot and day
                HStack(spacing: 12) {
                    Button("Change time") {
                        // Handle time change
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .underline()
                    
                    Text(activity.timeSlot.formatted(date: .omitted, time: .shortened))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(activity.day)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
                .font(.system(size: 14))
                
                // Action links and price
                HStack {
                    ForEach(["Activity details", "Price details", "Edit details"], id: \.self) { text in
                        Button(action: {}) {
                            Text(text)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        if text != "Edit details" {
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Text("₦\(activity.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .padding(16)
            .background(Color.blue)
            
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
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .modifier(RemoveAlertModifier(
            showAlert: $showRemoveAlert,
            title: "Remove Activity",
            message: "Are you sure you want to remove this activity?",
            onConfirm: onRemove
        ))
    }
}

#Preview("All Cards") {
    ScrollView {
        VStack(spacing: 20) {
            FlightCard(
                flight: Flight(
                    id: "1",
                    airline: "American Airlines",
                    flightNumber: "AA-829",
                    departureTime: Date(),
                    arrivalTime: Date().addingTimeInterval(6300),
                    origin: "LOS",
                    destination: "SIN",
                    price: 123450.00
                )
            ) {
                print("Flight removed")
            }
            
            HotelCard(
                hotel: Hotel(
                    id: "1",
                    name: "Ritz Carlton",
                    address: "Fifth Avenue",
                    rating: 5.0,
                    reviews: 1000,
                    roomType: "Double Suite",
                    checkIn: Date(),
                    checkOut: Date().addingTimeInterval(86400 * 10),
                    price: 20.00,
                    images: []
                )
            ) {
                print("Hotel removed")
            }
            
            ActivityCard(
                activity: Activity(
                    id: "1",
                    name: "Surfing",
                    description: "Surfing at the private beach",
                    location: "Staten Island",
                    rating: 5.0,
                    reviews: 1000,
                    duration: "2 days",
                    timeSlot: Date(),
                    day: "Day 1 (Activity 1)",
                    price: 12.00,
                    images: []
                )
            ) {
                print("Activity removed")
            }
        }
        .padding()
    }
}
