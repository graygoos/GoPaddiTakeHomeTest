//
//  SplashScreen.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Initial splash screen view displayed when the app launches
struct SplashScreen: View {
    // MARK: - Properties
    
    /// Controls navigation to the main app view
    @State private var isActive = false
    
    /// Controls the scaling animation of the splash image
    @State private var size = 0.8
    
    /// Controls the fade-in animation of the splash image
    @State private var opacity = 0.5
    
    // MARK: - Body
    
    var body: some View {
        if isActive {
            TripPlanningView()
        } else {
            ZStack {
                // Background color
                AppColors.appBlue
                    .ignoresSafeArea()
                
                // Animated logo
                VStack {
                    Image("passport")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .colorInvert() // Makes the image white
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // Animate the logo appearance
                    withAnimation(.easeIn(duration: 1.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // Navigate to main app after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


#Preview("SplashScreen - Initial State") {
    SplashScreen()
}
