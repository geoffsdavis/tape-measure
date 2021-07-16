//
//  TapeMeasureTests.swift
//  TapeMeasureTests
//
//  Created by Geoff Davis on 7/14/21.
//

import XCTest
@testable import TapeMeasure

public class TapeMeasureTests: XCTestCase {
    
    private let floatAccuracy: CGFloat = 0.001
    private let doubleAccuracy = 0.001

    public func test_asc_pos_1() {
                
        let tapeMeasure = TapeMeasure(
            positionBounds: 0.0...300.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending
        )
        
        var ticks = [TapeMeasure.Tick]()
        var midTick = TapeMeasure.Tick(position: 0.0, value: 0.0, segmentTickIndex: 0)
        
        // MARK: 50.0 @ 150.0
        
        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: 150.0)
        XCTAssertEqual(ticks.count, 21)

        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 2)
            XCTAssertEqual(firstTick.position, 0.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 43.75, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 2)
            XCTAssertEqual(lastTick.position, 300.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 56.25, accuracy: doubleAccuracy)
        }
        midTick = ticks[10]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 150.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 50.0, accuracy: doubleAccuracy)
        
        
        // MARK: 50.0 @ 149.9
        
        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: 149.9)
        XCTAssertEqual(ticks.count, 20)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 3)
            XCTAssertEqual(firstTick.position, 14.9, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 44.375, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 2)
            XCTAssertEqual(lastTick.position, 299.9, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 56.25, accuracy: doubleAccuracy)
        }
        midTick = ticks[9]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 149.9, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 50.0, accuracy: doubleAccuracy)

        
        // MARK: 50.0 @ 151.1
        
        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: 150.1)
        XCTAssertEqual(ticks.count, 20)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 2)
            XCTAssertEqual(firstTick.position, 0.1, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 43.75, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 285.1, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 55.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[10]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 150.1, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 50.0, accuracy: doubleAccuracy)
        
    }
    
    public func test_asc_pos_2() {
                
        let tapeMeasure = TapeMeasure(
            positionBounds: -100.0...200.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending
        )
        
        var ticks = [TapeMeasure.Tick]()
        var midTick = TapeMeasure.Tick(position: 0.0, value: 0.0, segmentTickIndex: 0)
        
        
        // MARK: 50.0 @ 150.0
        
        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: 150.0)
        XCTAssertEqual(ticks.count, 20)

        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, -90.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 40.0, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 3)
            XCTAssertEqual(lastTick.position, 195.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 51.875, accuracy: doubleAccuracy)
        }
        midTick = ticks[16]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 150.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 50.0, accuracy: doubleAccuracy)
        
        
        // MARK: 50.0 @ 150.0
        
        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: -25.0)
        XCTAssertEqual(ticks.count, 21)

        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 3)
            XCTAssertEqual(firstTick.position, -100.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 46.875, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 3)
            XCTAssertEqual(lastTick.position, 200.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 59.375, accuracy: doubleAccuracy)
        }
        midTick = ticks[5]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, -25.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 50.0, accuracy: doubleAccuracy)
        
    }
    
    
    public func test_asc_neg_1() {
        
        let tapeMeasure = TapeMeasure(
            positionBounds: 0.0...200.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending
        )
        
        var ticks = [TapeMeasure.Tick]()
        var midTick = TapeMeasure.Tick(position: 0.0, value: 0.0, segmentTickIndex: 0)
        
        
        // MARK: 5.0 @ 180.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 180.0)
        XCTAssertEqual(ticks.count, 14)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 0.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, -2.5, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 195.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[12]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 180.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
        
        // MARK: 5.0 @ 179.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 179.0)
        XCTAssertEqual(ticks.count, 13)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 1)
            XCTAssertEqual(firstTick.position, 14.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, -1.875, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 194.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[11]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 179.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
        
        // MARK: 5.0 @ 181.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 181.0)
        XCTAssertEqual(ticks.count, 14)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 1.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, -2.5, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 196.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[12]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 181.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
    }
    
    
    
    public func test_asc_neg_clipping_1() {
        
        let tapeMeasure = TapeMeasure(
            positionBounds: 0.0...200.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: 0.0...Double.greatestFiniteMagnitude
        )
        
        var ticks = [TapeMeasure.Tick]()
        var midTick = TapeMeasure.Tick(position: 0.0, value: 0.0, segmentTickIndex: 0)
        
        
        // MARK: 5.0 @ 180.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 180.0)
        XCTAssertEqual(ticks.count, 10)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 60.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 0.0, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 195.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[8]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 180.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
        
        // MARK: 5.0 @ 179.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 179.0)
        XCTAssertEqual(ticks.count, 10)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 59.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 0.0, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 194.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[8]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 179.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
        
        // MARK: 5.0 @ 181.0
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 181.0)
        XCTAssertEqual(ticks.count, 10)
        
        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 61.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, 0.0, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 1)
            XCTAssertEqual(lastTick.position, 196.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 5.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[8]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 181.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.0, accuracy: doubleAccuracy)
        
    }
    

    public func test_asc_pos_with_value_offset_1() {
                
        let tapeMeasure = TapeMeasure(
            positionBounds: 0.0...300.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: nil,
            valueOriginOffset: 0.25
        )
        
        var ticks = [TapeMeasure.Tick]()
        var midTick = TapeMeasure.Tick(position: 0.0, value: 0.0, segmentTickIndex: 0)
        
        // MARK: 5.0 @ 180.0 w/ 0.25 value offset
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 180.0)
        XCTAssertEqual(ticks.count, 20)

        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 0)
            XCTAssertEqual(firstTick.position, 6.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, -2.25, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 3)
            XCTAssertEqual(lastTick.position, 291.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 9.625, accuracy: doubleAccuracy)
        }
        midTick = ticks[12]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 186.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 5.25, accuracy: doubleAccuracy)
                

        
        // MARK: 5.0 @ 180.0 w/ -0.25 value offset
        
        tapeMeasure.valueOriginOffset = -0.25
        
        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 180.0)
        XCTAssertEqual(ticks.count, 20)

        if let firstTick = ticks.first {
            XCTAssertEqual(firstTick.segmentTickIndex, 1)
            XCTAssertEqual(firstTick.position, 9.0, accuracy: floatAccuracy)
            XCTAssertEqual(firstTick.value, -2.125, accuracy: doubleAccuracy)
        }
        if let lastTick = ticks.last {
            XCTAssertEqual(lastTick.segmentTickIndex, 0)
            XCTAssertEqual(lastTick.position, 294.0, accuracy: floatAccuracy)
            XCTAssertEqual(lastTick.value, 9.75, accuracy: doubleAccuracy)
        }
        midTick = ticks[11]
        XCTAssertEqual(midTick.segmentTickIndex, 0)
        XCTAssertEqual(midTick.position, 174.0, accuracy: floatAccuracy)
        XCTAssertEqual(midTick.value, 4.75, accuracy: doubleAccuracy)
        
        
    }
    
    
}


public class TestObserver: NSObject, XCTestObservation {
    public func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}
