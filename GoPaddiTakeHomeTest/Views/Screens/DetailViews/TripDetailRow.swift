//
//  TripDetailRow.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripDetailRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
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
    .previewLayout(.sizeThatFits)
}
