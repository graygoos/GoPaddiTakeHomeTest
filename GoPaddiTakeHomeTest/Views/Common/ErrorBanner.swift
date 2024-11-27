//
//  ErrorBanner.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A banner that displays error messages with a dismiss button
struct ErrorBanner: View {
    /// The error message to display
    let message: String
    
    /// Closure called when the dismiss button is tapped
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(message)
                    .foregroundColor(.red)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 4)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ErrorBanner(
        message: "An unexpected error occurred.",
        onDismiss: {
            print("Dismiss tapped.")
        }
    )
    .padding()
}

