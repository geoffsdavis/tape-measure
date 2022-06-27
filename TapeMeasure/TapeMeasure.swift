//  TAPE MEASURE
//
//  Copyright 2022 - Geoff Davis
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// ----------------------------------------------------------------------------------------------------------
//
//  TAPE MEASURE
//
// TapeMeasure is a convenience class, written in Swift, that acts as a view model for rendering a visual tape measure,
// or any other graphical elements that need layout in a measured sequence. It can dynamically re-generate that data,
// so that the tape measure can be scrolled and/or scaled on the fly, due to animation or user interaction.
//
// The class that takes a few basic parameters, and can dynamically return an array that represents the ticks of a tape measure,
// as well as other useful information. The class itself is stateless except for those parameters, and is independent
// of any graphics frameworks. It can be used with SwiftUI, UIKit, CoreAnimation, SpriteKit, SceneKit, or any other graphics framework
// for MacOS or iOS.
//
//
// KEY CONCEPTS
//
// Position - A given "physical" (graphical) position on the tape measure. For instance, on a thermometer, the position
// for boiling water might at 300 graphical points.
//
// Segment - A span covering a single subdivision. On a real-world tape measure, a segment might define a distance of 1 cm, or maybe 1 inch.
//
// Value - The actual value of measurement at a given position. For instance, on a thermometer, the value at the position for boiling water
// would be 100ºC (212ºF).
//
// Origin - The position, in graphical points, where the value is 0.0. By default, segment borders always align with this position.
//
// Tick - Demarcations that define segments, as well as any subdivisions of segments. Put another way, a segment can be defined
// by one or more ticks.
//
// Tick Index - The index of ticks that defines a segment's starting boundary, as well as any segment subdivision boundaries.
// An index of 0 represents the segment's own starting boundary. Indices of greater than 0 represent the segment's
// subdivision staring boundaries.
//
//


import Foundation



public class TapeMeasure {
    
    
    // MARK: public parameters, exposed for mutation
    
    // Graphical position boundaries inside which TapeMeasure.Ticks will be generated. Ticks will only have positions within these boundaries.
    // For convenience, pass in the boundaries which match the layout in the intended view. The returned Tick positions will match nicely.
    public var positionBounds: ClosedRange<CGFloat>
    
    // The graphical length of a single segment, in graphical points. This would be the visual scale of the tape measure.
    public var segmentLength: CGFloat
    
    // The value per segment. This would be the value scale of the tape measure.
    public var segmentValue: Double
    
    // A value of 1 would indicated each segment is defined by a single tick, whereas greater than 1 would indicate a segment sub-divided
    // into that many ticks.
    public var ticksPerSegment: Int
    
    // num describing whether the Ticks are .ascending or .descending in value, within the supplied positionBounds
    public var direction: Direction
    
    // This optional parameter clips a tape measure by value, NOT position. For instance, in a scrolling tape measure,
    // if you don't want any ticks rendered below a value of 0.0, but also don't want to set any upper value bound,
    // you would pass in a closed range of 0.0...Double.greatestFiniteMagnitude. This is nil by default, to indicate no value clipping bounds.
    public var valueClippingBounds: ClosedRange<Double>?
    
    // An offset by position (graphical points) of the origin (location representing the value of 0.0), from the position of 0.0 pts.
    // This might be useful to stagger the ticks so they don't neatly line up with segments, which span a graphical distance but define units
    // of value. We'll see an example below. This is zero by default, to indicate no offset, so that the value of 0.0 would be
    // at the position of 0.0 pts.
    public var valueOriginOffset: Double
    
    // Special property that provides a "fudge factor" for dealing with floating point math precision issues. TapeMeasure uses this
    // when determining if ticks line up perfectly with origins or fall with given boundaries. Likely you won't have to change this,
    // but if for example you're dealing with very small fractional values, change this property as needed to adjust the precision up or down.
    public var tickAlignmentEpsilon: CGFloat = 0.001
    
    
    // MARK: computed properties
    
    public var valuePerTick: Double {
        return segmentValue / Double(ticksPerSegment)
    }
    
    public var tickDistance: CGFloat {
        return segmentLength / CGFloat(ticksPerSegment)
    }
    
    public var step: CGFloat {
        return direction == .ascending ? tickDistance : tickDistance * -1.0
    }
    
    public var startPosition: CGFloat {
        return direction == .ascending ? positionBounds.lowerBound : positionBounds.upperBound
    }
    public var endPosition: CGFloat {
        return direction == .ascending ? positionBounds.upperBound : positionBounds.lowerBound
    }
    
    
    // MARK: init
    
    public init(
        positionBounds: ClosedRange<CGFloat>,
        segmentLength: CGFloat,
        segmentValue: Double,
        ticksPerSegment: Int,
        direction: Direction,
        valueClippingBounds: ClosedRange<Double>? = nil,
        valueOriginOffset: Double = 0.0
    ) {
        self.positionBounds = positionBounds
        self.segmentLength = abs(segmentLength)
        self.segmentValue = abs(segmentValue)
        self.ticksPerSegment = ticksPerSegment
        self.direction = direction
        self.valueClippingBounds = valueClippingBounds
        self.valueOriginOffset = valueOriginOffset
    }
    
    
    // MARK: convenience methods for calculations
    

