import Logging

public extension Logger.MetadataValue {
    /// Try to match the object with various types and create the most appropriate metadata type.
    static func any(_ object: Any?) -> Logger.MetadataValue {
        switch object {
        case let string as String:
            return .string(string)

        case let array as [String]:
            return .array(array.map(Logger.MetadataValue.string))

        case let dict as [String: String]:
            return .dictionary(dict.mapValues(Logger.MetadataValue.string))

        case let dict as [String: Any]:
            return .dictionary(dict.mapValues(any))

        case let array as [CustomStringConvertible]:
            return .array(array.map(Logger.MetadataValue.stringConvertible))

        case let stringConvertible as CustomStringConvertible:
            return .stringConvertible(stringConvertible)

        case .some(let object):
            return "\(object)"

        case .none:
            return ""
        }
    }
}
