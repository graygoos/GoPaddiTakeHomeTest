//
//  ImageCarouselView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Reusable carousel view for displaying images with navigation controls
struct ImageCarouselView: View {
    /// Array of image names to display
    let images: [String]
    /// Current index in the image array
    @Binding var currentIndex: Int
    /// Height of the carousel
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            // Display current image
            if let imageName = images[safe: currentIndex] {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .clipped()
            }
            
            // Navigation arrows overlay
            HStack {
                // Previous image button
                Button {
                    withAnimation {
                        currentIndex = (currentIndex - 1 + images.count) % images.count
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Next image button
                Button {
                    withAnimation {
                        currentIndex = (currentIndex + 1) % images.count
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview("ImageCarouselView") {
    VStack(spacing: 20) {
        StateWrapper(initialState: 0) { currentIndex in
            ImageCarouselView(
                images: ["hotel-1", "hotel-2", "hotel-3", "hotel-4"],
                currentIndex: currentIndex,
                height: 200
            )
        }
        
        StateWrapper(initialState: 0) { currentIndex in
            ImageCarouselView(
                images: ["activity-1", "activity-2", "activity-3", "activity-4"],
                currentIndex: currentIndex,
                height: 200
            )
        }
    }
    .padding()
}
