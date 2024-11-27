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
            // Custom Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                }
                
                Text("Select Location")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.top, getSafeAreaTop())
            .background(Color(UIColor.systemBackground))
            
            // Search bar
            SearchBar(text: $searchText)
                .padding()
                .onChange(of: searchText) { _, newValue in
                    locationSearch.searchLocation(newValue)
                }
            
            if locationSearch.isLoading {
                ProgressView()
                    .padding()
            } else if let error = locationSearch.error {
                Text(error.userMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(locationSearch.searchResults) { location in
                    Button(action: {
                        selectedLocation = location
                        dismiss()
                    }) {
                        LocationRowView(location: location)
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
