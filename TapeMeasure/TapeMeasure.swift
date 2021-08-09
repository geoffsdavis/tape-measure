import Foundation




// TapeMeasure is a convenience class for creating data to render a visual tape measure, or other visual effects
// that need to be laid out, and perhaps dynamically scrolled and/or scaled due to animation or user interaction.
//
//  Key Concepts:
//
//    * anchor value - the acutal value at a given position. For instance, on a thermometer,
//    the value at the position for boiling water would be 100ºC (212ºF)
//
//    * anchor position - a given "physical" position on the tape measure. For intance, on a thermometer,
//    the position for boiling water might at 300 pixels from the therometer's origin
//
//    * origin - the position at 0.0. Segment borders align with this position
//
//    * segment - a length which defines a single segment. On a real-world tape measure, a segment would be 1 inch
//
//    * tick - a subdivision of a segment. Segments can have 1 or more ticks
//
//    * tick index - the index of ticks within a segment (i.e. segment subdivisions). An index of 0 is at the segment's own "starting border"
//
//
// TapeMeasure takes some intial parameters on instantiation, all of which can be mutated at any time.
//
//    The postional boundaries in which TapeMeasure Ticks will be generated. Ticks will only have positions within these boundaries.
//    For convenience, pass in the boundaries which match the layout in the intended view. The returned Tick positions will match nicely.
//    - positionBounds: ClosedRange<CGFloat>
//
//    Whether the Ticks are ascending or descending in value, within the positional boudaries
//    - direction: Direction
//
//    The value per segment. This would be the value scale of the tape masure
//    - segmentValue: Double
//
//    The "physical" length of a single segment. This would be the visual scale of the tape measure
//    - segmentDistance: CGFloat
//
//    Pretty obvious. A value of 1 would indicated each segment is a single full tick,
//    greater than one subdivides the segment into that many ticks
//    - ticksPerSegment: Int
//
//    This optional paramenter clips a tape measure by value, *NOT* position.
//    For instance, in a scrolling tape meausre, if you didn't want any ticks below a value of 0, but also don't want
//    to set any upper value bound, you would pass in a closed range of 0.0...Double.greatestFiniteMagnitude
//    - valueClippingBounds: ClosedRange<Double>? = nil
//
// Once the class is instantiated, when passed a given position and value on the TapeMeasure,
// it will pass back a series of Ticks within the given positional boundaries, with all ticks positioned to scale.
// Each Tick has a relative position within the positional boundaries, the value for that Tick, and an index.
//
// - A Tick index of 0 represents a segment
// - A Tick index greater than 0 represents a subdivision of a full segment, and is useful for rendering Ticks in a view
//      (e.g. for 4-tick segments, render text labels at index 0, long tick marks at 2, and short tick marks at 1 & 3)
//

public class TapeMeasure {
    
    
    // MARK: public parameters, exposed for mutation
    
    public var positionBounds: ClosedRange<CGFloat>
    public var segmentValue: Double
    public var segmentLength: CGFloat
    public var ticksPerSegment: Int
    public var direction: Direction
    public var valueClippingBounds: ClosedRange<Double>?
    public var valueOriginOffset: Double
    
    // Special property for dealing with precision issues
    // when determining if ticks line up perfectly with origin
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
        segmentValue: Double,
        segmentLength: CGFloat,
        ticksPerSegment: Int,
        direction: Direction,
        valueClippingBounds: ClosedRange<Double>? = nil,
        valueOriginOffset: Double = 0.0
    ) {
        self.positionBounds = positionBounds
        self.segmentValue = abs(segmentValue)
        self.segmentLength = abs(segmentLength)
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
            forAnchorValue anchorValue: Double,
            atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let distanceOfAnchorFromOrigin = rawPosition(forValue: anchorValue)
        let distanceOfOriginOffsetByValue = rawPosition(forValue: valueOriginOffset)
        return anchorPosition - distanceOfAnchorFromOrigin + distanceOfOriginOffsetByValue
    }
    
    // remember, the origin itself may not be at position 0.0, due to a value-based offset of the origin from value 0.0
    public func distanceToOrigin(
        fromPosition positionToCheck: CGFloat,
        forAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let originPosition = originPosition(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return positionToCheck - originPosition
    }
    
    public func position(
        forValue valueToCheck: Double,
        forAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> CGFloat {
        let rawPositionForValue = rawPosition(forValue: valueToCheck)
        let originPosition = originPosition(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return originPosition + rawPositionForValue
    }
    
    public func value(
        atPosition positionToCheck: CGFloat,
        forAnchorValue anchorValue: Double,
        atAnchorPosition anchorPosition: CGFloat
    ) -> Double {
        let originOffset = distanceToOrigin(fromPosition: positionToCheck, forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        return rawValue(atPosition: originOffset)
    }
    
    
    
    
    public func ticks(forAnchorValue anchorValue: Double, atAnchorPosition anchorPosition: CGFloat) -> [Tick] {
        
        // First, find the first tick's position
        var firstTickPosition = startPosition
        var originOffset: CGFloat = distanceToOrigin(fromPosition: startPosition, forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        
        // If there's a lower value clipping bound, adjust as necessary
        if let valueLowerBound = valueClippingBounds?.lowerBound {
            let valueLowerBoundPosition = position(forValue: valueLowerBound, forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
            if valueLowerBoundPosition > startPosition {
                originOffset = distanceToOrigin(fromPosition: valueLowerBoundPosition, forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
                firstTickPosition = valueLowerBoundPosition
            }
        }
 
        // Next, populate the first tick with all other initial tick date (value and index).
        // These will be iterated upon during tick generation
        var tickIndex = Int(originOffset / tickDistance)
        var tickValue = (Double(tickIndex) * valuePerTick) + valueOriginOffset
        
        // Find the offset of the first tick, in case the ticks are NOT aligned with the origin
        // (A firstTickRemainder value of 0.0 would indicate there's no offset, so the ticks ARE aligned)
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
            let valueUpperBoundPosition = position(forValue: valueUpperBound, forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
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
                print("[\(segmentTickIndex)] \(position.roundToDecimal(2)) ------------ \"\(value)\"")
            }
            else {
                print("[\(segmentTickIndex)] \(position.roundToDecimal(2)) -- \"\(value)\"")
            }
        }
        
    }
    
    
    // @TODO: not yet implemented
    public enum Direction {
        case ascending
        case descending
    }
    
}
