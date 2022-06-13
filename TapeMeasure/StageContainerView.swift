//
//  StageView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import SwiftUI


struct StageView: NSViewRepresentable {
    
    
    typealias NSViewType = NSView
            
        
    func makeNSView(context: Context) -> NSView {
        
        let view = NSView()
        
        return view

//        let sceneView = VSCOBallSceneView(frame: .zero, options: nil)
//
//        sceneView.scene = VSCOBallScene(controller: vscoBallController)
//        sceneView.backgroundColor = XPColor.black
//        sceneView.showsStatistics = false
//        //sceneView.debugOptions = [.renderAsWireframe]
//        sceneView.allowsCameraControl = VSCOBallController.allowCameraControl // default is false
//        sceneView.autoenablesDefaultLighting = true // default is false
//        sceneView.rendersContinuously = false // default is false
//        sceneView.isPlaying = false // default is false
//
//        return sceneView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // do nothing
    }
    
}
