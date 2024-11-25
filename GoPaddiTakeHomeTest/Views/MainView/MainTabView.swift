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
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "airplane")
                }
            
            Text("Where")
                .tabItem {
                    Label("Where", systemImage: "location")
                }
            
            Text("Dates")
                .tabItem {
                    Label("Dates", systemImage: "calendar")
                }
            
            Text("Plan a Trip")
                .tabItem {
                    Label("Plan", systemImage: "plus.circle")
                }
        }
        .tint(AppColors.appBlue)
    }
}

#Preview {
    MainTabView()
}
