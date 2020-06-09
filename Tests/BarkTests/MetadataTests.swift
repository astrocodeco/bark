import XCTest
import Logging
@testable import Bark

final class MetadataTests: XCTestCase {
    func testMetadataString() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any("world"),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], "world")
    }

    func testMetadataInt() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(42),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], .stringConvertible("42"))
    }

    func testMetadataNil() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(Optional<Int>.none),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], "")
    }

    func testMetadataDouble() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(5.0),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], .stringConvertible("5.0"))
    }

    func testMetadataCustomType() throws {
        struct MyThing {
            let value: String = "Updog"
        }

        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(MyThing()),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], "MyThing(value: \"Updog\")")
    }

    func testMetadataStringArray() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(["a", "b", "c"]),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)
        XCTAssertEqual(item.metadata?["hello"], .array(["a", "b", "c"]))
    }

    func testMetadataIntArray() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any([3, 2, 1]),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)

        XCTAssertEqual(item.metadata?["hello"],
                       .array(["3", "2", "1"].map(Logger.MetadataValue.stringConvertible(_:))))
    }

    func testMetadataDictionaryStringArray() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(["nested": ["a", "b", "c"]]),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)

        XCTAssertEqual(item.metadata?["hello"],
                       .dictionary(["nested": ["a", "b", "c"]]))
    }

    func testMetadataNesting() throws {
        var history: [TestLogHandler.Item] = []

        let logger = Logger(label: "test", factory: {
            TestLogHandler(label: $0, onLog: { history.append($0) })
        })

        let metadata: Logger.Metadata = [
            "hello": .any(["nested": ["superNested": "hi"]]),
            "world": .any(["nested": ["superNested": ["hi"]]]),
            "numeric": .any(["nested": ["superNested": 42.0]]),
            "numericArray": .any(["nested": ["superNested": [42]]]),
        ]

        logger.trace("Test", metadata: metadata)

        let item = try XCTUnwrap(history.first)

        XCTAssertEqual(item.metadata?["hello"], .dictionary(["nested": .dictionary(["superNested": "hi"])]))
        XCTAssertEqual(item.metadata?["world"], .dictionary(["nested": .dictionary(["superNested": ["hi"]])]))
        XCTAssertEqual(item.metadata?["numeric"], .dictionary(["nested": .dictionary(["superNested": .stringConvertible("42.0")])]))
        XCTAssertEqual(item.metadata?["numericArray"], .dictionary(["nested": .dictionary(["superNested": [.stringConvertible("42")]])]))
    }
}
