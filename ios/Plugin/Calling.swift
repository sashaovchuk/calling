import Foundation

@objc public class Calling: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
