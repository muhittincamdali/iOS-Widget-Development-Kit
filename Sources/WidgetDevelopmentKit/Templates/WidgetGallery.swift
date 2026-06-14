import SwiftUI
import WidgetKit

/// A world-class gallery of pre-built, copy-paste ready Widget Templates.
/// 
/// These templates are designed to dominate the iOS 17/18 Widget space with
/// Interactive Widgets and StandBy mode support.
public enum WidgetGallery {
    
    /// A high-conversion Crypto Tracker Widget.
    public struct CryptoWidget: View {
        public let coinName: String
        public let price: String
        public let trend: String
        public let isPositive: Bool
        
        public init(coinName: String, price: String, trend: String, isPositive: Bool) {
            self.coinName = coinName
            self.price = price
            self.trend = trend
            self.isPositive = isPositive
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundColor(.orange)
                    Text(coinName)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(price)
                    .font(.system(.title, design: .rounded).bold())
                    .foregroundColor(.primary)
                
                Text(trend)
                    .font(.subheadline.bold())
                    .foregroundColor(isPositive ? .green : .red)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(uiColor: .systemBackground)
            }
        }
    }
    
    /// An interactive Health & Fitness Goal Widget.
    public struct FitnessWidget: View {
        public let steps: Int
        public let goal: Int
        
        public init(steps: Int, goal: Int) {
            self.steps = steps
            self.goal = goal
        }
        
        public var body: some View {
            VStack {
                HStack {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.blue)
                    Text("Daily Steps")
                        .font(.subheadline.bold())
                    Spacer()
                }
                
                Spacer()
                
                Gauge(value: Double(steps), in: 0...Double(goal)) {
                    Text("\(steps)")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(Gradient(colors: [.blue, .purple]))
            }
            .padding()
            .containerBackground(for: .widget) {
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}

// Fallback for Color(uiColor:) on macOS
#if canImport(UIKit)
import UIKit
#else
public extension Color {
    init(uiColor: Any) { self = .clear }
}
public enum UIColor {
    public static let systemBackground = NSObject()
    public static let secondarySystemBackground = NSObject()
}
#endif
