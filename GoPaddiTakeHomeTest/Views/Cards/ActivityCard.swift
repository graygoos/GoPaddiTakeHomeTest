//
//  ActivityCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays details for a specific activity in a trip itinerary
/// Includes an image carousel, activity information, and action buttons
struct ActivityCard: View {
    /// The activity data to display
    let activity: Activity
    /// Index tracking the currently displayed image in the carousel
    @State private var currentImageIndex = 0
    /// Controls visibility of the remove confirmation alert
    @State private var showRemoveAlert = false
    /// Controls visibility of the time change modal
    @State private var showChangeTime = false
    /// Callback executed when the remove action is confirmed
    var onRemove: () -> Void
    
    /// Collection of image assets to display in the carousel
    private var activityImages: [String] {
        ["activity-1", "activity-2", "activity-3", "activity-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel section with navigation controls
            ZStack {
                if let imageName = activityImages[safe: currentImageIndex] {
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
                            currentImageIndex = (currentImageIndex - 1 + activityImages.count) % activityImages.count
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
                            currentImageIndex = (currentImageIndex + 1) % activityImages.count
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
            
            // Activity details section
            VStack(alignment: .leading, spacing: 12) {
                // Title and description
                Text(activity.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Location, rating, and duration info
                HStack(spacing: 16) {
                    Label(activity.location, systemImage: "mappin.circle")
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", activity.rating))
                        Text("(\(activity.reviews))")
                            .foregroundColor(.secondary)
                    }
                    
                    Label(activity.duration, systemImage: "clock")
                }
                .font(.system(size: 14))
                
                // Time slot section
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Button {
                            showChangeTime = true
                        } label: {
                            Text("Change time")
                                .foregroundColor(.appBlue)
                                .underline()
                                .font(.system(size: 14))
                        }
                        
                        Text(activity.timeSlot.formatted(.dateTime.hour().minute()) + " on " + activity.timeSlot.formatted(.dateTime.month().day()))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(activity.day)
                        .font(.system(size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Divider()
                
                // Action buttons
                HStack {
                    ForEach(["Activity details", "Price details", "Edit details"], id: \.self) { text in
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
                Text("₦\(activity.price, specifier: "%.2f")")
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
        .fullScreenCover(isPresented: $showChangeTime) {
            NavigationStack {
                AddActivityView { updatedActivity in
                    // Handle time update
                }
            }
        }
        .modifier(RemoveAlertModifier(
            showAlert: $showRemoveAlert,
            title: "Remove Activity",
            message: "Are you sure you want to remove this activity?",
            onConfirm: onRemove
        ))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
