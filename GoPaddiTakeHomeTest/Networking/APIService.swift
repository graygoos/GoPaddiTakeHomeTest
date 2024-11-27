//
//  APIService.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import Foundation

// MARK: - API Response/Request Models
struct APIResponse<T: Codable>: Codable {
    let data: T
    let success: Bool?
    let message: String?
    let error: String?
}

struct APIRequest<T: Encodable>: Encodable {
    let data: T
}

// MARK: - API Errors
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case serverError(String)
    case clientError(String)
    
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

// MARK: - API Endpoints
enum APIEndpoint {
    static let trips = "trips"
    
    static func trip(_ id: String) -> String {
        return "trips/\(id)"
    }
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func fetchTrips() async throws -> [Trip]
    func createTrip(_ trip: Trip) async throws -> Trip
    func updateTrip(_ trip: Trip) async throws -> Trip
    func deleteTrip(_ tripId: String) async throws
}

// MARK: - API Service
class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let baseURL = "https://gopaddi1.free.beeceptor.com/api"
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private func makeRequest<T: Codable>(endpoint: String,
                                       method: String,
                                       body: Data? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            #if DEBUG
            if let responseString = String(data: data, encoding: .utf8) {
                print("\(method) \(endpoint) Response: \(responseString)")
            }
            #endif
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                // Handle empty response for DELETE
                if method == "DELETE" {
                    return EmptyResponse() as! T
                }
                
                do {
                    // Try parsing as APIResponse first
                    if let apiResponse = try? jsonDecoder.decode(APIResponse<T>.self, from: data) {
                        return apiResponse.data
                    }
                    
                    // Fallback to direct decoding
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
struct EmptyResponse: Codable {}

// MARK: - Mock API Service
class MockAPIService: APIService {
    override func fetchTrips() async throws -> [Trip] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
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
                date: Date().addingTimeInterval(86400 * 30),
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
    
    override func createTrip(_ trip: Trip) async throws -> Trip {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return trip
    }
    
    override func updateTrip(_ trip: Trip) async throws -> Trip {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return trip
    }
    
    override func deleteTrip(_ tripId: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
