//
//  TapeMeasureApp.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 7/14/21.
//

import SwiftUI

@main
struct TapeMeasureApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let screenSize = CGSize(width: 1280.0, height: 720.0)

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: screenSize.width, height: screenSize.height, alignment: .center)
        }
    }
    
}
