# GeoReminders

An iOS app that lets users set geofence-based reminders for points of interest.

## Approach
- **Networking**: Fetches mock data from a GitHub-hosted JSON using `URLSession`.
- **Map**: Displays locations (blue pins) and reminders (red pins with circles) using `MapKit`.
- **Geofencing**: Monitors regions with `CoreLocation`, triggers notifications via `UserNotifications`.
- **Persistence**: Saves reminders in `CoreData`.
- **UI**: Simple `UISlider` for radius, list view with `UITableView`.
- **Architecture**: MVVM with ViewModels handling logic.

## Setup
1. Clone the repo: `git clone https://github.com/ommaraftab/GeoReminders.git`
2. Open `GeoReminders.xcodeproj` in Xcode.
3. Build and run on iOS 13+ simulator/device.

## Assumptions
- Mock API used instead of OpenStreetMap for simplicity.
- Fixed area for locations; no user location integration due to time constraints.

## Trade-offs
- Used `UISlider` instead of a custom circular control to prioritize functionality.
- Limited unit tests due to time; focused on core features.
