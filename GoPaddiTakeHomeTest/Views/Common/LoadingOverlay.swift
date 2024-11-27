//
//  LoadingOverlay.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// An overlay view showing a loading indicator with text
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            // Loading indicator and text
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    LoadingOverlay()
}
