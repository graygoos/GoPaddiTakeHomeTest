//
//  CircleButton.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A circular button containing an SF Symbol icon
struct CircleButton: View {
    /// The SF Symbol name to display in the button
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(Color.black.opacity(0.5))
            .clipShape(Circle())
    }
}

#Preview {
    CircleButton(icon: "circle.fill")
}
