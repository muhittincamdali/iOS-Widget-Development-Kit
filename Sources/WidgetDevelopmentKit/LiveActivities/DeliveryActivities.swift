// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Delivery Tracking Activity

/// Food/Package delivery tracking Live Activity
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

// MARK: - Order Status Activity

/// E-commerce order tracking
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
#endif
