//
//  Ext+Collection.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

extension Collection {
   /// Provides safe array indexing that returns nil instead of crashing on out-of-bounds access
   /// - Parameter index: The index to access
   /// - Returns: Element at the index if it exists, nil otherwise
   /// - Example: let thirdItem = array[safe: 2] // Returns nil if array has fewer than 3 elements
   subscript (safe index: Index) -> Element? {
       return indices.contains(index) ? self[index] : nil
   }
}
