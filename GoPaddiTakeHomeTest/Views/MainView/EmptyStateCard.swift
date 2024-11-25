//
//  EmptyStateCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct EmptyStateCard: View {
    let type: ItineraryType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with icon and title
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(type.titleColor)
                Text(type.title)
                    .font(.headline)
                    .foregroundColor(type.titleColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // White content area
            VStack(spacing: 16) {
                // Empty state illustration and text
                VStack(spacing: 12) {
                    Image(type.illustrationName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .padding(.top, 24)
                    
                    Text("No request yet")
                        .foregroundColor(.secondary)
                        .padding(.bottom, 24)
                }
                
                // Add button
                Button(type.buttonTitle) {
                    // Handle button action
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundStyle(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding([.horizontal, .bottom], 16)
        }
        .background(type.backgroundColor)
        .cornerRadius(16)
    }
}

enum ItineraryType {
    case flights, hotels, activities
    
    var title: String {
        switch self {
        case .flights: return "Flights"
        case .hotels: return "Hotels"
        case .activities: return "Activities"
        }
    }
    
    var icon: String {
        switch self {
        case .flights: return "airplane.departure"  // Updated to match design
        case .hotels: return "building.2.fill"      // Updated to match design
        case .activities: return "figure.hiking"     // Updated to match design
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .flights: return "Add Flight"
        case .hotels: return "Add Hotel"
        case .activities: return "Add Activity"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .flights: return Color(.systemGray6)  // Updated to match design
        case .hotels: return Color(red: 0.06, green: 0.09, blue: 0.23)
        case .activities: return .blue
        }
    }
    
    var titleColor: Color {
        switch self {
        case .flights: return .primary
        case .hotels, .activities: return .white
        }
    }
    
    var illustrationName: String {
        switch self {
        case .flights: return "flight-empty-state"
        case .hotels: return "hotel-empty-state"
        case .activities: return "activities-empty-state"
        }
    }
}

#Preview("EmptyStateCard - All Cards") {
    ScrollView {
        VStack(spacing: 20) {
            Text("Trip Itineraries")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Your Trip itineraries are placed here")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            EmptyStateCard(type: .flights)
            EmptyStateCard(type: .hotels)
            EmptyStateCard(type: .activities)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
