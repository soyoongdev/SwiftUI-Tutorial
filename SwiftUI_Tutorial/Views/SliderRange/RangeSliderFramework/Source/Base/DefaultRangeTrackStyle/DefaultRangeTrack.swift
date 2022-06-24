import SwiftUI

public struct DefaultRangeTrack<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    let range: ClosedRange<V>
    let bounds: ClosedRange<V>

    public var body: some View {
        //RangeSlider(range: range, in: bounds)
        RangeTrack()
    }
    
    public init(range: ClosedRange<V>, in bounds: ClosedRange<V> = 0.0...1.0) {
        self.range = range
        self.bounds = bounds
    }
}

#if DEBUG
struct DefaultRangeTrack_Previews: PreviewProvider {
    static var previews: some View {
        DefaultRangeTrack(range: 0.5...0.9)
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
