//
//  EmptyStateCard.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that displays a placeholder state when no items exist for a particular itinerary type
/// Includes an illustration, text, and an add button
struct EmptyStateCard: View {
    /// The type of itinerary item (flights, hotels, activities)
    let type: ItineraryType
    /// Callback closure executed when the add button is tapped
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with circular icon and title
            HStack(spacing: 12) {
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
            
            // Content area with illustration and add button
            VStack(spacing: 10) {
                // Empty state messaging
                VStack(spacing: 12) {
                    Image(type.illustrationName)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundStyle(type.illustrationColor)
                        .padding(.top, 32)
                    
                    Text("No request yet")
                        .font(.system(size: 15, weight: .medium))
                        .padding(.bottom, 32)
                }
                
                // Add item button
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

/// Defines styling and content properties for different types of itinerary items
/// Used for empty states and itinerary item displays
enum ItineraryType {
   case flights, hotels, activities
   
   /// The display title for the itinerary type
   var title: String {
       switch self {
       case .flights: return "Flights"
       case .hotels: return "Hotels"
       case .activities: return "Activities"
       }
   }
   
   /// The SF Symbol icon name for the itinerary type
   var icon: String {
       switch self {
       case .flights: return "airplane"
       case .hotels: return "building.2"
       case .activities: return "figure.hiking"
       }
   }
   
   /// The text to display on the add button
   var buttonTitle: String {
       switch self {
       case .flights: return "Add Flight"
       case .hotels: return "Add Hotel"
       case .activities: return "Add Activity"
       }
   }
   
   /// The background color for the itinerary section
   var backgroundColor: Color {
       switch self {
       case .flights: return Color(hex: "F0F2F5")
       case .hotels: return Color(hex: "344054")
       case .activities: return Color(hex: "0054E4")
       }
   }
   
   /// The color for title text
   var titleColor: Color {
       switch self {
       case .flights: return .primary
       case .hotels, .activities: return .white
       }
   }
   
   /// The name of the empty state illustration asset
   var illustrationName: String {
       switch self {
       case .flights: return "flight-empty-state"
       case .hotels: return "hotel-empty-state"
       case .activities: return "activities-empty-state"
       }
   }
   
   /// The background color for the icon container
   var iconBackgroundColor: Color {
       switch self {
       case .flights: return .white
       case .hotels, .activities: return .white.opacity(0.1)
       }
   }
   
   /// The color of the icon itself
   var iconColor: Color {
       switch self {
       case .flights: return Color(hex: "0054E4")
       case .hotels, .activities: return .white
       }
   }
   
   /// The background color for action buttons
   var buttonBackgroundColor: Color {
       switch self {
       case .flights, .hotels: return Color(hex: "0054E4")
       case .activities: return .white
       }
   }
   
   /// The text color for action buttons
   var buttonTextColor: Color {
       switch self {
       case .flights, .hotels: return .white
       case .activities: return Color(hex: "0054E4")
       }
   }
   
   /// The color for the empty state illustration
   var illustrationColor: Color {
       switch self {
       case .flights, .hotels, .activities:
           return .appBlue
       }
   }
}
