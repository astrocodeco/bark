import XCTest
import Logging
@testable import Bark

private struct TestError: Error, Equatable {
    let value: String
    init(_ value: String) {
        self.value = value
    }
}

final class LogErrorTests: XCTestCase {
    func testLogWithNilError() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let message: Logger.Message = "Hello, world!"
        let metadataValue = "My Value!"

        logger.warning(message, error: nil, metadata: ["object": "\(metadataValue)"])
        logger.error(message, error: nil, metadata: ["object": "\(metadataValue)"])
        logger.critical(message, error: nil, metadata: ["object": "\(metadataValue)"])

        // Check what's in the log history
        let warning = history[0]
        XCTAssertEqual(warning.message, message)
        XCTAssertEqual(warning.level, .warning)
        XCTAssertNil(warning.metadata?["error"])
        XCTAssertEqual(warning.metadata?["object"], .string(metadataValue))

        let error = history[1]
        XCTAssertEqual(error.message, message)
        XCTAssertEqual(error.level, .error)
        XCTAssertNil(error.metadata?["error"])
        XCTAssertEqual(error.metadata?["object"], .string(metadataValue))

        let critical = history[2]
        XCTAssertEqual(critical.message, message)
        XCTAssertEqual(critical.level, .critical)
        XCTAssertNil(critical.metadata?["error"])
        XCTAssertEqual(critical.metadata?["object"], .string(metadataValue))
    }

    func testLogWithError() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let message: Logger.Message = "Hello, world!"
        let testError = TestError("Bad")
        let metadataValue = "My Value!"

        logger.warning(message, error: testError, metadata: ["object": "\(metadataValue)"])
        logger.error(message, error: testError, metadata: ["object": "\(metadataValue)"])
        logger.critical(message, error: testError, metadata: ["object": "\(metadataValue)"])

        // Check what's in the log history
        let warning = history[0]
        XCTAssertEqual(warning.message, message)
        XCTAssertEqual(warning.level, .warning)
        XCTAssertEqual(warning.metadata?["error"], "\(testError)")
        XCTAssertEqual(warning.metadata?["object"], .string(metadataValue))

        let error = history[1]
        XCTAssertEqual(error.message, message)
        XCTAssertEqual(error.level, .error)
        XCTAssertEqual(error.metadata?["error"], "\(testError)")
        XCTAssertEqual(error.metadata?["object"], .string(metadataValue))

        let critical = history[2]
        XCTAssertEqual(critical.message, message)
        XCTAssertEqual(critical.level, .critical)
        XCTAssertEqual(critical.metadata?["error"], "\(testError)")
        XCTAssertEqual(critical.metadata?["object"], .string(metadataValue))
    }

    func testLogWithErrorAlsoInMetadata() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let message: Logger.Message = "Hello, world!"
        let loggedError = TestError("Bad")
        let metadataValue = "My Value!"

        logger.warning(message, error: loggedError, metadata: ["object": "\(metadataValue)", "error": "This should not be here"])
        logger.error(message, error: loggedError, metadata: ["object": "\(metadataValue)", "error": "This should not be here"])
        logger.critical(message, error: loggedError, metadata: ["object": "\(metadataValue)", "error": "This should not be here"])

        XCTAssertEqual(history.count, 3)

        let warning = history[0]
        XCTAssertEqual(warning.level, .warning)
        XCTAssertEqual(warning.metadata?["error"], "\(loggedError)")

        let error = history[1]
        XCTAssertEqual(error.level, .error)
        XCTAssertEqual(error.metadata?["error"], "\(loggedError)")

        let critical = history[2]
        XCTAssertEqual(critical.level, .critical)
        XCTAssertEqual(critical.metadata?["error"], "\(loggedError)")
    }

    func testLogWithErrorAndNilMetadata() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let message: Logger.Message = "Hello, world!"
        let loggedError = TestError("Bad")

        logger.warning(message, error: loggedError)
        logger.error(message, error: loggedError)
        logger.critical(message, error: loggedError)

        XCTAssertEqual(history.count, 3)

        let warning = history[0]
        XCTAssertEqual(warning.level, .warning)
        XCTAssertEqual(warning.metadata?["error"], "\(loggedError)")

        let error = history[1]
        XCTAssertEqual(error.level, .error)
        XCTAssertEqual(error.metadata?["error"], "\(loggedError)")

        let critical = history[2]
        XCTAssertEqual(critical.level, .critical)
        XCTAssertEqual(critical.metadata?["error"], "\(loggedError)")
    }
}
