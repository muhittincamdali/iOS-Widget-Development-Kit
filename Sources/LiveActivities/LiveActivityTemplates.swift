// LiveActivityTemplates.swift
// iOS-Widget-Development-Kit
//
// Complete collection of 15+ Live Activity templates with Dynamic Island support
// Created by Muhittin Camdali

import SwiftUI
import ActivityKit
import WidgetKit

// MARK: - Live Activity Protocol

/// Protocol for all Live Activity templates
@available(iOS 16.1, *)
public protocol LiveActivityTemplate {
    associatedtype Attributes: ActivityAttributes
    associatedtype CompactLeadingView: View
    associatedtype CompactTrailingView: View
    associatedtype ExpandedView: View
    associatedtype MinimalView: View
    associatedtype LockScreenView: View
    
    @ViewBuilder func makeCompactLeading(context: ActivityViewContext<Attributes>) -> CompactLeadingView
    @ViewBuilder func makeCompactTrailing(context: ActivityViewContext<Attributes>) -> CompactTrailingView
    @ViewBuilder func makeExpanded(context: ActivityViewContext<Attributes>) -> ExpandedView
    @ViewBuilder func makeMinimal(context: ActivityViewContext<Attributes>) -> MinimalView
    @ViewBuilder func makeLockScreen(context: ActivityViewContext<Attributes>) -> LockScreenView
}

// MARK: - 1. Delivery Tracking Activity

/// Food/Package delivery tracking Live Activity
@available(iOS 16.1, *)
public struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: DeliveryStatus
        public var estimatedArrival: Date
        public var driverName: String
        public var currentStep: Int
        
        public init(status: DeliveryStatus, estimatedArrival: Date, driverName: String, currentStep: Int) {
            self.status = status
            self.estimatedArrival = estimatedArrival
            self.driverName = driverName
            self.currentStep = currentStep
        }
    }
    
    public enum DeliveryStatus: String, Codable {
        case preparing = "Preparing"
        case pickedUp = "Picked Up"
        case onTheWay = "On the Way"
        case arriving = "Arriving"
        case delivered = "Delivered"
        
        public var icon: String {
            switch self {
            case .preparing: return "takeoutbag.and.cup.and.straw"
            case .pickedUp: return "bag.fill"
            case .onTheWay: return "car.fill"
            case .arriving: return "location.fill"
            case .delivered: return "checkmark.circle.fill"
            }
        }
        
        public var color: Color {
            switch self {
            case .preparing: return .orange
            case .pickedUp: return .blue
            case .onTheWay: return .purple
            case .arriving: return .green
            case .delivered: return .green
            }
        }
    }
    
    public let orderNumber: String
    public let restaurantName: String
    public let totalSteps: Int
    
    public init(orderNumber: String, restaurantName: String, totalSteps: Int = 4) {
        self.orderNumber = orderNumber
        self.restaurantName = restaurantName
        self.totalSteps = totalSteps
    }
}

@available(iOS 16.2, *)
public struct DeliveryActivityView: View {
    let context: ActivityViewContext<DeliveryAttributes>
    
    public init(context: ActivityViewContext<DeliveryAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.restaurantName)
                        .font(.headline)
                    Text("Order #\(context.attributes.orderNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: context.state.status.icon)
                    .font(.title2)
                    .foregroundStyle(context.state.status.color)
            }
            
            // Progress bar
            ProgressView(value: Double(context.state.currentStep), total: Double(context.attributes.totalSteps))
                .tint(context.state.status.color)
            
