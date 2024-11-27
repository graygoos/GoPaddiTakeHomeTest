//
//  StateWrapper.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// A wrapper view that manages state and provides it as a binding to child content
/// Useful for previews and situations where state needs to be injected
struct StateWrapper<Value, Content: View>: View {
    /// Internal state storage for the wrapped value
    @State private var value: Value
    /// Closure that creates content view using the state binding
    let content: (Binding<Value>) -> Content
    
    /// Creates a new StateWrapper
    /// - Parameters:
    ///   - value: Initial value for the state
    ///   - content: Closure that creates content using state binding
    init(initialState value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
