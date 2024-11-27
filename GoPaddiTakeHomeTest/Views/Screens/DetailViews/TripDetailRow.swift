//
//  TripDetailRow.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripDetailRow
/// A reusable row component that displays a single detail about a trip with an icon, title, and detail text.
/// Used for showing various trip attributes in a consistent format.
struct TripDetailRow: View {
    /// SF Symbol name for the row's icon
    let icon: String
    
    /// The title/label for the detail being displayed
    let title: String
    
    /// The actual detail/value to display
    let detail: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Left-aligned icon with consistent sizing
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            // Stacked title and detail with appropriate typography
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(detail)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}

#Preview("TripDetailRow - Various States") {
    VStack(spacing: 20) {
        TripDetailRow(
            icon: "calendar",
            title: "Dates",
            detail: "Apr 15 - Apr 22, 2024"
        )
        
        TripDetailRow(
            icon: "person.2.fill",
            title: "Travel Style",
            detail: "Family"
        )
        
        TripDetailRow(
            icon: "location.fill",
            title: "Location",
            detail: "Paris, France 🇫🇷"
        )
    }
    .padding()
}
