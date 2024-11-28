//
//  APIService.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

/// Generic response structure for API calls
/// - T: The type of data expected in the response
struct APIResponse<T: Codable>: Codable {
    /// The main data payload returned from the API
    let data: T
    /// Indicates if the API call was successful
    let success: Bool?
    /// Optional success message from the server
    let message: String?
    /// Optional error message if the request failed
    let error: String?
}

/// Generic request structure for API calls
/// - T: The type of data being sent to the API
struct APIRequest<T: Encodable>: Encodable {
    /// The data payload to be sent to the API
    let data: T
}

/// Enumeration of possible API errors that can occur during network operations
enum APIError: Error {
    /// The URL is malformed or cannot be constructed
    case invalidURL
    /// The server response was not in the expected format
    case invalidResponse
    /// Failed to decode the response data into the expected type
    case decodingError(Error)
    /// Network-related errors (timeout, no connection, etc.)
    case networkError(Error)
    /// Server-side errors (500 range status codes)
    case serverError(String)
    /// Client-side errors (400 range status codes)
    case clientError(String)
    
    /// User-friendly error messages for each error case
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .invalidResponse:
            return "Server returned an invalid response"
        case .decodingError(let error):
            return "Data format error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .clientError(let message):
            return message
        }
    }
}

/// Constants for API endpoint paths
enum APIEndpoint {
    /// Endpoint for accessing all trips
    static let trips = "trips"
    
    /// Constructs the endpoint path for a specific trip
    /// - Parameter id: The unique identifier of the trip
    /// - Returns: The formatted endpoint path string
    static func trip(_ id: String) -> String {
        return "trips/\(id)"
    }
}

/// Protocol defining the core API operations for trip management
/// Provides a contract for implementing trip-related network requests
protocol APIServiceProtocol {
    /// Fetches all trips from the server
    /// - Returns: An array of Trip objects
    /// - Throws: APIError if the request fails
    func fetchTrips() async throws -> [Trip]
    
    /// Creates a new trip on the server
    /// - Parameter trip: The Trip object to be created
    /// - Returns: The created Trip object with server-assigned ID
    /// - Throws: APIError if the request fails
    func createTrip(_ trip: Trip) async throws -> Trip
    
    /// Updates an existing trip on the server
    /// - Parameter trip: The Trip object to be updated
    /// - Returns: The updated Trip object
    /// - Throws: APIError if the request fails
    func updateTrip(_ trip: Trip) async throws -> Trip
    
    /// Deletes a trip from the server
    /// - Parameter tripId: The unique identifier of the trip to delete
    /// - Throws: APIError if the request fails
    func deleteTrip(_ tripId: String) async throws
}

/// Concrete implementation of APIServiceProtocol handling network requests
class APIService: APIServiceProtocol {
    /// Shared singleton instance of APIService
    static let shared = APIService()
    
    /// Base URL for the API endpoints
    private let baseURL = "https://gopaddi.free.beeceptor.com/api"
    