    private func rawPosition(forValue value: Double) -> CGFloat {
        return CGFloat(value / segmentValue) * segmentLength
    }
    
    private func rawValue(atPosition position: CGFloat) -> Double {
        return Double(position / segmentLength) * segmentValue
    }
    
    // corrects for a possible origin offset by value
    public func originPosition(
            withAnchorValue anchorValue: Double,
            atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let distanceOfAnchorFromOrigin = rawPosition(forValue: anchorValue)
        let distanceOfOriginOffsetByValue = rawPosition(forValue: valueOriginOffset)
        return anchorPosition - distanceOfAnchorFromOrigin + distanceOfOriginOffsetByValue
    }
    
    // remember, the origin itself may not be at position 0.0, due to a value-based offset of the origin from value 0.0
    public func distanceToOrigin(
        fromPosition positionToCheck: CGFloat,
        withAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let originPosition = originPosition(withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return positionToCheck - originPosition
    }
    
    public func value(
        atPosition positionToCheck: CGFloat,
        withAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> Double {
        let originOffset = distanceToOrigin(fromPosition: positionToCheck, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return rawValue(atPosition: originOffset)
    }
    
    public func position(
        forValue valueToCheck: Double,
        withAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let adjustedValue = valueToCheck - valueOriginOffset
        let rawPositionForValue = rawPosition(forValue: adjustedValue)
        let originPosition = originPosition(withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return originPosition + rawPositionForValue
    }
    
    
    public func ticks(forAnchorValue anchorValue: Double, atAnchorPosition anchorPosition: CGFloat) -> [Tick] {
        
        // First, find the first tick's position
        var firstTickPosition = startPosition
        var originOffset: CGFloat = distanceToOrigin(fromPosition: startPosition, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        
        // If there's a lower value clipping bound, adjust as necessary
        if let valueLowerBound = valueClippingBounds?.lowerBound {
            let valueLowerBoundPosition = position(forValue: valueLowerBound, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
            if valueLowerBoundPosition > startPosition {
                originOffset = distanceToOrigin(fromPosition: valueLowerBoundPosition, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
                firstTickPosition = valueLowerBoundPosition
            }
        }
 
        // Next, populate the first tick with all other initial tick date (value and index).
        // These will be iterated upon during tick generation
        var tickIndex = Int(originOffset / tickDistance)
        var tickValue = (Double(tickIndex) * valuePerTick) + valueOriginOffset
        
        // Find the offset of the first tick, in case the ticks are NOT aligned with the origin
        // Find the offset of the first tick, in case the ticks are NOT aligned with the origin.
        // This offset is the distance the first tick would be located from the starting boundary position, inside of the boundaries.
        // (A firstTickRemainder value of 0.0 would indicate there's no offset, so the ticks ARE aligned, and therefore the first tick
        // would be located exactly at the starting boundary position.)
        var firstTickRemainder = originOffset.truncatingRemainder(dividingBy: tickDistance)
        
        // Correct floating-point precision issues that might cause failure to infer that ticks are aligned (due to tiny non-zero offset)
        let precisionBounds = (abs(firstTickRemainder) - tickAlignmentEpsilon)...(abs(firstTickRemainder) + tickAlignmentEpsilon)
        if precisionBounds.contains(tickDistance) {
            firstTickRemainder = 0.0
        }
        
        // If first tick is not perfectly aligned on a tick multiple value, make corrections
        if originOffset >= 0.0 && firstTickRemainder > 0.0 {
            firstTickPosition += tickDistance - firstTickRemainder
            tickIndex += 1
            tickValue += valuePerTick
        }
        if originOffset < 0.0 && firstTickRemainder < 0.0 {
            firstTickPosition -= firstTickRemainder
        }
        
        // Finally, set the last tick position, adjusting if there's an upper value clipping bound
        var lastTickPosition = endPosition
        if let valueUpperBound = valueClippingBounds?.upperBound {
            let valueUpperBoundPosition = position(forValue: valueUpperBound, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
            lastTickPosition = min(lastTickPosition, valueUpperBoundPosition)
        }

        // Now, generate the Ticks
        var ticks = [Tick]()
        for pos in stride(from: firstTickPosition, through: lastTickPosition, by: step) {
            let relativeIndex = tickIndex % ticksPerSegment
            let subdivision = relativeIndex < 0 ? relativeIndex + ticksPerSegment : relativeIndex
            let tick = Tick(position: pos, value: tickValue, segmentTickIndex: subdivision)
            ticks.append(tick)
            tickIndex += 1
            tickValue += valuePerTick
        }

        return ticks
    }
    
}




// MARK: - TapeMeasure models

extension TapeMeasure {
    
    public struct Tick {
        
        let position: CGFloat
        let value: Double
        let segmentTickIndex: Int
        
        public func report() {
            if segmentTickIndex == 0 {
                print("[\(segmentTickIndex)] \(position) ------------ \"\(value)\"")
            }
            else {
                print("[\(segmentTickIndex)] \(position) -- \"\(value)\"")
            }
        }
        
    }
    
    public enum Direction {
        case ascending
        case descending
    }
    
}