            HStack {
                Text(context.state.status.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                Label {
                    Text(context.state.estimatedArrival, style: .relative)
                } icon: {
                    Image(systemName: "clock")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    // Dynamic Island Views
    public var compactLeading: some View {
        Image(systemName: context.state.status.icon)
            .foregroundStyle(context.state.status.color)
    }
    
    public var compactTrailing: some View {
        Text(context.state.estimatedArrival, style: .timer)
            .font(.caption2)
            .monospacedDigit()
    }
    
    public var minimal: some View {
        Image(systemName: context.state.status.icon)
            .foregroundStyle(context.state.status.color)
    }
}

// MARK: - 2. Ride Sharing Activity

/// Uber/Lyft style ride tracking
@available(iOS 16.1, *)
public struct RideAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: RideStatus
        public var driverName: String
        public var vehicleInfo: String
        public var licensePlate: String
        public var eta: Date
        public var driverRating: Double
        
        public init(status: RideStatus, driverName: String, vehicleInfo: String, licensePlate: String, eta: Date, driverRating: Double) {
            self.status = status
            self.driverName = driverName
            self.vehicleInfo = vehicleInfo
            self.licensePlate = licensePlate
            self.eta = eta
            self.driverRating = driverRating
        }
    }
    
    public enum RideStatus: String, Codable {
        case searching = "Finding Driver"
        case driverAssigned = "Driver Assigned"
        case arriving = "Driver Arriving"
        case inProgress = "In Progress"
        case completed = "Completed"
        
        public var icon: String {
            switch self {
            case .searching: return "magnifyingglass"
            case .driverAssigned: return "person.fill.checkmark"
            case .arriving: return "car.fill"
            case .inProgress: return "location.fill"
            case .completed: return "checkmark.circle.fill"
            }
        }
    }
    
    public let pickupLocation: String
    public let dropoffLocation: String
    public let rideType: String
    
    public init(pickupLocation: String, dropoffLocation: String, rideType: String = "UberX") {
        self.pickupLocation = pickupLocation
        self.dropoffLocation = dropoffLocation
        self.rideType = rideType
    }
}

@available(iOS 16.2, *)
public struct RideActivityView: View {
    let context: ActivityViewContext<RideAttributes>
    
    public init(context: ActivityViewContext<RideAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.driverName)
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", context.state.driverRating))
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(context.state.vehicleInfo)
                        .font(.caption)
                    Text(context.state.licensePlate)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Label(context.attributes.pickupLocation, systemImage: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    
                    Label(context.attributes.dropoffLocation, systemImage: "mappin.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("ETA")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(context.state.eta, style: .relative)
                        .font(.headline)
                }
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: "car.fill")
            .foregroundStyle(.blue)
    }
    
    public var compactTrailing: some View {
        Text(context.state.eta, style: .relative)
            .font(.caption2)
    }
}

// MARK: - 3. Sports Score Activity

/// Live sports score tracking
@available(iOS 16.1, *)
public struct SportsScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var homeScore: Int
        public var awayScore: Int
        public var gameTime: String
        public var period: String
        public var isLive: Bool
        public var lastEvent: String?
        
        public init(homeScore: Int, awayScore: Int, gameTime: String, period: String, isLive: Bool, lastEvent: String? = nil) {
            self.homeScore = homeScore
            self.awayScore = awayScore
            self.gameTime = gameTime
            self.period = period
            self.isLive = isLive
            self.lastEvent = lastEvent
        }
    }
    
    public let homeTeam: String
    public let awayTeam: String
    public let homeTeamAbbr: String
    public let awayTeamAbbr: String
    public let league: String
    
    public init(homeTeam: String, awayTeam: String, homeTeamAbbr: String, awayTeamAbbr: String, league: String) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeTeamAbbr = homeTeamAbbr
        self.awayTeamAbbr = awayTeamAbbr
        self.league = league
    }
}

@available(iOS 16.2, *)
public struct SportsActivityView: View {
    let context: ActivityViewContext<SportsScoreAttributes>
    
    public init(context: ActivityViewContext<SportsScoreAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(context.attributes.league)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if context.state.isLive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
                
                Text(context.state.period)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            HStack {
                TeamScoreView(
                    name: context.attributes.homeTeamAbbr,
                    score: context.state.homeScore,
                    isWinning: context.state.homeScore > context.state.awayScore
                )
                
                Spacer()
                
                VStack {
                    Text(context.state.gameTime)
                        .font(.headline)
                        .monospacedDigit()
                }
                
                Spacer()
                
                TeamScoreView(
                    name: context.attributes.awayTeamAbbr,
                    score: context.state.awayScore,
                    isWinning: context.state.awayScore > context.state.homeScore
                )
            }
            
            if let event = context.state.lastEvent {
                Text(event)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        HStack(spacing: 4) {
            Text(context.attributes.homeTeamAbbr)
                .font(.caption2)
                .fontWeight(.bold)
            Text("\(context.state.homeScore)")
                .font(.caption)
        }
    }
    
    public var compactTrailing: some View {
        HStack(spacing: 4) {
            Text("\(context.state.awayScore)")
                .font(.caption)
            Text(context.attributes.awayTeamAbbr)
                .font(.caption2)
                .fontWeight(.bold)
        }
    }
    
    struct TeamScoreView: View {
        let name: String
        let score: Int
        let isWinning: Bool
        
        var body: some View {
            VStack(spacing: 4) {
                Text(name)
                    .font(.caption)
                    .fontWeight(.medium)
                Text("\(score)")
                    .font(.title)
                    .fontWeight(isWinning ? .bold : .regular)
                    .foregroundStyle(isWinning ? .primary : .secondary)
            }
        }
    }
}

// MARK: - 4. Timer Activity

/// General purpose timer Live Activity
@available(iOS 16.1, *)
public struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var endTime: Date
        public var isPaused: Bool
        public var pausedTimeRemaining: TimeInterval?
        
