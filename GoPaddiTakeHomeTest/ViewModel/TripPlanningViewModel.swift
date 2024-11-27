//
//  TripPlanningViewModel.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

// MARK: - TripPlanningViewModel
/// ViewModel for managing trip planning and creation process
class TripPlanningViewModel: ObservableObject {
    // MARK: - Published Properties
    /// Controls visibility of the trip planner overlay
    @Published var showingPlannerOverlay = true
    /// Currently selected location for the trip
    @Published var selectedLocation: Location?
    /// Selected start and end dates for the trip
    @Published var tripDates = TripDate()
    /// Controls visibility of the location picker
    @Published var showLocationPicker = false
    /// Controls visibility of the date picker
    @Published var showDatePicker = false
    /// Flag indicating if selecting end date vs start date
    @Published var isSelectingEndDate = false
    /// Controls visibility of trip creation form
    @Published var showCreateTrip = false
    /// Controls visibility of trip details
    @Published var showTripDetail = false
    /// List of all trips
    @Published var trips: [Trip] = []
    /// Reference to newly created trip
    @Published var newlyCreatedTrip: Trip?
    
    // MARK: - API Related States
    /// Loading state indicator
    @Published var isLoading = false
    /// Error message for displaying to user
    @Published var errorMessage: String?
    /// Flag to control error alert visibility
    @Published var showError = false
    
    // MARK: - Private Properties
    /// Local storage manager for trips
    private let tripStore = TripStore.shared
    /// Service for API interactions
    private let apiService: APIServiceProtocol
    
    // MARK: - Computed Properties
    /// Determines if sufficient information is available to create a trip
    var canCreateTrip: Bool {
        selectedLocation != nil && tripDates.startDate != nil && tripDates.endDate != nil
    }
    
    // MARK: - Initialization
    /// Initializes the view model with an optional API service
    /// - Parameter apiService: Service for API interactions
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
        self.trips = tripStore.trips
    }
    
    // MARK: - Public Methods
    /// Fetches trips from both API and local storage
    @MainActor
    func fetchTrips() async {
        do {
            isLoading = true
            let fetchedTrips = try await apiService.fetchTrips()
            
            var allTrips = tripStore.trips
            for apiTrip in fetchedTrips {
                if !allTrips.contains(where: { $0.id == apiTrip.id }) {
                    allTrips.append(apiTrip)
                }
            }
            
            trips = allTrips.sorted(by: { $0.date > $1.date })
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch remote trips. Showing local trips only."
            showError = true
            isLoading = false
            trips = tripStore.trips
        }
    }
    
    /// Creates a new detailed trip with provided information
    /// - Parameters:
    ///   - name: Name of the trip
    ///   - travelStyle: Style of travel (e.g., solo, family)
    ///   - description: Detailed description of the trip
    @MainActor
    func createDetailedTrip(name: String, travelStyle: TravelStyle, description: String) {
        guard let location = selectedLocation,
              let startDate = tripDates.startDate,
              let endDate = tripDates.endDate else {
            return
        }
        
        Task {
            isLoading = true
            
            let newTrip = Trip(
                id: UUID().uuidString,
                name: name,
                destination: "\(location.name), \(location.country)",
                date: startDate,
                endDate: endDate,
                details: description,
                price: 0.0,
                images: [],
                location: location,
                travelStyle: travelStyle,
                flights: [],
                hotels: [],
                activities: []
            )
            
            do {
                let createdTrip = try await apiService.createTrip(newTrip)
                trips.insert(createdTrip, at: 0)
                tripStore.updateTrip(createdTrip)
                newlyCreatedTrip = createdTrip
            } catch {
                trips.insert(newTrip, at: 0)
                tripStore.updateTrip(newTrip)
                newlyCreatedTrip = newTrip
                errorMessage = "Trip saved locally only. Network error occurred."
                showError = true
            }
            
            showTripDetail = true
            resetFormData()
            isLoading = false
        }
    }
    
    // MARK: - Private Methods
    /// Resets all form data after trip creation
    private func resetFormData() {
        selectedLocation = nil
        tripDates = TripDate()
        showCreateTrip = false
        showingPlannerOverlay = false
    }
}
