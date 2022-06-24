//
//  RangeSlider+Inits.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 24/06/2022.
//

import SwiftUI

/// Creates an instance that selects a range from within a range.
///
/// - Parameters:
///     - range: The selected range within `bounds`.
///     - bounds: The range of the valid values. Defaults to `0...1`.
///     - step: The distance between each valid value. Defaults to `0.001`.
///     - onEditingChanged: A callback for when editing begins and ends.
///
/// `onEditingChanged` will be called when editing begins and ends. For
/// example, on iOS, a `RangeSlider` is considered to be actively editing while
/// the user is touching the knob and sliding it around the track.
///

// MARK: -Inits
extension RangeSlider {

    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                track: TrackView,
                lowerThumb: LowerThumbView,
                upperThumb: UpperThumbView,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        assert(range.wrappedValue.lowerBound >= bounds.lowerBound, "Range value \(range.wrappedValue) is out of bounds \(bounds)")
        assert(range.wrappedValue.upperBound <= bounds.upperBound, "Range value \(range.wrappedValue) is out of bounds \(bounds)")
        self.range = range
        self.bounds = V(bounds.lowerBound)...V(bounds.upperBound)
        self.step = V(step)
        self.track = AnyView(track)
        self.lowerThumb = AnyView(lowerThumb)
        self.upperThumb = AnyView(upperThumb)
        self.onEditingChanged = onEditingChanged
    }
}

// MARK: -TrackView
extension RangeSlider where TrackView == DefaultRangeTrack<V> {
    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                lowerThumb: LowerThumbView,
                upperThumb: UpperThumbView,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        let track = DefaultRangeTrack(range: range.wrappedValue, in: bounds)
        self.init(range: range, in: bounds, step: step, track: track, lowerThumb: lowerThumb, upperThumb: upperThumb, onEditingChanged: onEditingChanged)
    }
}

// MARK: -LowerThumbView, UpperThumbView
extension RangeSlider where LowerThumbView == DefaultThumb, UpperThumbView == DefaultThumb {
    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                track: TrackView,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        self.init(range: range, in: bounds, step: step, track: track, lowerThumb: DefaultThumb(), upperThumb: DefaultThumb(), onEditingChanged: onEditingChanged)
    }
}

// MARK: -TrackView, LowerThumbView, UpperThumbView
extension RangeSlider where TrackView == DefaultRangeTrack<V>, LowerThumbView == DefaultThumb, UpperThumbView == DefaultThumb {
    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        let track = DefaultRangeTrack(range: range.wrappedValue, in: bounds)
        self.init(range: range, in: bounds, step: step, track: track, lowerThumb: DefaultThumb(), upperThumb: DefaultThumb(), onEditingChanged: onEditingChanged)
    }
}

// MARK: Inits for same LowerThumbView and UpperThumbView
extension RangeSlider where LowerThumbView == UpperThumbView {
    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                track: TrackView,
                thumb: LowerThumbView,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        self.init(range: range, in: bounds, step: step, track: track, lowerThumb: thumb, upperThumb: thumb, onEditingChanged: onEditingChanged)
    }
}

// MARK: Inits for same LowerThumbView, UpperThumbView and TrackView
extension RangeSlider where TrackView == DefaultRangeTrack<V>, LowerThumbView == UpperThumbView {
    public init(range: Binding<ClosedRange<V>>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.001,
                thumb: LowerThumbView,
                onEditingChanged: @escaping (Bool) -> Void = { _ in })
    {
        let track = DefaultRangeTrack(range: range.wrappedValue, in: bounds)
        self.init(range: range, in: bounds, step: step, track: track, lowerThumb: thumb, upperThumb: thumb, onEditingChanged: onEditingChanged)
    }
}
