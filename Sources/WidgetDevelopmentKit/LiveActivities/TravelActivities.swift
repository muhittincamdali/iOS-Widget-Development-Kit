// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Ride Sharing Activity

/// Uber/Lyft style ride tracking
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

// MARK: - Flight Tracking Activity

/// Flight status tracking
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
#endif
