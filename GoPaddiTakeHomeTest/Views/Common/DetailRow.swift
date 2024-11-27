//
//  DetailRow.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A row component displaying an icon and two text lines
/// Used for showing detailed information in a consistent format
struct DetailRow: View {
    /// The SF Symbol name for the icon
    let icon: String
    
    /// The color of the icon
    let iconColor: Color
    
    /// The label text shown above the detail
    let title: String
    
    /// The main text shown below the title
    let detail: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.title2)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.secondary)
                Text(detail)
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("DetailRow - Various States") {
    VStack(spacing: 20) {
        DetailRow(
            icon: "calendar",
            iconColor: .blue,
            title: "Dates",
            detail: "Dec 23, 2024 - Jan 23, 2025"
        )
        
        DetailRow(
            icon: "person.2.fill",
            iconColor: .blue,
            title: "Travel Style",
            detail: "Family"
        )
        
        DetailRow(
            icon: "location.fill",
            iconColor: .blue,
            title: "Location",
            detail: "Laghouat, Algeria 🇩🇿"
        )
    }
    .padding()
}
