import SwiftUI

public struct ValueSliderOptions: OptionSet {
    public static let defaultOptions: ValueSliderOptions = []
    
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: InteractiveTrackOption
extension ValueSliderOptions {
    public static let interactiveTrack = ValueSliderOptions(rawValue: 1 << 0)
    var hasInteractiveTrack: Bool {
        self.contains(.interactiveTrack)
    }
}

// MARK: UpperTickMarkOption
extension ValueSliderOptions {
    public static let upperTickMark = ValueSliderOptions(rawValue: 1 << 1)
    var hasUpperTickMark: Bool {
        self.contains(.upperTickMark)
    }
}

// MARK: LowerTickMarkOption
extension ValueSliderOptions {
    public static let lowerTickMark = ValueSliderOptions(rawValue: 1 << 2)
    var hasLowerTickMark: Bool {
        self.contains(.lowerTickMark)
    }
}