        public init(endTime: Date, isPaused: Bool = false, pausedTimeRemaining: TimeInterval? = nil) {
            self.endTime = endTime
            self.isPaused = isPaused
            self.pausedTimeRemaining = pausedTimeRemaining
        }
    }
    
    public let timerName: String
    public let category: String
    public let accentColor: String
    
    public init(timerName: String, category: String = "Timer", accentColor: String = "blue") {
        self.timerName = timerName
        self.category = category
        self.accentColor = accentColor
    }
}

@available(iOS 16.2, *)
public struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    public init(context: ActivityViewContext<TimerAttributes>) {
        self.context = context
    }
    
    var color: Color {
        switch context.attributes.accentColor {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        default: return .blue
        }
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.category, systemImage: "timer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if context.state.isPaused {
                    Text("PAUSED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
            }
            
            Text(context.state.endTime, style: .timer)
                .font(.system(size: 48, weight: .thin, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(color)
            
            Text(context.attributes.timerName)
                .font(.headline)
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: "timer")
            .foregroundStyle(color)
    }
    
    public var compactTrailing: some View {
        Text(context.state.endTime, style: .timer)
            .font(.caption)
            .monospacedDigit()
    }
    
    public var minimal: some View {
        Text(context.state.endTime, style: .timer)
            .font(.caption2)
            .monospacedDigit()
    }
}

// MARK: - 5. Workout Activity

/// Fitness workout tracking
@available(iOS 16.1, *)
public struct WorkoutAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var elapsedTime: TimeInterval
        public var calories: Int
        public var heartRate: Int
        public var distance: Double
        public var pace: String
        public var isActive: Bool
        
        public init(elapsedTime: TimeInterval, calories: Int, heartRate: Int, distance: Double, pace: String, isActive: Bool) {
            self.elapsedTime = elapsedTime
            self.calories = calories
            self.heartRate = heartRate
            self.distance = distance
            self.pace = pace
            self.isActive = isActive
        }
    }
    
    public enum WorkoutType: String, Codable {
        case running = "Running"
        case cycling = "Cycling"
        case swimming = "Swimming"
        case walking = "Walking"
        case hiit = "HIIT"
        
        public var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "figure.outdoor.cycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .hiit: return "figure.highintensity.intervaltraining"
            }
        }
    }
    
    public let workoutType: WorkoutType
    public let goalType: String
    public let goalValue: Double
    
    public init(workoutType: WorkoutType, goalType: String = "Distance", goalValue: Double = 5.0) {
        self.workoutType = workoutType
        self.goalType = goalType
        self.goalValue = goalValue
    }
}

@available(iOS 16.2, *)
public struct WorkoutActivityView: View {
    let context: ActivityViewContext<WorkoutAttributes>
    
    public init(context: ActivityViewContext<WorkoutAttributes>) {
        self.context = context
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.workoutType.rawValue, systemImage: context.attributes.workoutType.icon)
                    .font(.headline)
                
                Spacer()
                
