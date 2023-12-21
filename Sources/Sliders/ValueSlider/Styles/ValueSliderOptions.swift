import SwiftUI

public struct ValueSliderOptions: OptionSet {
    public let rawValue: Int
    public let makers: Set<Maker>

    public static let interactiveTrack = ValueSliderOptions(rawValue: 1 << 0)
    public static let defaultOptions: ValueSliderOptions = [ ]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
        self.makers = Set([ ])
    }
    
    var hasInteractiveTrack: Bool {
        self.contains(.interactiveTrack)
    }
    
}

extension ValueSliderOptions {
    
    public typealias Maker = Int

    public static let markerTrack = ValueSliderOptions(rawValue: 1 << 1, makers: [ ])
    
    public init(rawValue: Int, makers: Set<Maker>) {
        self.rawValue = rawValue
        self.makers = makers
    }

    var hasMarkersTrack: Bool {
        self.contains(Self.markerTrack)
    }
    
}
