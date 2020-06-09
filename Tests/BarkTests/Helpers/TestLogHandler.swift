import Foundation
import Logging

class TestLogHandler: LogHandler {
    struct Item: Equatable {
        let level: Logger.Level
        let message: Logger.Message
        let metadata: Logger.Metadata?
        let file: String
        let function: String
        let line: UInt
    }

    let onLog: (Item) -> Void

    var logLevel: Logger.Level = .trace

    var metadata: Logger.Metadata = [:]

    let label: String

    init(label: String, onLog: @escaping (Item) -> Void) {
        self.label = label
        self.onLog = onLog
    }

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        onLog(Item(level: level, message: message, metadata: metadata, file: file, function: function, line: line))
    }
}
