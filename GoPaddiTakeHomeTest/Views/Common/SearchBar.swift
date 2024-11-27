//
//  SearchBar.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A search bar component with clear button functionality
struct SearchBar: View {
    /// Bound text value for the search input
    @Binding var text: String
    
    var body: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search text field
            TextField("Search...", text: $text)
                .foregroundColor(.primary)
                .font(.system(size: 18))
            
            // Clear button (only shown when text is not empty)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

#Preview {
    SearchBar(text: .constant("Search text"))
        .padding()
}

