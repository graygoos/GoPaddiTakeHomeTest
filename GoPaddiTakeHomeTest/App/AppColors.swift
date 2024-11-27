//
//  AppColors.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

/// Defines the custom color palette used throughout the application
/// This struct provides a centralized way to manage and access app-wide colors
struct AppColors {
    /// Primary blue color used for branding and key UI elements
    /// Loaded from asset catalog with name "AppBlue"
    static let appBlue = Color("AppBlue", bundle: nil)
    
    /// Main background color that adapts to light/dark mode
    /// Maps to the system's default background color
    static let background = Color(UIColor.systemBackground)
    
    /// Secondary background color for content grouping
    /// Slightly different from the main background to create visual hierarchy
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    
    /// Primary text color that adapts to light/dark mode
    /// Used for main content and headlines
    static let text = Color(UIColor.label)
    
    /// Secondary text color for less emphasized content
    /// Used for subtitles, captions, and supporting text
    static let secondaryText = Color(UIColor.secondaryLabel)
}

/// Defines the typography system used throughout the application
/// This struct provides consistent font styles and sizes
struct AppFonts {
    /// Large bold title font
    /// Used for main headlines and screen titles
    /// Size: 24pt, Weight: Bold
    static let title = Font.system(size: 24, weight: .bold)
    
    /// Medium semibold font
    /// Used for section headers and important content
    /// Size: 17pt, Weight: Semibold
    static let headline = Font.system(size: 17, weight: .semibold)
    
    /// Standard body text font
    /// Used for regular content and descriptions
    /// Size: 15pt, Weight: Regular
    static let body = Font.system(size: 15)
    
    /// Small caption font
    /// Used for supplementary information and labels
    /// Size: 13pt, Weight: Regular
    static let caption = Font.system(size: 13)
}
