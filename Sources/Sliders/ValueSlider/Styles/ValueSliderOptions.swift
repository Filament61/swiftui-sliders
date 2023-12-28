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
