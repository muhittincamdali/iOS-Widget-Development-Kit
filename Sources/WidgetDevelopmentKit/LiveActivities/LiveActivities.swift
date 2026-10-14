// Live Activity attributes and views. ActivityKit exists only on iOS.

#if canImport(ActivityKit) && os(iOS)
import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Live Activity Helpers

/// Thin wrappers around ActivityKit that fill in `ActivityContent` and stale dates.
public enum LiveActivities {
    /// Whether the user allows Live Activities for this app.
    public static var areEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    /// Requests a new Live Activity.
    /// - Parameter staleAfter: Seconds after which the system marks the content as stale.
    public static func start<Attributes: ActivityAttributes>(
        _ attributes: Attributes,
        state: Attributes.ContentState,
        staleAfter: TimeInterval? = nil,
        pushType: PushType? = nil
    ) throws -> Activity<Attributes> {
        let content = ActivityContent(state: state, staleDate: staleAfter.map { Date().addingTimeInterval($0) })
        return try Activity.request(attributes: attributes, content: content, pushType: pushType)
    }

    /// Updates an activity's content.
    public static func update<Attributes: ActivityAttributes>(
        _ activity: Activity<Attributes>,
        state: Attributes.ContentState,
        staleAfter: TimeInterval? = nil,
        alert: AlertConfiguration? = nil
    ) async {
        let content = ActivityContent(state: state, staleDate: staleAfter.map { Date().addingTimeInterval($0) })
        await activity.update(content, alertConfiguration: alert)
    }

    /// Ends every running activity of the given type.
    public static func endAll<Attributes: ActivityAttributes>(
        _ type: Attributes.Type,
        dismissalPolicy: ActivityUIDismissalPolicy = .immediate
    ) async {
        for activity in Activity<Attributes>.activities {
            await activity.end(nil, dismissalPolicy: dismissalPolicy)
        }
    }
}
#endif
