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
        // do nothing
    }
    

}
