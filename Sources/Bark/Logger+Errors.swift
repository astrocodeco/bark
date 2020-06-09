import Logging

public extension Logger {
    /// Log a message passing with the `Logger.Level.warning` log level.
    ///
    /// If `.warning` is at least as severe as the `Logger`'s `logLevel`, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - Parameters:
    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///   - error: An error to include in the metadata under the "error" key.
    ///   - metadata: One-off metadata to attach to this log message
    ///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#file`).
    ///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///               it defaults to `#function`).
    ///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#line`).
    @inlinable
    func warning(_ message: @autoclosure () -> Logger.Message,
                 error: @autoclosure () -> Error? = nil,
                 metadata: @autoclosure () -> Logger.Metadata? = nil,
                 file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .warning, message(), metadata: metadata()?.merging(error: error()), file: file, function: function, line: line)
    }

    /// Log a message passing with the `Logger.Level.error` log level.
    ///
    /// If `.error` is at least as severe as the `Logger`'s `logLevel`, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - Parameters:
    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///   - error: An error to include in the metadata under the "error" key.
    ///   - metadata: One-off metadata to attach to this log message
    ///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#file`).
    ///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///               it defaults to `#function`).
    ///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#line`).
    @inlinable
    func error(_ message: @autoclosure () -> Logger.Message,
               error: @autoclosure () -> Error? = nil,
               metadata: @autoclosure () -> Logger.Metadata? = nil,
               file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .error, message(), metadata: metadata()?.merging(error: error()), file: file, function: function, line: line)
    }

    /// Log a message passing with the `Logger.Level.critical` log level.
    ///
    /// If `.critical` is at least as severe as the `Logger`'s `logLevel`, it will be logged,
    /// otherwise nothing will happen.
    ///
    /// - Parameters:
    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///   - error: An error to include in the metadata under the "error" key.
    ///   - metadata: One-off metadata to attach to this log message
    ///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#file`).
    ///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///               it defaults to `#function`).
    ///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#line`).
    @inlinable
    func critical(_ message: @autoclosure () -> Logger.Message,
                  error: @autoclosure () -> Error? = nil,
                  metadata: @autoclosure () -> Logger.Metadata? = nil,
                  file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .critical, message(), metadata: metadata()?.merging(error: error()), file: file, function: function, line: line)
    }

    /// Log a message passing with the `Logger.Level.critical` log level and trigger Swift.assertionFailure().
    ///
    /// If `.critical` is at least as severe as the `Logger`'s `logLevel`, it will be logged.
    ///
    /// An assertion failure will occur regardless.
    ///
    /// - Parameters:
    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///   - error: An error to include in the metadata under the "error" key.
    ///   - metadata: One-off metadata to attach to this log message
    ///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#file`).
    ///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///               it defaults to `#function`).
    ///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#line`).
    @inlinable
    func assertionFailure(_ message: @autoclosure () -> Logger.Message,
                          error: @autoclosure () -> Error? = nil,
                          metadata: @autoclosure () -> Logger.Metadata? = nil,
                          file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(level: .critical, message(), metadata: metadata()?.merging(error: error()), file: file, function: function, line: line)
        Swift.assertionFailure(message().description)
    }

    /// Log a message passing with the `Logger.Level.critical` log level and trigger Swift.fatalError().
    ///
    /// If `.critical` is at least as severe as the `Logger`'s `logLevel`, it will be logged.
    ///
    /// A fatal error will stop the program's execution regardless.
    ///
    /// - Parameters:
    ///   - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///   - error: An error to include in the metadata under the "error" key.
    ///   - metadata: One-off metadata to attach to this log message
    ///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#file`).
    ///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///               it defaults to `#function`).
    ///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///           defaults to `#line`).
    @inlinable
    func fatal(_ message: @autoclosure () -> Logger.Message,
               error: @autoclosure () -> Error? = nil,
               metadata: @autoclosure () -> Logger.Metadata? = nil,
               file: String = #file, function: String = #function, line: UInt = #line) -> Never {
        self.log(level: .critical, message(), metadata: metadata()?.merging(error: error()), file: file, function: function, line: line)
        fatalError()
    }
}

// Must be public to satisfy inlinable requirements.
public extension Logger.Metadata {
    /// Add an error value to metadata. Replaces the existing "error" value if there is one.
    func merging(error: Error?) -> Logger.Metadata {
        error.map { self.merging(["error": "\($0)"], uniquingKeysWith: { old, new in new }) } ?? self
    }
}
