//
//  ActionLink.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A simple text-based link component with customizable color
struct ActionLink: View {
    /// The text to display in the link
    let title: String
    
    /// The color of the link text (defaults to blue)
    var color: Color = .blue
    
    var body: some View {
        Button(title) {
            // Handle action
        }
        .foregroundColor(color)
        .font(.subheadline)
    }
}

#Preview("ActionLink - Various States") {
    VStack(spacing: 20) {
        // Default blue color
        ActionLink(title: "Flight details")
        
        // White color (for dark backgrounds)
        ActionLink(title: "Hotel details", color: .white)
            .padding()
            .background(Color.blue)
        
        // Multiple in a row
        HStack {
            ActionLink(title: "Details")
            ActionLink(title: "Edit")
            ActionLink(title: "Remove")
        }
    }
    .padding()
}
