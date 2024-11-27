//
//  ActivityCardSection.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that wraps an activity card with standardized container styling for the activities section
struct ActivityCardSection: View {
   // MARK: - Properties
   
   /// The activity data to display in the card
   let activity: Activity
   
   /// Closure called when the remove action is triggered
   var onRemove: () -> Void
   
   // MARK: - Body
   
   var body: some View {
       // Wrap activity card in container with activities styling
       CardContainer(type: .activities) {
           ActivityCard(activity: activity, onRemove: onRemove)
       }
   }
}

#Preview("ActivityCardSection") {
    VStack(spacing: 20) {
        // Museum activity
        ActivityCardSection(
            activity: Activity(
                id: "1",
                name: "Museum of Modern Art",
                description: "Explore world-class modern and contemporary art",
                location: "New York City",
                rating: 4.8,
                reviews: 1200,
                duration: "3 hours",
                timeSlot: Date(),
                day: "Day 1 (Activity 1)",
                price: 75000.00,
                images: []
            )
        ) {
            print("Remove tapped")
        }
        
        // Adventure activity
        ActivityCardSection(
            activity: Activity(
                id: "2",
                name: "Bunjee Jumping",
                description: "Experience the thrill of falling from 100 meters",
                location: "Canyon",
                rating: 5.0,
                reviews: 800,
                duration: "2 hours",
                timeSlot: Date(),
                day: "Day 2 (Activity 1)",
                price: 125000.00,
                images: []
            )
        ) {
            print("Remove tapped")
        }
    }
    .padding()
}
