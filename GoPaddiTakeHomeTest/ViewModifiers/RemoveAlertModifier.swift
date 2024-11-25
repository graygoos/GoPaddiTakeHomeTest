//
//  RemoveAlertModifier.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct RemoveAlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    let title: String
    let message: String
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
