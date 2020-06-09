import Foundation
import Logging

public extension Logger.Metadata {
    /// Make a JSON representation of this metadata.
    ///
    /// - Sorts keys when possible (iOS 11+, macOS 10.13+)
    /// - Skips escaping slashes when possible (iOS 13+, macOS 10.15+)
    func makeJSONString() -> String {
        let jsonData: Data

        var options: JSONSerialization.WritingOptions = []

        if #available(OSX 10.13, iOS 11, *) {
            options.insert(.sortedKeys)
        }

        #if !os(Linux)
        if #available(OSX 10.15, iOS 13, *) {
            options.insert(.withoutEscapingSlashes)
        }
        #endif

        do {
            jsonData = try JSONSerialization.data(withJSONObject: mapValues(\.description), options: options)
        } catch {
            assertionFailure("Logging JSON serialization failed: \(error)")
            jsonData = Data()
        }

        return String(data: jsonData, encoding: .utf8) ?? ""
    }
}
