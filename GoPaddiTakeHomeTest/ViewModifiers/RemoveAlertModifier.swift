//
//  RemoveAlertModifier.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - Remove Alert Modifier
/// A view modifier that presents a confirmation alert before removing an item
struct RemoveAlertModifier: ViewModifier {
    /// Binding to control alert presentation
    @Binding var showAlert: Bool
    /// Title text for the alert
    let title: String
    /// Message text for the alert
    let message: String
    /// Closure to execute when removal is confirmed
    let onConfirm: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive, action: onConfirm)
            } message: {
                Text(message)
            }
    }
}
