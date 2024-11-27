//
//  CircleButton.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct CircleButton: View {
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