    /// JSON decoder with custom configuration for API responses
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    /// JSON encoder with custom configuration for API requests
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    /// Makes a generic API request with the specified parameters
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: The HTTP method (GET, POST, PUT, DELETE)
    ///   - body: Optional request body data
    /// - Returns: Generic type T conforming to Codable
    /// - Throws: APIError for various failure cases
    private func makeRequest<T: Codable>(endpoint: String,
                                       method: String,
                                       body: Data? = nil) async throws -> T {
        // Construct URL from base URL and endpoint
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        // Configure request headers and parameters
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug logging for development
            #if DEBUG
            if let responseString = String(data: data, encoding: .utf8) {
                print("\(method) \(endpoint) Response: \(responseString)")
            }
            #endif
            
            // Validate response type
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Handle response based on status code
            switch httpResponse.statusCode {
            case 200...299:
                // Handle DELETE requests
                if method == "DELETE" {
                    return EmptyResponse() as! T
                }
                
                // Special handling for POST requests creating trips
                if method == "POST", let body = body, T.self == Trip.self {
                    do {
                        let originalTrip = try jsonDecoder.decode(Trip.self, from: body)
                        // Create new trip with generated ID
                        let newTrip = Trip(
                            id: UUID().uuidString,
                            name: originalTrip.name,
                            destination: originalTrip.destination,
                            date: originalTrip.date,
                            endDate: originalTrip.endDate,
                            details: originalTrip.details,
                            price: originalTrip.price,
                            images: originalTrip.images,
                            location: originalTrip.location,
                            travelStyle: originalTrip.travelStyle,
                            flights: originalTrip.flights,
                            hotels: originalTrip.hotels,
                            activities: originalTrip.activities
                        )
                        return newTrip as! T
                    } catch {
                        print("Error decoding POST body: \(error)")
                        throw APIError.decodingError(error)
                    }
                }
                
                // Handle standard successful responses
                do {
                    if let apiResponse = try? jsonDecoder.decode(APIResponse<T>.self, from: data) {
                        return apiResponse.data
                    }
                    return try jsonDecoder.decode(T.self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                    throw APIError.decodingError(error)
                }
                
            case 400...499:
                throw APIError.clientError("Request failed: \(String(data: data, encoding: .utf8) ?? "")")
            case 500...599:
                throw APIError.serverError("Server error")
            default:
                throw APIError.invalidResponse
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - APIServiceProtocol Implementation
    
    func fetchTrips() async throws -> [Trip] {
        return try await makeRequest(endpoint: "trips", method: "GET")
    }
    
    func createTrip(_ trip: Trip) async throws -> Trip {
        let encodedData = try jsonEncoder.encode(trip)
        return try await makeRequest(endpoint: "trips", method: "POST", body: encodedData)
    }
    
    func updateTrip(_ trip: Trip) async throws -> Trip {
        let encodedData = try jsonEncoder.encode(trip)
        return try await makeRequest(endpoint: "trips/\(trip.id)", method: "PUT", body: encodedData)
    }
    
    func deleteTrip(_ tripId: String) async throws {
        _ = try await makeRequest(endpoint: "trips/\(tripId)", method: "DELETE") as EmptyResponse
    }
}

// MARK: - Helper Types

/// Empty response type for API calls that don't return data
/// Used primarily for DELETE operations where no response body is expected
struct EmptyResponse: Codable {}

// MARK: - Mock API Service

/// Mock implementation of APIService for testing and development
/// Simulates network calls with artificial delays and mock data
class MockAPIService: APIService {
   
   /// Fetches mock trip data after simulated network delay
   /// - Returns: Array of sample Trip objects
   /// - Throws: May throw errors to simulate network failures
   override func fetchTrips() async throws -> [Trip] {
       // Simulate 1 second network delay
       try await Task.sleep(nanoseconds: 1_000_000_000)
       
       // Return mock trip data
       return [
           Trip(
               id: "1",
               name: "Dubai Adventure",
               destination: "Dubai, UAE",
               date: Date(),
               endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
               details: "Luxury resort stay in Dubai with desert safari and city tours.",
               price: 3850.00,
               images: [],
               location: Location(
                   id: "2",
                   name: "Dubai",
                   country: "United Arab Emirates",
                   flag: "🇦🇪",
                   subtitle: "Dubai International"
               ),
               travelStyle: .couple,
               flights: [],
               hotels: [],
               activities: []
           ),
           Trip(
               id: "2",
               name: "Paris Getaway",
               destination: "Paris, France",
               // 30 days from now
               date: Date().addingTimeInterval(86400 * 30),
               // 37 days from now (7 day trip)
               endDate: Date().addingTimeInterval(86400 * 37),
               details: "Romantic week in the city of lights.",
               price: 4200.00,
               images: [],
               location: Location(
                   id: "3",
                   name: "Paris",
                   country: "France",
                   flag: "🇫🇷",
                   subtitle: "Charles de Gaulle"
               ),
               travelStyle: .couple,
               flights: [],
               hotels: [],
               activities: []
           )
       ]
   }
   
   /// Simulates creating a new trip
   /// - Parameter trip: The Trip object to create
   /// - Returns: The same Trip object after simulated delay
   /// - Throws: May throw errors to simulate network failures
   override func createTrip(_ trip: Trip) async throws -> Trip {
       try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
       return trip
   }
   
   /// Simulates updating an existing trip
   /// - Parameter trip: The Trip object to update
   /// - Returns: The same Trip object after simulated delay
   /// - Throws: May throw errors to simulate network failures
   override func updateTrip(_ trip: Trip) async throws -> Trip {
       try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
       return trip
   }
   
   /// Simulates deleting a trip
   /// - Parameter tripId: ID of the trip to delete
   /// - Throws: May throw errors to simulate network failures
   override func deleteTrip(_ tripId: String) async throws {
       try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
   }
}
