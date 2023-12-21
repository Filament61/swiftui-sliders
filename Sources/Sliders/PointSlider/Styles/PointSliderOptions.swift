import SwiftUI

public struct PointSliderOptions: OptionSet {
    public let rawValue: Int

    public static let interactiveTrack = PointSliderOptions(rawValue: 1 << 0)
    public static let defaultOptions: PointSliderOptions = [.markerTrack]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    var hasInteractiveTrack: Bool {
        self.contains(.interactiveTrack)
    }
}


extension PointSliderOptions {
    
    public typealias Maker = Int
    public static var makers: Set<Maker> = []

    private static let markerTrack = PointSliderOptions(rawValue: 1 << 1)
    public static func markerTrack(makers: Set<Maker>) -> Self {
        .init(rawValue: markerTrack.rawValue, makers: makers)
    }

    public init(rawValue: Int, makers: Set<Maker>) {
        self.rawValue = rawValue
        Self.makers = makers
    }

    var hasMarkersTrack: Bool {
        self.contains(.markerTrack)
    }

}
struct tot {
    let mark: PointSliderOptions = PointSliderOptions(rawValue: 1 << 1, makers: Set([1, 2, 3, 4, 5, 6, 7, 8, 9]))
}
