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
    var onRemove: () -> Void
    
    // Generate activity images array
    private var activityImages: [String] {
        ["activity-1", "activity-2", "activity-3", "activity-4"]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image carousel
            ImageCarouselView(
                images: activityImages,
                currentIndex: $currentImageIndex,
                height: 200
            )
            
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
                
                // Action buttons and price
                HStack {
                    ActionLink(title: "Activity details", color: .white)
                    ActionLink(title: "Price details", color: .white)
                    ActionLink(title: "Edit details", color: .white)
                    
                    Spacer()
                    
                    Text("₦\(activity.price, specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .padding()
            .background(Color.blue)
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

#Preview("ActivityCard - Various States") {
    ScrollView {
        VStack(spacing: 20) {
            // Museum activity
            ActivityCard(
                activity: Activity(
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
                )
            ) {
                print("Remove tapped")
            }
            
            // Tour activity
            ActivityCard(
                activity: Activity(
                    id: "2",
                    name: "City Walking Tour",
                    description: "Explore the historic city center with a professional guide, visiting key landmarks and hidden gems",
                    location: "Sydney, Australia",
                    rating: 4.8,
                    reviews: 129,
                    duration: "2.5 hours",
                    timeSlot: Date().addingTimeInterval(3600 * 24), // Next day
                    day: "Day 2 (Activity 1)",
                    price: 75000.00,
                    images: []
                )
            ) {
                print("Remove tapped")
            }
        }
        .padding()
    }
}
