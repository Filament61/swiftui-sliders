import SwiftUI

public struct ValueSliderOptions: OptionSet {
    public static let defaultOptions: ValueSliderOptions = []
    
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: Option : interactiveTrack
extension ValueSliderOptions {
    public static let interactiveTrack = ValueSliderOptions(rawValue: 1 << 0)
    var hasInteractiveTrack: Bool {
        self.contains(.interactiveTrack)
    }
}

// MARK: Option : markerTrack
extension ValueSliderOptions {
    public static let markerTrack = ValueSliderOptions(rawValue: 1 << 1)
    var hasMarkersTrack: Bool {
        self.contains(.markerTrack)
    }
}
