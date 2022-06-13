//
//  StageView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import SwiftUI


struct StageContainerView: NSViewRepresentable {
    
    
    typealias NSViewType = NSView
            
        
    func makeNSView(context: Context) -> NSView {
        
        let frame = NSRect(origin: .zero, size: CGSize(width: 1280.0, height: 720.0))
        let view = StageView(frame: frame)
        return view

    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // do nothing
    }
    
}
