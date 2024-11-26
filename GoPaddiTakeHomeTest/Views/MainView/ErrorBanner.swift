//
//  ErrorBanner.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu on 26/11/2024.
//

import SwiftUI

struct ErrorBanner: View {
    let message: String
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

//#Preview {
//    ErrorBanner()
//}
