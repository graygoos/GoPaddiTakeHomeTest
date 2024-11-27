//
//  ActionButton.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A reusable button component that displays a title and subtitle with consistent styling
/// Used for primary actions throughout the app
struct ActionButton: View {
    /// The main text displayed in the button
    let title: String
    
    /// Supporting text displayed below the title
    let subtitle: String
    
    /// Closure that gets executed when button is tapped
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview("ActionButton - Various States") {
    VStack(spacing: 20) {
        ActionButton(
            title: "Add Activities",
            subtitle: "Build, personalize, and optimize your itineraries with our trip planner",
            action: { print("Activities tapped") }
        )
        
        ActionButton(
            title: "Add Hotels",
            subtitle: "Find and book the perfect place to stay",
            action: { print("Hotels tapped") }
        )
        
        ActionButton(
            title: "Add Flights",
            subtitle: "Search and compare flight options",
            action: { print("Flights tapped") }
        )
    }
    .padding()
}
