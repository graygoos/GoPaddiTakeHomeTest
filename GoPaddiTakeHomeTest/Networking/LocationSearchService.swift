//
//  LocationSearchService.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation
import CoreLocation

// MARK: - Service Errors
enum LocationSearchError: Error {
    case networkError(Error)
    case invalidResponse
    case noResults
    case invalidQuery
    case rateLimitExceeded
    case serverError
    
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
protocol LocationSearchServiceProtocol {
    func searchLocation(_ query: String) async throws -> [Location]
    func clearCache()
}

// MARK: - Location Search Service
class LocationSearchService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var searchResults: [Location] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: LocationSearchError?
    
    // MARK: - Private Properties
    private let apiService: APIService
    private let geocoder: CLGeocoder
    private var searchTask: Task<Void, Never>?
    private var cache: NSCache<NSString, NSArray>
    
    // MARK: - Constants
    private enum Constants {
        static let minimumQueryLength = 2
        static let searchDelay = 0.5
        static let cacheLimit = 100
    }
    
    // MARK: - Initialization
    init(apiService: APIService = APIService(),
         geocoder: CLGeocoder = CLGeocoder()) {
        self.apiService = apiService
        self.geocoder = geocoder
        self.cache = NSCache<NSString, NSArray>()
        self.cache.countLimit = Constants.cacheLimit
    }
    
    // MARK: - Public Methods
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
            
            // Show loading state
            await MainActor.run {
                self.isLoading = true
            }
            
            // Add debounce delay
            try? await Task.sleep(nanoseconds: UInt64(Constants.searchDelay * 1_000_000_000))
            
            // Check for cancellation after delay
            if Task.isCancelled { return }
            
            do {
                let results = try await performSearch(query)
                
                // Cache successful results
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
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    // MARK: - Private Methods
    private func performSearch(_ query: String) async throws -> [Location] {
        // In a real app, you'd make an API call here
        // For now, we'll filter mock data
        return Location.mockLocations.filter { location in
            let searchString = query.lowercased()
            return location.name.lowercased().contains(searchString) ||
                   location.country.lowercased().contains(searchString) ||
                   (location.subtitle?.lowercased().contains(searchString) ?? false)
        }
    }
    
    private func checkCache(for query: String) -> [Location]? {
        if let cached = cache.object(forKey: query as NSString) as? [Location] {
            return cached
        }
        return nil
    }
    
    private func cacheResults(_ results: [Location], for query: String) {
        cache.setObject(results as NSArray, forKey: query as NSString)
    }
    
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
