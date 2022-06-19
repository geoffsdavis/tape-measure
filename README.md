# TapeMeasure

**TapeMeasure** is a convenience class, written in Swift, that acts as a view model for rendering a visual tape measure, or any other graphical elements that need to be laid out along an axis. It can dynamically re-generate that data, so that the tape measure can scrolled and/or scaled on the fly, due to animation or user interaction. 

<table>
  <tr>
    <td>Examples</td>
  </tr>
  <tr>
    <td><img src="images/iv_measure.png"></td>
    <td><img src="images/tape_measure_9.png"</td>
    <td><img src="images/time_decay_measure.png"></td>
  </tr>
</table>

The class that takes a few basic parameters, and can dynamically return an array that represents the ticks of a tape measure, as well as other useful information. The class itself is stateless except for those parameters, and is independent of any graphics frameworks. It can be used with **SwiftUI**, **UIKit**, **CoreAnimation**, **SpriteKit**, **SceneKit**, or any other graphics framework for MacOS or iOS.

## Key Concepts

* **Position** - A given "physical" (graphical) position on the tape measure. For instance, on a thermometer, the position for boiling water might at 300 graphical points from the position of the thermometer's origin

* **Value** - The actual value of measurement at a given position. For instance, on a thermometer, the value at the position for boiling water would be 100ºC (212ºF)

* **Origin** - The position, in graphical points, where the **value** is 0.0. By default, segment borders always align with this position.

* **Segment** - A span covering a single subdivision. On a real-world tape measure, a segment might define a distance of 1 cm, or maybe 1 inch.

* **Tick** - Demarcations that define segments, as well as any subdivisions of segments. Put another way, a segment can be defined by one or more ticks.

* **Tick Index** - The index of ticks that defines a segment's staring boundary, as well as any segment subdivision boundaries. An index of 0 represents the segment's own starting boundary. Indices of greater than 0 represent the segment's subdivision staring boundaries.

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

This optional parameter clips a tape measure by value, **NOT** position. For instance, in a scrolling tape measure, if you don't want any ticks rendered below a **value** of 0.0, but also don't want to set any upper value bound, you would pass in a closed range of `0.0...Double.greatestFiniteMagnitude`. This is nil by default, to indicate no value clipping bounds.
* `valueClippingBounds: ClosedRange<Double>? = nil`

An offset by **position** (graphical points) of the **origin** (location representing the **value** of 0.0), from the **position** of 0.0 pts. This might be useful to stagger the ticks so they don't neatly line up with segments, which span a graphical distance but define units of **value**. We'll see an example below. This is zero by default, to indicate no offset, so that the **value** of 0.0 would be at the **position** of 0.0 pts.
* `valueOriginOffset: Double = 0.0`

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

### Step #0: Create a basic thermometer

We create a simple Mac app, and render some primitive line art to draw a thermometer. The thermometer has a resolution-independent width of 600pt, extending from -300 across the center at 0 to 300 on the other end.

> **Note**
> Here we are using AppKit's NSView and CoreAnimation's CALayer, but you could use any graphics framework of your choice, on your Apple platform(s) of choice.

![image](/images/tape_measure_0.png)
---
### Step #1: Let's add some ticks

```
let tapeMeasure = TapeMeasure(
    positionBounds: -300...300.0,
    segmentValue: 10.0,
    segmentLength: 60.0,
    ticksPerSegment: 4,
    direction: .ascending,
    valueClippingBounds: nil,
    valueOriginOffset: 0.0
)
```

We want this thermometer to be in Celsius, and go from 0ºC - 100ºC (freezing point of water to boiling point). We gave the positional bounds from one end of the thermometer to the other (`-300.0...300.0`). We defined segments as having a value of 10ºC, and if we do the math, that'll be 60pt distance per segment. We subdivide each segment into 4 ticks. The ticks will ascend in value, with no clipping by value bounds, and no offset of the origin.

Okay, let's generate the data for the ticks:

```
var anchorValue: CGFloat = 0.0
var anchorPosition = tapeMeasure.startPosition
        
// For all the changes listed below, we're going call this func every time for new ticks. 
// We'll show it here the first time.
var ticks = tapeMeasure.ticks(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)

// Now iterate through the 'ticks' array with your graphical framework...
```

