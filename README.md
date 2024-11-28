# GoPaddi iOS Take Home Project

A SwiftUI-based iOS application for trip planning and management. Users can create trips, manage activities, flights, and hotels while having a seamless travel planning experience.
![GoPaddi icon](https://github.com/user-attachments/assets/dc8d3906-9b31-4b14-9810-6ea557d2b212)

<p align="center">
    <img src="https://github.com/user-attachments/assets/dc8d3906-9b31-4b14-9810-6ea557d2b212" width="250" height="250">
</p>

## Technologies Used

- SwiftUI for UI development
- MVVM architecture
- Async/await for asynchronous operations
- Codable for JSON parsing
- UserDefaults for local data persistence

## Features

### Core Features

- Trip creation and management
- Location selection with search functionality
- Date range selection with calendar interface
- Travel style selection (solo, couple, family, group)
- Trip details view with activity management

<p align="center">
  <img src="https://github.com/user-attachments/assets/814d3db9-1935-414f-af91-9035a5b00a03" width="376" height="900">
  
  <img src="https://github.com/user-attachments/assets/ab239f19-303c-4d15-96c4-0e5c89741d7a" width="376" height="900">
  <img src="https://github.com/user-attachments/assets/98297a0d-fdf2-4a36-8914-bf0e98a38a93" width="376" height="900">
  <img src="https://github.com/user-attachments/assets/75ce7cc8-046c-4935-9d66-fca047cd3b49" width="376" height="900">
  <img src="https://github.com/user-attachments/assets/9e78a6ee-5718-43b6-8c62-14abb50cec8c" width="376" height="900">
</p>

### Trip Components

- Flights management (add, view, remove)
- Hotels management (add, view, remove)
- Activities management (add, view, remove)

### Additional Features

- Offline data persistence
- Error handling and user feedback
- Loading states
- Image carousel for hotels and activities
- Share trip functionality

## Setup Instructions

### Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
```
2. Open `GoPaddiTakeHome.xcodeproj` in Xcode
3. Select your target device/simulator (iOS 16.0+)
4. Build and run the project (⌘ + R)

## API Documentation

The application uses a mock API service hosted on Beeceptor for demonstration purposes.

### Base URL
```
https://gopaddi.free.beeceptor.com/api
https://gopaddi1.free.beeceptor.com/api
https://gopaddi2.free.beeceptor.com/api
https://gopaddi3.free.beeceptor.com/api
https://gopaddi4.free.beeceptor.com/api
```

### Endpoints

#### Trips
- `GET /trips` - Fetch all trips
- `POST /trips` - Create a new trip
- `PUT /trips/{id}` - Update an existing trip
- `DELETE /trips/{id}` - Delete a trip

### API Response Format
```json
{
    "data": Object,
    "success": Boolean,
    "message": String?,
    "error": String?
}
```

### Known API Limitations

- Beeceptor has request limits on the free tier (when you exceed limits on a particular endpoint, choose another one from the options above)
- Mock data is returned for some endpoints
- Response delays may occur

## Architecture

The project follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define the data structures (Trip, Hotel, Flight, Activity)
- **Views**: SwiftUI views for UI representation
- **ViewModels**: Handle business logic and state management
- **Services**: API and data management services

## Future Improvements

- Implement real backend integration
- Add user authentication
- Enhanced error handling
- Improved offline capabilities
- Unit and UI tests
- Image upload functionality
- Enhanced search and filtering options

## Notes

- The project uses SwiftUI for all UI components, providing a modern and maintainable codebase
- Local storage is implemented using UserDefaults for demonstration purposes
- The application handles offline scenarios by storing data locally
- The mock API may have request limitations, affecting the demo experience

## Contact

For any questions or clarifications about the project, please reach out at [femialiu713@gmail.com]