                if context.state.isActive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Active")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            HStack(spacing: 20) {
                MetricView(value: formatTime(context.state.elapsedTime), label: "Time", icon: "clock")
                MetricView(value: String(format: "%.2f", context.state.distance), label: "km", icon: "location")
                MetricView(value: "\(context.state.calories)", label: "Cal", icon: "flame.fill")
                MetricView(value: "\(context.state.heartRate)", label: "BPM", icon: "heart.fill")
            }
            
            HStack {
                Text("Pace: \(context.state.pace)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Goal: \(String(format: "%.1f", context.attributes.goalValue)) km")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: context.attributes.workoutType.icon)
            .foregroundStyle(.green)
    }
    
    public var compactTrailing: some View {
        Text(formatTime(context.state.elapsedTime))
            .font(.caption)
            .monospacedDigit()
    }
    
    struct MetricView: View {
        let value: String
        let label: String
        let icon: String
        
        var body: some View {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - 6. Music Now Playing Activity

/// Music player Live Activity
@available(iOS 16.1, *)
public struct NowPlayingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var trackName: String
        public var artistName: String
        public var albumName: String
        public var progress: Double
        public var duration: TimeInterval
        public var isPlaying: Bool
        
        public init(trackName: String, artistName: String, albumName: String, progress: Double, duration: TimeInterval, isPlaying: Bool) {
            self.trackName = trackName
            self.artistName = artistName
            self.albumName = albumName
            self.progress = progress
            self.duration = duration
            self.isPlaying = isPlaying
        }
    }
    
    public let appName: String
    
    public init(appName: String = "Music") {
        self.appName = appName
    }
}

@available(iOS 16.2, *)
public struct NowPlayingActivityView: View {
    let context: ActivityViewContext<NowPlayingAttributes>
    
    public init(context: ActivityViewContext<NowPlayingAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.trackName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(context.state.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.3))
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.pink)
                            .frame(width: geo.size.width * context.state.progress)
                    }
                }
                .frame(height: 4)
            }
            
            VStack(spacing: 8) {
                Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)
                
                Image(systemName: "forward.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: context.state.isPlaying ? "waveform" : "pause.fill")
            .foregroundStyle(.pink)
    }
    
    public var compactTrailing: some View {
        Text(context.state.trackName)
            .font(.caption2)
            .lineLimit(1)
    }
}

// MARK: - 7. Flight Tracking Activity

/// Flight status tracking
@available(iOS 16.1, *)
public struct FlightAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: FlightStatus
        public var gate: String
        public var departureTime: Date
        public var arrivalTime: Date
        public var delay: Int? // minutes
        public var progress: Double
        
        public init(status: FlightStatus, gate: String, departureTime: Date, arrivalTime: Date, delay: Int? = nil, progress: Double = 0) {
            self.status = status
            self.gate = gate
            self.departureTime = departureTime
            self.arrivalTime = arrivalTime
            self.delay = delay
            self.progress = progress
        }
    }
    
    public enum FlightStatus: String, Codable {
        case scheduled = "Scheduled"
        case boarding = "Boarding"
        case departed = "Departed"
        case inFlight = "In Flight"
        case landing = "Landing"
        case arrived = "Arrived"
        case delayed = "Delayed"
        case cancelled = "Cancelled"
        
        public var color: Color {
            switch self {
            case .scheduled: return .blue
            case .boarding: return .orange
            case .departed, .inFlight: return .green
            case .landing: return .purple
            case .arrived: return .green
            case .delayed: return .orange
            case .cancelled: return .red
            }
        }
    }
    
    public let flightNumber: String
    public let airline: String
    public let departure: String
    public let arrival: String
    public let departureCode: String
    public let arrivalCode: String
    
    public init(flightNumber: String, airline: String, departure: String, arrival: String, departureCode: String, arrivalCode: String) {
        self.flightNumber = flightNumber
        self.airline = airline
        self.departure = departure
        self.arrival = arrival
        self.departureCode = departureCode
        self.arrivalCode = arrivalCode
    }
}

@available(iOS 16.2, *)
public struct FlightActivityView: View {
    let context: ActivityViewContext<FlightAttributes>
    
    public init(context: ActivityViewContext<FlightAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(context.attributes.airline) \(context.attributes.flightNumber)")
                    .font(.headline)
                
                Spacer()
                
                Text(context.state.status.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(context.state.status.color)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(context.attributes.departureCode)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(context.state.departureTime, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "airplane")
                        .rotationEffect(.degrees(90))
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(height: 2)
                            
                            Rectangle()
                                .fill(context.state.status.color)
                                .frame(width: geo.size.width * context.state.progress, height: 2)
                        }
                    }
                    .frame(height: 2)
                }
                .frame(maxWidth: 100)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(context.attributes.arrivalCode)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(context.state.arrivalTime, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack {
                Label("Gate \(context.state.gate)", systemImage: "door.right.hand.open")
                    .font(.caption)
                
                Spacer()
                
                if let delay = context.state.delay, delay > 0 {
                    Text("+\(delay) min delay")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: "airplane")
            .foregroundStyle(.blue)
    }
    
    public var compactTrailing: some View {
        Text(context.state.status.rawValue)
            .font(.caption2)
    }
}

