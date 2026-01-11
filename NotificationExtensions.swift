// MARK: - Notification Extensions
// NotificationExtensions.swift

import Foundation

extension Notification.Name {
    static let smileProbabilityUpdated = Notification.Name("smileProbabilityUpdated")
}

extension Notification {
    func extractProbability() -> Float? {
        if let doubleValue = userInfo?["probability"] as? Double {
            return Float(doubleValue)
        } else if let floatValue = userInfo?["probability"] as? Float {
            return floatValue
        } else if let numberValue = userInfo?["probability"] as? NSNumber {
            return numberValue.floatValue
        }
        return nil
    }
}
