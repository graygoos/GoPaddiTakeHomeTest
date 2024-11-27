//
//  LocationSearchService.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation
import CoreLocation

// MARK: - Service Errors

/// Defines possible errors that can occur during location search operations
enum LocationSearchError: Error {
   /// Network connectivity or request failure
   case networkError(Error)
   /// Server returned invalid or malformed data
   case invalidResponse
   /// Search returned no matching locations
   case noResults
   /// Search query is invalid or malformed
   case invalidQuery
   /// Too many requests made in a short time period
   case rateLimitExceeded
   /// Server-side error occurred
   case serverError
   
   /// User-friendly error messages for each error case
   var userMessage: String {
       switch self {
       case .networkError:
           return "Unable to search locations. Please check your connection."
       case .invalidResponse:
           return "Unable to process search results. Please try again."
       case .noResults:
           return "No locations found matching your search."
       case .invalidQuery:
           return "Please enter a valid search term."
       case .rateLimitExceeded:
           return "Too many searches. Please try again in a moment."
       case .serverError:
           return "Unable to complete search. Please try again later."
       }
   }
}

// MARK: - Service Protocol

/// Protocol defining location search functionality requirements
protocol LocationSearchServiceProtocol {
   /// Searches for locations matching the provided query
   /// - Parameter query: Search term to match against locations
   /// - Returns: Array of matching Location objects
   /// - Throws: LocationSearchError if search fails
   func searchLocation(_ query: String) async throws -> [Location]
   
   /// Clears the search results cache
   func clearCache()
}

// MARK: - Location Search Service

/// Service class handling location search operations with caching
class LocationSearchService: ObservableObject {
   // MARK: - Published Properties
   
   /// Current search results
   @Published private(set) var searchResults: [Location] = []
   /// Indicates if a search is in progress
   @Published private(set) var isLoading = false
   /// Current error state, if any
   @Published private(set) var error: LocationSearchError?
   
   // MARK: - Private Properties
   
   /// Service for making API requests
   private let apiService: APIService
   /// System geocoding service
   private let geocoder: CLGeocoder
   /// Current search task (for cancellation)
   private var searchTask: Task<Void, Never>?
   /// Cache for search results
   private var cache: NSCache<NSString, NSArray>
   
   // MARK: - Constants
   
   /// Configuration constants for search behavior
   private enum Constants {
       /// Minimum length of search query
       static let minimumQueryLength = 2
       /// Delay before executing search (for debouncing)
       static let searchDelay = 0.5
       /// Maximum number of cached results
       static let cacheLimit = 100
   }
   
   // MARK: - Initialization
   
   /// Initializes the location search service
   /// - Parameters:
   ///   - apiService: Service for API requests
   ///   - geocoder: Service for geocoding operations
   init(apiService: APIService = APIService(),
        geocoder: CLGeocoder = CLGeocoder()) {
       self.apiService = apiService
       self.geocoder = geocoder
       self.cache = NSCache<NSString, NSArray>()
       self.cache.countLimit = Constants.cacheLimit
       
       // Show all locations by default
       self.searchResults = Location.mockLocations
   }
   
   // MARK: - Public Methods
   
   /// Searches for locations matching the provided query
   /// Includes debouncing and caching
   /// - Parameter query: Search term to match against locations
   func searchLocation(_ query: String) {
       // Cancel any existing search
       searchTask?.cancel()
       
       // Clear error state
       error = nil
       
       // Validate query
       guard !query.isEmpty else {
           searchResults = Location.mockLocations // Show mock data when empty
           return
       }
       
       guard query.count >= Constants.minimumQueryLength else {
           return
       }
       
       // Check cache first
       if let cachedResults = checkCache(for: query) {
           self.searchResults = cachedResults
           return
       }
       
       // Create new search task with debouncing
       searchTask = Task { [weak self] in
           guard let self = self else { return }
           
           await MainActor.run {
               self.isLoading = true
           }
           
           // Add debounce delay
           try? await Task.sleep(nanoseconds: UInt64(Constants.searchDelay * 1_000_000_000))
           
           if Task.isCancelled { return }
           
           do {
               let results = try await performSearch(query)
               self.cacheResults(results, for: query)
               
               await MainActor.run {
                   self.searchResults = results
                   self.isLoading = false
               }
           } catch {
               await MainActor.run {
                   self.handleError(error)
                   self.isLoading = false
               }
           }
       }
   }
   
   /// Clears all cached search results
   func clearCache() {
       cache.removeAllObjects()
   }
   
   // MARK: - Private Methods
   
   /// Performs the actual location search
   /// Currently uses mock data, but would make API calls in production
   private func performSearch(_ query: String) async throws -> [Location] {
       return Location.mockLocations.filter { location in
           let searchString = query.lowercased()
           return location.name.lowercased().contains(searchString) ||
                  location.country.lowercased().contains(searchString) ||
                  (location.subtitle?.lowercased().contains(searchString) ?? false)
       }
   }
   
   /// Checks cache for existing search results
   private func checkCache(for query: String) -> [Location]? {
       if let cached = cache.object(forKey: query as NSString) as? [Location] {
           return cached
       }
       return nil
   }
   
   /// Caches search results for future use
   private func cacheResults(_ results: [Location], for query: String) {
       cache.setObject(results as NSArray, forKey: query as NSString)
   }
   
   /// Handles and formats errors from the search operation
   private func handleError(_ error: Error) {
       if let locationError = error as? LocationSearchError {
           self.error = locationError
       } else {
           self.error = .networkError(error)
       }
   }
}

// MARK: - Mock Data Extension

extension Location {
    /// Sample location data for testing and development
    static let mockLocations = [
        Location(
            id: "1",
            name: "Laghouat",
            country: "Algeria",
            flag: "🇩🇿",
            subtitle: "Laghouat"
        ),
        Location(
            id: "2",
            name: "Lagos",
            country: "Nigeria",
            flag: "🇳🇬",
            subtitle: "Murtala Muhammed"
        ),
        Location(
            id: "3",
            name: "Doha",
            country: "Qatar",
            flag: "🇶🇦",
            subtitle: "Doha"
        ),
        Location(
            id: "4",
            name: "Dubai",
            country: "United Arab Emirates",
            flag: "🇦🇪",
            subtitle: "Dubai International"
        ),
        Location(
            id: "5",
            name: "Paris",
            country: "France",
            flag: "🇫🇷",
            subtitle: "Charles de Gaulle"
        ),
        Location(
            id: "6",
            name: "London",
            country: "United Kingdom",
            flag: "🇬🇧",
            subtitle: "Heathrow"
        ),
        Location(
            id: "7",
            name: "New York",
            country: "United States",
            flag: "🇺🇸",
            subtitle: "JFK International"
        ),
        Location(
            id: "8",
            name: "Tokyo",
            country: "Japan",
            flag: "🇯🇵",
            subtitle: "Narita International"
        ),
        Location(
            id: "9",
            name: "Singapore",
            country: "Singapore",
            flag: "🇸🇬",
            subtitle: "Changi"
        ),
        Location(
            id: "10",
            name: "Sydney",
            country: "Australia",
            flag: "🇦🇺",
            subtitle: "Kingsford Smith"
        )
    ]
}
