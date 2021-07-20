//
//  AppDelegate.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 7/14/21.
//

import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func loopPrintTicks(_ ticks: [TapeMeasure.Tick], forTapeMeasure tapeMeasure: TapeMeasure) {
        print("===== \(tapeMeasure.startPosition) ===============")
        for tick in ticks {
            tick.report()
            //break
        }
        print("===== \(tapeMeasure.endPosition) ===============")
    }
    
    
    // MARK: - Main
    
    func applicationDidBecomeActive(_ notification: Notification) {
        
        let tapeMeasure = TapeMeasure(
            positionBounds: 0.0...300.0,
            segmentValue: 2.5,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: nil,
            //valueClippingBounds: 0.0...Double.greatestFiniteMagnitude,
            valueOriginOffset: 0.0
        )

        var ticks = [TapeMeasure.Tick]()

//        ticks = tapeMeasure.ticks(forValue: 50.0, atPosition: 149.9)
//        loopPrintTicks(ticks, forTapeMeasure: tapeMeasure)
        
        //tapeMeasure.positionBounds = 0.0...300.0
        
//        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 179.0)
//        loopPrintTicks(ticks, forTapeMeasure: tapeMeasure)
        
        let anchorValue: Double = -5.0
        let anchorPosition: CGFloat = -180.0
        
        ticks = tapeMeasure.ticks(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
        loopPrintTicks(ticks, forTapeMeasure: tapeMeasure)
        
//        ticks = tapeMeasure.ticks(forValue: 5.0, atPosition: 181.0)
//        loopPrintTicks(ticks, forTapeMeasure: tapeMeasure)
        
    }
    

}
