import SwiftUI

public struct HorizontalValueSliderStyle<Track: View, Thumb: View>: ValueSliderStyle {
    private let track: Track
    private let thumb: Thumb
    private let thumbSize: CGSize
    private let thumbInteractiveSize: CGSize
    private let thumbPositionOffset: CGFloat
    private let options: ValueSliderOptions

    public func makeBody(configuration: Self.Configuration) -> some View {
        let tickMarks = calculate(bounds: configuration.bounds)
        let track = self.track
            .environment(\.trackValue, configuration.value.wrappedValue)
            .environment(\.valueTrackConfiguration, ValueTrackConfiguration(
                bounds: configuration.bounds,
                leadingOffset: self.thumbSize.width / 2,
                trailingOffset: self.thumbSize.width / 2)
            )
            .accentColor(Color.accentColor)

        return GeometryReader { geometry in
            ZStack {
                if self.options.hasUpperTickMark || self.options.hasLowerTickMark {
                    tickMark(tickMarks, geometry: geometry, configuration: configuration)
                }
                if self.options.hasInteractiveTrack {
                    interactiveTrack(geometry: geometry, configuration: configuration)
                } else {
                    track
                }
                
                ZStack {
                    self.thumb
                        .frame(width: self.thumbSize.width, height: self.thumbSize.height)
                }
                .frame(minWidth: self.thumbInteractiveSize.width, minHeight: self.thumbInteractiveSize.height)
                .position(
                    x: distanceFrom(
                        value: configuration.value.wrappedValue,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        leadingOffset: self.thumbSize.width / 2,
                        trailingOffset: self.thumbSize.width / 2
                    ),
                    y: (geometry.size.height / 2) + thumbPositionOffset
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)

                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.x - distanceFrom(
                                    value: configuration.value.wrappedValue,
                                    availableDistance: geometry.size.width,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.thumbSize.width / 2,
                                    trailingOffset: self.thumbSize.width / 2
                                )
                            }

                            let computedValue = valueFrom(
                                distance: gestureValue.location.x - (configuration.dragOffset.wrappedValue ?? 0),
                                availableDistance: geometry.size.width,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.thumbSize.width / 2,
                                trailingOffset: self.thumbSize.width / 2
                            )

                            configuration.value.wrappedValue = computedValue
                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )
            }
        }
        .frame(minHeight: self.thumbInteractiveSize.height)
        
    }

    public init(track: Track,
                thumb: Thumb,
                thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = track
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
    
    @ViewBuilder
    private func interactiveTrack(geometry: GeometryProxy, 
                                  configuration: Self.Configuration) -> some View {
        track.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gestureValue in
                    configuration.onEditingChanged(true)
                    let computedValue = valueFrom(
                        distance: gestureValue.location.x,
                        availableDistance: geometry.size.width,
                        bounds: configuration.bounds,
                        step: configuration.step,
                        leadingOffset: self.thumbSize.width / 2,
                        trailingOffset: self.thumbSize.width / 2
                    )
                    configuration.value.wrappedValue = computedValue
                }
                .onEnded { _ in
                    configuration.onEditingChanged(false)
                }
        )
    }
    
    @ViewBuilder
    private func tickMark(_ tickMarks: [CGFloat], 
                          geometry: GeometryProxy,
                          configuration: Self.Configuration) -> some View {
        ZStack {
            ForEach(tickMarks, id: \.self) { tickMark in
                if self.options.hasUpperTickMark {
                    DefaultTickMark()
                        .frame(width: DefaultTickMark.size.width, height: DefaultTickMark.size.height)
                        .position(
                            x: distanceFrom(
                                value: tickMark,
                                availableDistance: geometry.size.width,
                                bounds: configuration.bounds,
                                leadingOffset: self.thumbSize.width / 2,
                                trailingOffset: self.thumbSize.width / 2
                            ),
                            y: (geometry.size.height / 2) - DefaultTickMark.position // 4,5 = (track.height + tickMark.height) / 2
                        )
                }
                
                if self.options.hasLowerTickMark {
                    DefaultTickMark()
                        .frame(width: DefaultTickMark.size.width, height: DefaultTickMark.size.height)
                        .position(
                            x: distanceFrom(
                                value: tickMark,
                                availableDistance: geometry.size.width,
                                bounds: configuration.bounds,
                                leadingOffset: self.thumbSize.width / 2,
                                trailingOffset: self.thumbSize.width / 2
                            ),
                            y: (geometry.size.height / 2) + DefaultTickMark.position // 4,5 = (track.height + tickMark.height) / 2
                        )
                }
            }
        }
        .zIndex(0)
    }
    
    private func calculate(bounds: ClosedRange<CGFloat>) -> [CGFloat] {
        let lower: CGFloat = bounds.lowerBound
        let upper: CGFloat = bounds.upperBound
        var marks = [CGFloat]()
        guard DefaultTickMark.number > 0 else { return [] }
        if DefaultTickMark.number == 1 {
            let mark = (upper - lower) / 2
            marks.append(mark)
        } else {
            for mark in stride(from: lower, through: upper,
                                 by: (upper - lower) / CGFloat(DefaultTickMark.number - 1)) {
                marks.append(mark)
            }
        }
        return marks
    }
    
}

extension HorizontalValueSliderStyle where Track == DefaultHorizontalValueTrack {
    public init(thumb: Thumb,
                thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = DefaultHorizontalValueTrack()
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
}

extension HorizontalValueSliderStyle where Thumb == DefaultThumb {
    public init(track: Track,
                thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = track
        self.thumb = DefaultThumb()
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
}

extension HorizontalValueSliderStyle where Thumb == DefaultThumb, Track == DefaultHorizontalValueTrack {
    public init(thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = DefaultHorizontalValueTrack()
        self.thumb = DefaultThumb()
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
}

public struct DefaultHorizontalValueTrack: View {
    public init() {}
    public var body: some View {
        HorizontalTrack()
            .frame(height: 3)
            .background(Color.secondary.opacity(0.25))
            .cornerRadius(1.5)
    }
}
