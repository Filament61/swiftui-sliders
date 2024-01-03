import SwiftUI

public struct VerticalValueSliderStyle<Track: View, Thumb: View>: ValueSliderStyle {
    private let track: Track
    private let thumb: Thumb
    private let thumbSize: CGSize
    private let thumbInteractiveSize: CGSize
    private let thumbPositionOffset: CGFloat
    private let options: ValueSliderOptions

    public func makeBody(configuration: Self.Configuration) -> some View {
        let tickMarks = DefaultTickMark.calculate(bounds: configuration.bounds)
        let track = self.track
            .environment(\.trackValue, configuration.value.wrappedValue)
            .environment(\.valueTrackConfiguration, ValueTrackConfiguration(
                bounds: configuration.bounds,
                leadingOffset: self.thumbSize.height / 2,
                trailingOffset: self.thumbSize.height / 2)
            )
            .accentColor(Color.accentColor)
        
        return GeometryReader { geometry in
            ZStack {
                if self.options.hasUpperTickMark || self.options.hasLowerTickMark {
                    tickMark(tickMarks, geometry: geometry, configuration: configuration)
                }
                if self.options.hasInteractiveTrack {
                    //  Cet appel ne fonctionne pas correctement. La View en retour n'anime pas la piste alors que le code est strictement identique...
                    //                    interactiveTrack(geometry: geometry, configuration: configuration)
                    track.gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                configuration.onEditingChanged(true)
                                let computedValue = configuration.bounds.upperBound - valueFrom(
                                    distance: gestureValue.location.y,
                                    availableDistance: geometry.size.height,
                                    bounds: configuration.bounds,
                                    step: configuration.step,
                                    leadingOffset: self.thumbSize.height / 2,
                                    trailingOffset: self.thumbSize.height / 2
                                )
                                configuration.value.wrappedValue = computedValue
                            }
                            .onEnded { _ in
                                configuration.onEditingChanged(false)
                            }
                    )
                } else {
                    track
                }
                
                ZStack {
                    self.thumb
                        .frame(width: self.thumbSize.width, height: self.thumbSize.height)
                }
                .frame(minWidth: self.thumbInteractiveSize.width, minHeight: self.thumbInteractiveSize.height)
                .position(
                    x: (geometry.size.width / 2) + thumbPositionOffset,
                    y: geometry.size.height - distanceFrom(
                        value: configuration.value.wrappedValue,
                        availableDistance: geometry.size.height,
                        bounds: configuration.bounds,
                        leadingOffset: self.thumbSize.height / 2,
                        trailingOffset: self.thumbSize.height / 2
                    )
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gestureValue in
                            configuration.onEditingChanged(true)
                            
                            if configuration.dragOffset.wrappedValue == nil {
                                configuration.dragOffset.wrappedValue = gestureValue.startLocation.y - (geometry.size.height - distanceFrom(
                                    value: configuration.value.wrappedValue,
                                    availableDistance: geometry.size.height,
                                    bounds: configuration.bounds,
                                    leadingOffset: self.thumbSize.height / 2,
                                    trailingOffset: self.thumbSize.height / 2
                                ))
                            }

                            let computedValue = valueFrom(
                                distance: geometry.size.height - (gestureValue.location.y - (configuration.dragOffset.wrappedValue ?? 0)),
                                availableDistance: geometry.size.height,
                                bounds: configuration.bounds,
                                step: configuration.step,
                                leadingOffset: self.thumbSize.height / 2,
                                trailingOffset: self.thumbSize.height / 2
                            )

                            configuration.value.wrappedValue = computedValue
                        }
                        .onEnded { _ in
                            configuration.dragOffset.wrappedValue = nil
                            configuration.onEditingChanged(false)
                        }
                )
            }
            .frame(width: geometry.size.width)
        }
        .frame(minWidth: self.thumbInteractiveSize.width)
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
    
    //  Cet appel ne fonctionne pas correctement. La View en retour n'anime pas la piste alors que le code est strictement identique... Voir plus haut !
//    private func interactiveTrack(geometry: GeometryProxy,
//                                  configuration: Self.Configuration) -> some View {
//        track.gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { gestureValue in
//                    configuration.onEditingChanged(true)
//                    let computedValue = configuration.bounds.upperBound - valueFrom(
//                        distance: gestureValue.location.y,
//                        availableDistance: geometry.size.height,
//                        bounds: configuration.bounds,
//                        step: configuration.step,
//                        leadingOffset: self.thumbSize.height / 2,
//                        trailingOffset: self.thumbSize.height / 2
//                    )
//                    configuration.value.wrappedValue = computedValue
//                }
//                .onEnded { _ in
//                    configuration.onEditingChanged(false)
//                }
//        )
//    }
    
    @ViewBuilder
    private func tickMark(_ tickMarks: [CGFloat],
                          geometry: GeometryProxy,
                          configuration: Self.Configuration) -> some View {
        ZStack {
            ForEach(tickMarks, id: \.self) { tickMark in
                if self.options.hasUpperTickMark {
                    DefaultTickMark()
                        .frame(width: DefaultTickMark.size.height, height: DefaultTickMark.size.width)
                        .position(
                            x: (geometry.size.width / 2) - DefaultTickMark.position,
                            y: distanceFrom(
                                value: tickMark,
                                availableDistance: geometry.size.height,
                                bounds: configuration.bounds,
                                leadingOffset: self.thumbSize.height / 2,
                                trailingOffset: self.thumbSize.height / 2
                            )
                        )
                }
                
                if self.options.hasLowerTickMark {
                    DefaultTickMark()
                        .frame(width: DefaultTickMark.size.height, height: DefaultTickMark.size.width)
                        .position(
                            x: (geometry.size.width / 2) + DefaultTickMark.position,
                            y: distanceFrom(
                                value: tickMark,
                                availableDistance: geometry.size.height,
                                bounds: configuration.bounds,
                                leadingOffset: self.thumbSize.height / 2,
                                trailingOffset: self.thumbSize.height / 2
                            )
                        )
                }
            }
        }
        .zIndex(0)
    }
    
}

extension VerticalValueSliderStyle where Track == DefaultVerticalValueTrack {
    public init(thumb: Thumb,
                thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = DefaultVerticalValueTrack()
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
}

extension VerticalValueSliderStyle where Thumb == DefaultThumb {
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

extension VerticalValueSliderStyle where Thumb == DefaultThumb, Track == DefaultVerticalValueTrack {
    public init(thumbSize: CGSize = .defaultThumbSize,
                thumbInteractiveSize: CGSize = .defaultThumbInteractiveSize,
                thumbPositionOffset: CGFloat = .defaultThumbPositionOffset,
                options: ValueSliderOptions = .defaultOptions) {
        self.track = DefaultVerticalValueTrack()
        self.thumb = DefaultThumb()
        self.thumbSize = thumbSize
        self.thumbInteractiveSize = thumbInteractiveSize
        self.thumbPositionOffset = thumbPositionOffset
        self.options = options
    }
}

public struct DefaultVerticalValueTrack: View {
    public var body: some View {
        VerticalTrack()
            .frame(width: 3)
            .background(Color.secondary.opacity(0.25))
            .cornerRadius(1.5)
    }
}
