//
//  LocationPickerView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A view that allows users to search and select from a list of locations
/// Displays locations with their country flags and relevant details
struct LocationPickerView: View {
    // MARK: - Properties
    
    /// Environment variable to handle view dismissal
    @Environment(\.dismiss) private var dismiss
    
    /// Binding to the selected location that will be updated when user makes a selection
    @Binding var selectedLocation: Location?
    
    /// State variable to store the current search text
    @State private var searchText = ""
    
    /// StateObject to manage location search functionality and results
    @StateObject private var locationSearch = LocationSearchService()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Section
            
            HStack {
                // Dismiss button
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                }
                
                // Title
                Text("Select Location")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.top, getSafeAreaTop())
            .background(Color(UIColor.systemBackground))
            
            // MARK: - Search Section
            
            // Search bar with automatic location display on focus
            SearchBar(text: $searchText) {
                // Show all locations when search bar is focused
                locationSearch.searchLocation("")
            }
            .padding()
            .onChange(of: searchText) { _, newValue in
                // Filter locations based on search text
                locationSearch.searchLocation(newValue)
            }
            
            // MARK: - Content Section
            
            // Show loading indicator while fetching results
            if locationSearch.isLoading {
                ProgressView()
                    .padding()
            }
            // Show error message if search fails
            else if let error = locationSearch.error {
                Text(error.userMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            // Show location results
            else {
                List {
                    ForEach(locationSearch.searchResults) { location in
                        Button(action: {
                            // Update selected location and dismiss view when user makes a selection
                            selectedLocation = location
                            dismiss()
                        }) {
                            LocationRowView(location: location)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct LocationRowView: View {
    let location: Location
    
    var body: some View {
        HStack(spacing: 12) {
            // Location icon with corresponding image from assets
            Image(location.name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(location.name), \(location.country)")
                    .foregroundColor(.primary)
                if let subtitle = location.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(location.flag)
                .font(.title2)
        }
        .padding(.vertical, 8)
    }
}

// Helper function to get safe area top padding
func getSafeAreaTop() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        return window.safeAreaInsets.top
    }
    return 0
}

#Preview("LocationPickerView") {
    LocationPickerView(selectedLocation: .constant(Location(
        id: "",
        name: "",
        country: "Lagos",
        flag: "Nigeria",
        subtitle: "🇳🇬"
    )))
}
