//
//  EmptyStateCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct EmptyStateCard: View {
    let type: ItineraryType
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with icon and title
            HStack(spacing: 12) {
                // Circular icon background
                Circle()
                    .fill(type.iconBackgroundColor)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: type.icon)
                            .font(.system(size: 16))
                            .foregroundColor(type.iconColor)
                    }
                
                Text(type.title)
                    .font(.headline)
                    .foregroundColor(type.titleColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // White content area
            VStack(spacing: 10) {
                // Empty state illustration and text
                VStack(spacing: 12) {
                    Image(type.illustrationName)
                        .resizable()
                        .renderingMode(.template) // Enable template rendering for tinting
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundStyle(type.illustrationColor) // Apply tint color
                        .padding(.top, 32)
                    
                    Text("No request yet")
                        .font(.system(size: 15, weight: .medium))
                        .padding(.bottom, 32)
                }
                
                // Add button
                Button(action: onAdd) {
                    Text(type.buttonTitle)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "0054E4"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .frame(height: 280)
            .background(Color.white)
            .cornerRadius(12)
            .padding([.horizontal, .bottom], 16)
        }
        .background(type.backgroundColor)
        .cornerRadius(16)
    }
}

// Preview
#Preview("EmptyStateCard") {
    VStack(spacing: 20) {
        EmptyStateCard(type: .flights, onAdd: {})
        EmptyStateCard(type: .hotels, onAdd: {})
        EmptyStateCard(type: .activities, onAdd: {})
    }
    .padding()
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
        case .flights: return "airplane"
        case .hotels: return "building.2"
        case .activities: return "figure.hiking"
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
        case .flights: return Color(hex: "F0F2F5")
        case .hotels: return Color(hex: "344054")
        case .activities: return Color(hex: "0054E4")
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

    var iconBackgroundColor: Color {
        switch self {
        case .flights: return .white
        case .hotels, .activities: return .white.opacity(0.1)
        }
    }
    
    var iconColor: Color {
        switch self {
        case .flights: return Color(hex: "0054E4")
        case .hotels, .activities: return .white
        }
    }
    
    var buttonBackgroundColor: Color {
        switch self {
        case .flights, .hotels: return Color(hex: "0054E4")
        case .activities: return .white
        }
    }
    
    var buttonTextColor: Color {
        switch self {
        case .flights, .hotels: return .white
        case .activities: return Color(hex: "0054E4")
        }
    }
    
    var illustrationColor: Color {
        switch self {
        case .flights, .hotels, .activities:
            return .appBlue
        }
    }
}
