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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    width: AppDelegate.Constants.appSize.width,
                    height: AppDelegate.Constants.appSize.height,
                    alignment: .center
                )
        }
    }
    
}
