//
//  CardContainer.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A generic container view that provides consistent styling for different card section types (flights, hotels, activities)
/// Used as a wrapper to maintain visual consistency across different card types in the app
struct CardContainer<Content: View>: View {
    /// The type of card section being displayed (determines styling)
    let type: CardSectionType
    /// The content view to be wrapped inside the container
    let content: Content
    
    /// Initializes a new card container with specified type and content
    /// - Parameters:
    ///   - type: The CardSectionType that determines the styling
    ///   - content: A closure returning the content view to be displayed
    init(type: CardSectionType, @ViewBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section with icon and title
            HStack(spacing: 8) {
                Image(systemName: type.icon)
                Text(type.title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(type.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(type.headerColor)
            
            // Main content area
            content
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .background(type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Card Sections - All Styles") {
    ScrollView {
        VStack(spacing: 20) {
            // Flights Section
            FlightCardSection(
                flight: Flight(
                    id: "1",
                    airline: "American Airlines",
                    flightNumber: "AA-829",
                    departureTime: Date(),
                    arrivalTime: Date().addingTimeInterval(6300),
                    origin: "LOS",
                    destination: "SIN",
                    price: 123450.00
                )
            ) {
                print("Flight removed")
            }
            
            // Hotels Section
            HotelCardSection(
                hotel: Hotel(
                    id: "1",
                    name: "Ritz Carlton",
                    address: "Fifth Avenue",
                    rating: 5.0,
                    reviews: 1000,
                    roomType: "Double Suite",
                    checkIn: Date(),
                    checkOut: Date().addingTimeInterval(86400 * 10),
                    price: 450000.00,
                    images: []
                )
            ) {
                print("Hotel removed")
            }
            
            // Activities Section
            ActivityCardSection(
                activity: Activity(
                    id: "1",
                    name: "Bunjee Jumping",
                    description: "Experience the thrill of falling from 100 meters",
                    location: "Canyon",
                    rating: 5.0,
                    reviews: 800,
                    duration: "2 hours",
                    timeSlot: Date(),
                    day: "Day 1 (Activity 1)",
                    price: 125000.00,
                    images: []
                )
            ) {
                print("Activity removed")
            }
        }
        .padding()
    }
}

/// Defines the appearance and content for different card section types in the app
/// Used to maintain consistent styling across different types of travel itinerary sections
enum CardSectionType {
   /// Flight-related card sections
   case flights
   /// Hotel-related card sections
   case hotels
   /// Activity-related card sections
   case activities
   
   /// The background color for the entire card section
   var backgroundColor: Color {
       switch self {
       case .flights:
           return Color(hex: "F0F2F5") // Light gray background
       case .hotels:
           return Color(hex: "344054") // Dark navy background
       case .activities:
           return Color(hex: "0054E4") // Bright blue background
       }
   }
   
   /// The background color for the header area of the card
   var headerColor: Color {
       switch self {
       case .flights:
           return Color(hex: "F0F2F5")
       case .hotels, .activities:
           return .clear // No distinct header background
       }
   }
   
   /// The color for text elements in the card
   var textColor: Color {
       switch self {
       case .flights:
           return .primary
       case .hotels, .activities:
           return .white
       }
   }
   
   /// The SF Symbol icon name for the card type
   var icon: String {
       switch self {
       case .flights:
           return "airplane"
       case .hotels:
           return "building.2"
       case .activities:
           return "figure.hiking"
       }
   }
   
   /// The display title for the card section
   var title: String {
       switch self {
       case .flights:
           return "Flights"
       case .hotels:
           return "Hotels"
       case .activities:
           return "Activities"
       }
   }
}
