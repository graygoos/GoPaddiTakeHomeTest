//
//  ImageCarouselView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct ImageCarouselView: View {
    let images: [String] 
    @Binding var currentIndex: Int
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            if let imageName = images[safe: currentIndex] {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .clipped()
            }
            
            // Navigation arrows
            HStack {
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
    .previewLayout(.sizeThatFits)
}
