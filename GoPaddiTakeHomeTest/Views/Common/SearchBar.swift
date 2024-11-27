//
//  SearchBar.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A reusable search bar component that provides a standard search interface with focus handling
/// and text clearing capabilities.
struct SearchBar: View {
    // MARK: - Properties
    
    /// Binding to the search text that will be updated as the user types
    @Binding var text: String
    
    /// State variable to track whether the search field is currently focused
    @FocusState private var isFocused: Bool
    
    /// Optional closure that gets called when the search bar receives focus
    /// Can be used to trigger additional actions like showing initial search results
    var onFocus: (() -> Void)? = nil
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search text field
            TextField("Search...", text: $text)
                .foregroundColor(.primary)
                .font(.system(size: 18))
                .focused($isFocused)  // Bind to focus state
                .onChange(of: isFocused) { _, isFocused in
                    // Call onFocus closure when search bar becomes focused
                    if isFocused {
                        onFocus?()
                    }
                }
            
            // Clear button - only shows when there is text
            if !text.isEmpty {
                Button(action: {
                    text = ""  // Clear search text
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        // Visual styling
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