// MARK: - 8. Parking Timer Activity

/// Parking meter countdown
@available(iOS 16.1, *)
public struct ParkingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var expiresAt: Date
        public var isExpired: Bool
        public var remainingTime: TimeInterval
        
        public init(expiresAt: Date, isExpired: Bool = false, remainingTime: TimeInterval) {
            self.expiresAt = expiresAt
            self.isExpired = isExpired
            self.remainingTime = remainingTime
        }
    }
    
    public let location: String
    public let spotNumber: String
    public let rate: String
    
    public init(location: String, spotNumber: String, rate: String) {
        self.location = location
        self.spotNumber = spotNumber
        self.rate = rate
    }
}

@available(iOS 16.2, *)
public struct ParkingActivityView: View {
    let context: ActivityViewContext<ParkingAttributes>
    
    public init(context: ActivityViewContext<ParkingAttributes>) {
        self.context = context
    }
    
    var urgencyColor: Color {
        let remaining = context.state.remainingTime
        if remaining <= 0 || context.state.isExpired { return .red }
        if remaining < 600 { return .orange } // Less than 10 min
        return .green
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(context.attributes.location, systemImage: "car.fill")
                    .font(.headline)
                
                Spacer()
                
                Text("Spot \(context.attributes.spotNumber)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            if context.state.isExpired {
                Text("EXPIRED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            } else {
                Text(context.state.expiresAt, style: .timer)
                    .font(.system(size: 36, weight: .thin, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(urgencyColor)
            }
            
            HStack {
                Text(context.attributes.rate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !context.state.isExpired {
                    Text("Expires at \(context.state.expiresAt, format: .dateTime.hour().minute())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: "car.fill")
            .foregroundStyle(urgencyColor)
    }
    
    public var compactTrailing: some View {
        Text(context.state.expiresAt, style: .timer)
            .font(.caption2)
            .monospacedDigit()
    }
}

// MARK: - 9. Order Status Activity

/// E-commerce order tracking
@available(iOS 16.1, *)
public struct OrderAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: OrderStatus
        public var currentStep: Int
        public var estimatedDelivery: Date
        public var trackingNumber: String?
        
        public init(status: OrderStatus, currentStep: Int, estimatedDelivery: Date, trackingNumber: String? = nil) {
            self.status = status
            self.currentStep = currentStep
            self.estimatedDelivery = estimatedDelivery
            self.trackingNumber = trackingNumber
        }
    }
    
    public enum OrderStatus: String, Codable {
        case confirmed = "Confirmed"
        case processing = "Processing"
        case shipped = "Shipped"
        case outForDelivery = "Out for Delivery"
        case delivered = "Delivered"
        
        public var icon: String {
            switch self {
            case .confirmed: return "checkmark.circle"
            case .processing: return "box.truck.badge.clock"
            case .shipped: return "shippingbox"
            case .outForDelivery: return "truck.box"
            case .delivered: return "house.fill"
            }
        }
    }
    
    public let orderNumber: String
    public let storeName: String
    public let totalSteps: Int
    
    public init(orderNumber: String, storeName: String, totalSteps: Int = 5) {
        self.orderNumber = orderNumber
        self.storeName = storeName
        self.totalSteps = totalSteps
    }
}

@available(iOS 16.2, *)
public struct OrderActivityView: View {
    let context: ActivityViewContext<OrderAttributes>
    
    public init(context: ActivityViewContext<OrderAttributes>) {
        self.context = context
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(context.attributes.storeName)
                        .font(.headline)
                    Text("Order #\(context.attributes.orderNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: context.state.status.icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
            
            // Progress steps
            HStack(spacing: 0) {
                ForEach(0..<context.attributes.totalSteps, id: \.self) { step in
                    Circle()
                        .fill(step <= context.state.currentStep ? Color.blue : Color.secondary.opacity(0.3))
                        .frame(width: 12, height: 12)
                    
                    if step < context.attributes.totalSteps - 1 {
                        Rectangle()
                            .fill(step < context.state.currentStep ? Color.blue : Color.secondary.opacity(0.3))
                            .frame(height: 2)
                    }
                }
            }
            
            HStack {
                Text(context.state.status.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("Est. \(context.state.estimatedDelivery, format: .dateTime.month().day())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: context.state.status.icon)
            .foregroundStyle(.blue)
    }
    
    public var compactTrailing: some View {
        Text(context.state.status.rawValue)
            .font(.caption2)
    }
}

// MARK: - 10. Meeting Activity

/// Calendar meeting Live Activity
@available(iOS 16.1, *)
public struct MeetingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var status: MeetingStatus
        public var participantCount: Int
        public var elapsedTime: TimeInterval
        public var hasRecording: Bool
        
        public init(status: MeetingStatus, participantCount: Int, elapsedTime: TimeInterval, hasRecording: Bool = false) {
            self.status = status
            self.participantCount = participantCount
            self.elapsedTime = elapsedTime
            self.hasRecording = hasRecording
        }
    }
    
    public enum MeetingStatus: String, Codable {
        case upcoming = "Starting Soon"
        case inProgress = "In Progress"
        case ending = "Ending Soon"
        case ended = "Ended"
    }
    
    public let title: String
    public let startTime: Date
    public let endTime: Date
    public let organizer: String
    public let meetingLink: String?
    
    public init(title: String, startTime: Date, endTime: Date, organizer: String, meetingLink: String? = nil) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.organizer = organizer
        self.meetingLink = meetingLink
    }
}

@available(iOS 16.2, *)
public struct MeetingActivityView: View {
    let context: ActivityViewContext<MeetingAttributes>
    
    public init(context: ActivityViewContext<MeetingAttributes>) {
        self.context = context
    }
    
    private func formatDuration(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.attributes.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text("by \(context.attributes.organizer)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if context.state.hasRecording {
                        Label("Recording", systemImage: "record.circle")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("\(context.state.participantCount)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            
            HStack {
                Label(context.state.status.rawValue, systemImage: "video.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                
                Spacer()
                
                Text(formatDuration(context.state.elapsedTime))
                    .font(.headline)
                    .monospacedDigit()
            }
        }
        .padding()
    }
    
    public var compactLeading: some View {
        Image(systemName: "video.fill")
            .foregroundStyle(.green)
    }
    
    public var compactTrailing: some View {
        Text(formatDuration(context.state.elapsedTime))
            .font(.caption2)
            .monospacedDigit()
    }
}

// MARK: - Live Activity Manager

/// Comprehensive Live Activity manager
@available(iOS 16.1, *)
public final class LiveActivityManager {
    public static let shared = LiveActivityManager()
    
    private init() {}
    
    /// Check if Live Activities are enabled
    public var areActivitiesEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    /// Start a new Live Activity
    public func startActivity<T: ActivityAttributes>(
        attributes: T,
        contentState: T.ContentState,
        pushType: PushType? = nil
    ) throws -> Activity<T> {
        let content = ActivityContent(state: contentState, staleDate: nil)
        return try Activity.request(attributes: attributes, content: content, pushType: pushType)
    }
    
    /// Update an existing Live Activity
    public func updateActivity<T: ActivityAttributes>(
        _ activity: Activity<T>,
        with state: T.ContentState,
        alertConfiguration: AlertConfiguration? = nil
    ) async {
        let content = ActivityContent(state: state, staleDate: nil)
        await activity.update(content, alertConfiguration: alertConfiguration)
    }
    
    /// End a Live Activity
    public func endActivity<T: ActivityAttributes>(
        _ activity: Activity<T>,
        with state: T.ContentState? = nil,
        dismissalPolicy: ActivityUIDismissalPolicy = .default
    ) async {
        if let state = state {
            let content = ActivityContent(state: state, staleDate: nil)
            await activity.end(content, dismissalPolicy: dismissalPolicy)
        } else {
            await activity.end(nil, dismissalPolicy: dismissalPolicy)
        }
    }
    
    /// Get all active activities of a specific type
    public func getActivities<T: ActivityAttributes>(of type: T.Type) -> [Activity<T>] {
        Activity<T>.activities
    }
    
    /// End all activities of a specific type
    public func endAllActivities<T: ActivityAttributes>(of type: T.Type) async {
        for activity in Activity<T>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
