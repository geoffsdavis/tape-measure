# TapeMeasure

**TapeMeasure** is a convenience class, written in Swift, for creating a data model to render a visual tape measure, or any other graphical elements that need to be laid out along an axis. It can dynamically re-generate that data, so that the tape measure can scrolled and/or scaled on the fly, due to animation or user interaction. 

The class that takes a few basic parameters, and can dynamically return an array that represents the ticks of a tape measure, as well as other useful information. The class itself is stateless except for those parameters, and is independent of any UI frameworks. It can be used with **SwiftUI**, **UIKit**, **CoreAnimation**, **SpriteKit**, **SceneKit**, or any other graphics framework for MacOS or iOS.

## Key Concepts

* **Position** - A given "physical" (graphical) position on the tape measure. For instance, on a thermometer, the position for boiling water might at 300 graphical points from the position of the thermometer's origin

* **Value** - The actual value of measurement at a given position. For instance, on a thermometer, the value at the position for boiling water would be 100ºC (212ºF)

* **Origin** - The position, in graphical points, where the **value** is 0.0. Segment borders always align with this position.

* **Segment** - A span covering a single subdivision. On a real-world tape measure, a segment might define a distance of 1 cm, or maybe 1 inch.

* **Tick** - An optional subdivision of a segment.

* **Tick Index** - The index of ticks within a segment (i.e. segment subdivisions). An index of 0 is at the segment's own "starting boundary"

## Parameters

TapeMeasure takes some initial parameters on instantiation, all of which can be mutated at any time.

The positional boundaries in which TapeMeasure Ticks will be generated. Ticks will only have positions within these boundaries. For convenience, pass in the boundaries which match the layout in the intended view. The returned Tick positions will match nicely.
* `positionBounds: ClosedRange<CGFloat>`

Enum describing whether the Ticks are `.ascending` or `.descending` in value, within the supplied `positionBounds`
* `direction: Direction`

The value per segment. This would be the value scale of the tape measure.
* `segmentValue: Double`

The "physical" length of a single segment, in graphical points. This would be the visual scale of the tape measure
* `segmentDistance: CGFloat`

A value of 1 would indicated each segment is defined by a single tick, whereas greater than 1 would indicate a segment sub-divided into that many ticks
* `ticksPerSegment: Int`

This optional parameter clips a tape measure by value, **NOT** position. For instance, in a scrolling tape measure, if you don't want any ticks rendered below a value of 0.0, but also don't want to set any upper value bound, you would pass in a closed range of `0.0...Double.greatestFiniteMagnitude`
* `valueClippingBounds: ClosedRange<Double>? = nil`

## Output

Once the class is instantiated, when passed a given position and value on the TapeMeasure, it will pass back an array of Ticks within the given positional boundaries, with all ticks positioned to scale. Each Tick has a relative position within the positional boundaries, the value for that Tick, and an index.

```
let position: CGFloat // position of the Tick, in graphical points
let value: Double // value of the Tick. Usually used for text labels
let segmentTickIndex: Int // zero-based index for determining which (if any) sub-division boundary this tick represents
```

 - A Tick Index of 0 represents a segment boundary
 - A Tick Index greater than 0 represents a subdivision boundary of a full segment, and is useful for rendering Ticks in a view
      (e.g. for 4-tick segments, you could render text labels at index 0, long tick marks at 2, and short tick marks at 1 & 3)
      
## Example: Let's Make a Thermometer

First, we'll create a 
