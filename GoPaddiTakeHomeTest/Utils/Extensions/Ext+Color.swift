//
//  Ext+Color.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

extension Color {
   /// Initializes a Color from a hexadecimal color string
   /// Supports 3 formats:
   /// - 3 digits: RGB (4 bits per channel)
   /// - 6 digits: RGB (8 bits per channel)
   /// - 8 digits: ARGB (8 bits per channel)
   /// - Parameter hex: The hexadecimal color string (e.g., "FF0000" for red)
   init(hex: String) {
       // Remove any non-alphanumeric characters from the hex string
       let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
       
       // Convert hex string to integer
       var int: UInt64 = 0
       Scanner(string: hex).scanHexInt64(&int)
       
       // Variables to hold color components
       let a, r, g, b: UInt64
       
       // Parse hex string based on its length
       switch hex.count {
       case 3: // RGB (12-bit)
           // Convert 4-bit channels to 8-bit by repeating digits
           (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
       case 6: // RGB (24-bit)
           // Extract 8-bit channels
           (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
       case 8: // ARGB (32-bit)
           // Extract all channels including alpha
           (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
       default:
           // Return nearly transparent white for invalid input
           (a, r, g, b) = (1, 1, 1, 0)
       }
       
       // Initialize Color with normalized RGB values
       self.init(
           .sRGB,
           red: Double(r) / 255,
           green: Double(g) / 255,
           blue: Double(b) / 255,
           opacity: Double(a) / 255
       )
   }
}
