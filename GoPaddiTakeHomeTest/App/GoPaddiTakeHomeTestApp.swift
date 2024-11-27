//
//  GoPaddiTakeHomeTestApp.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Main entry point for the GoPaddi trip planning application
/// The @main attribute identifies this as the app's launch point
@main
struct GoPaddiTakeHomeTestApp: App {
    /// Defines the root view hierarchy of the application
    /// - Returns: A Scene containing the app's initial view setup
    var body: some Scene {
        /// Creates the primary window for the application
        /// Initializes with SplashScreen as the root view
        WindowGroup {
            SplashScreen()
        }
    }
}
