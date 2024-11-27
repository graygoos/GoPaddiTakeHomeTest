//
//  SplashScreen.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on 27/11/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            TripPlanningView()
        } else {
            ZStack {
                AppColors.appBlue
                    .ignoresSafeArea()
                
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
                    withAnimation(.easeIn(duration: 1.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
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
