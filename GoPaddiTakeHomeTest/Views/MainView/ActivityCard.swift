//
//  ActivityCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    @State private var currentImageIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ZStack(alignment: .center) {
                Color.blue // Blue background
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
                            currentImageIndex = min(activity.images.count - 1, currentImageIndex + 1)
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
            
            // Activity details
            VStack(alignment: .leading, spacing: 12) {
                Text(activity.name)
                    .font(.headline)
                
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                // Location and details
                HStack(spacing: 16) {
                    Label(activity.location, systemImage: "mappin.circle.fill")
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(activity.rating, specifier: "%.1f")")
                        Text("(\(activity.reviews))")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Label(activity.duration, systemImage: "clock")
                }
                .font(.subheadline)
                
                // Time slot
                HStack(spacing: 16) {
                    Button("Change time") {
                        // Handle time change
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    .underline()
                    
                    Text(activity.timeSlot.formatted(date: .omitted, time: .shortened))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(4)
                    
                    Text(activity.day)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(4)
                }
                .font(.subheadline)
                
                // Action buttons
                HStack {
                    Button("Activity details") {
                        // Handle activity details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    
                    Button("Price details") {
                        // Handle price details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    
                    Button("Edit details") {
                        // Handle edit details
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("₦\(activity.price, specifier: "%.2f")")
                        .font(.headline)
                }
                .font(.subheadline)
                .padding(.top, 8)
            }
            .padding()
            .background(Color.blue)
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

#Preview("Activity Card") {
    ActivityCard(activity: Activity(
        id: "1",
        name: "The Museum of Modern Art",
        description: "Works from Van Gogh to Warhol & beyond plus a sculpture garden, 2 cafes & The modern restaurant",
        location: "Melbourne, Australia",
        rating: 8.5,
        reviews: 436,
        duration: "1 hour",
        timeSlot: Date(),
        day: "Day 1 (Activity 1)",
        price: 123450.00,
        images: []
    ))
    .padding()
}
