//
//  StageContainerView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import SwiftUI


struct StageContainerView: NSViewRepresentable {
    
    
    typealias NSViewType = NSView
            
        
    func makeNSView(context: Context) -> NSView {
        
        let frame = NSRect(origin: .zero, size: AppDelegate.Constants.appSize)
        let view = AmpView(frame: frame)
        return view

    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // do nothing
    }
    
}
