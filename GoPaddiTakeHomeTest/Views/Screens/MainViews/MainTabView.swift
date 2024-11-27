//
//  MainTabView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TripPlanningView()
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(AppColors.appBlue)
    }
}

#Preview {
    MainTabView()
}
