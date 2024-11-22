//
//  TripCardView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image carousel
            TabView {
                ForEach(trip.images, id: \.self) { imageURL in
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(AppColors.secondaryBackground)
                    }
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle())
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(trip.name)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.text)
                
                if let location = trip.location {
                    HStack {
                        Text(location.flag)
                        Text(location.name + ", " + location.country)
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Text(trip.date, style: .date)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                Text("$\(trip.price, specifier: "%.2f")")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.appBlue)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8, y: 4)
    }
}

#Preview("TripCardView - Default") {
    VStack(spacing: 20) {
        TripCardView(trip: Trip(
            id: "0",
            name: "New Trip",
            destination: "Unknown",
            date: Date(),
            details: "",
            price: 0.0,
            images: [],
            location: nil
        ))
        
        TripCardView(trip: Trip.sampleTrips[0])
        
        TripCardView(trip: Trip.sampleTrips[1])
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