We establish an anchor value of 0ºC, at the starting position we already established. (-300pt). Then we call for the array of Tick structs, which we iterate over to add the text labels and artwork.

![image](/images/tape_measure_1.png)
---
### Step #2: Let's make life difficult and switch to Fahrenheit

As part of the metric system, Celsius makes too much sense. Let's switch to Fahrenheit, based on the British Imperial system of measurements, which even the British had the good sense to abandon. With Fahrenheit, water freezes at 32ºF, and boils at 212ºF. Since Fahrenheit degrees are smaller, we'll need to increase the value (number of degrees) packed into segments. 

If we do some math, there's 180º between the freezing and boiling temperature. Let's chop that up into 5 segments, which would be 36º each. We'll change the value of each segment to 36ºF.

```
tapeMeasure.segmentValue = 36.0

// The last time this func call is shown, but you'll need to do it for every change in the steps below.
var ticks = tapeMeasure.ticks(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)

// And redraw the ticks..
```

![image](/images/tape_measure_2.png)
---
### Step #3: Ohhh, we'll need a value offset

The degrees have scaled nicely, but we need to put in an offset to make the segment ticks line up perfectly with 32º and 212º. Since the nearest tick to 32º is 36º, let's set a value offset of -4 to nudge everything over.

```
tapeMeasure.valueOriginOffset = -4.0
```

![image](/images/tape_measure_3.png)
---
### Step #4: Let's get rid of the extra degrees

Now we have ticks at both 32º and 212º, but also extra degrees to both the left and right. Let's clip the values.

```
tapeMeasure.valueClippingBounds = 32...212.0
```

![image](/images/tape_measure_4.png)
---
### Step #5: And move the freezing point to the left end

Let's move 32º to the left positional boundary.

```
anchorValue = 32.0 // New value. The old one was 0.0, for Celsius.
```

![image](/images/tape_measure_5.png)
---
### Step #6: Hmmmm, let's move the positional boundaries inward for visual padding

```
tapeMeasure.positionBounds = -260.0...260.0
```

![image](/images/tape_measure_6.png)
---
### Step #7: Oops, we'll need to update the anchor position 

```
anchorPosition = tapeMeasure.startPosition // updating to new value
```

![image](/images/tape_measure_7.png)
---
### Step #8: Let's stretch things out to fill up the space

```
tapeMeasure.segmentLength = 100.0
```

![image](/images/tape_measure_8.png)
---
### Step #9: Okay, now we'll just create a new thermometer from scratch, for human temperatures

Here, we'll just set all the parameters properly on initialization. By now, you should be able to see what's going on.

```
let tapeMeasure = TapeMeasure(
    positionBounds: -300...300.0,
    segmentValue: 2.0,
    segmentLength: 80.0,
    ticksPerSegment: 4,
    direction: .ascending,
    valueClippingBounds: 94.0...106.0,
    valueOriginOffset: 0.0
)
let anchorValue = 100.0
let anchorPosition = 0.0

var ticks = tapeMeasure.ticks(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
```

![image](/images/tape_measure_9.png)
---
### Step #10: Let's find the location of a "normal" temperature

Supposedly, the "normal" temperature of a human body is 98.6ºF. We'll need to locate its graphical location on our thermometer.

```
let normalTemp: Double = 98.6
let normalPosition = tapeMeasure.position(forValue: normalTemp, 
                                             withAnchorValue: anchorValue, 
                                             atAnchorPosition: anchorPosition
                                           )

print(normalPosition) // prints "-56.0"
```

![image](/images/tape_measure_10.png)
---
### Step #11: Guess what? I got a fever!

I just took my temperature, and the mercury has risen to a position of 152.0pt. Let's find out the temperature.

```
let feverPosition: CGFloat = 152.0
let feverValue = tapeMeasure.value(atPosition: feverPosition, 
                                        withAnchorValue: anchorValue, 
                                        atAnchorPosition: anchorPosition
                                      )

print(feverValue) // prints "103.8"
```

![image](/images/tape_measure_11.png)
