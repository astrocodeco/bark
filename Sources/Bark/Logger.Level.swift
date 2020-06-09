import Logging

public extension Logger.Level {
    /// Console-friendly uppercased name
    var name: String {
        switch self {
        case .trace:    return "TRACE"
        case .debug:    return "DEBUG"
        case .info:     return "INFO"
        case .notice:   return "NOTICE"
        case .warning:  return "WARN"
        case .error:    return "ERROR"
        case .critical: return "CRITICAL"
        }
    }
}
