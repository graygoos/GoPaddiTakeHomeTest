//
//  LocationPickerView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: Location?
    @State private var searchText = ""
    @StateObject private var locationSearch = LocationSearchService()
    
    var body: some View {
        VStack(spacing: 0) {
            // ... header code ...
            
            // Search bar with loading indicator
            HStack {
                TextField("Please select a city", text: $searchText)
                    .textFieldStyle(.plain)
                    .padding()
                
                if locationSearch.isLoading {
                    ProgressView()
                        .padding(.trailing)
                }
            }
            .background(Color(UIColor.systemBackground))
            
            if let error = locationSearch.error {
                Text(error.userMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List {
                ForEach(locationSearch.searchResults) { location in
                    LocationRowView(location: location) {
                        selectedLocation = location
                        dismiss()
                    }
                }
            }
            .listStyle(.plain)
        }
        .onChange(of: searchText) { _, newValue in
            locationSearch.searchLocation(newValue)
        }
    }
}

// Extracted row view for better organization
struct LocationRowView: View {
    let location: Location
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image("location-icon")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name + ", " + location.country)
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
        }
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
