import Foundation
import OpenAPIRuntime

public struct CustomDateTranscoder: DateTranscoder {

    public init() {

    }

    func getFormatters() -> [ISO8601DateFormatter] {
        var formatters: [ISO8601DateFormatter] = [
            ISO8601DateFormatter()
        ]
        // add support for milliseconds
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]
        formatters.append(formatter)
        return formatters
    }

    public func encode(_ value: Date) throws -> String {
        for formatter in getFormatters() {
            if let res = formatter.string(for: value) {
                return res
            }
        }
        throw EncodingError.invalidValue(
            value,
            .init(
                codingPath: [],
                debugDescription: "Expected date object is invalid."
            )
        )
    }

    public func decode(_ value: String) throws -> Date {
        for formatter in getFormatters() {
            if let res = formatter.date(from: value) {
                return res
            }
        }
        throw DecodingError.dataCorrupted(
            .init(
                codingPath: [],
                debugDescription: "Expected date string is invalid."
            )
        )
    }

}
