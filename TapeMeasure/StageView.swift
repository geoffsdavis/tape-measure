//
//  StageView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import AppKit


class StageView: NSView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)
        layer = CALayer()
        renderArt()
        renderTicks()
    }
    
    private func renderArt() {
                
 
//        let path = XPBezierPath()
//        path.move(to: CGPoint(x: 50, y: 200))
//        path.curve(to: CGPoint(x: 200, y: 200),
//                      controlPoint1: CGPoint(x: 80, y: 300),
//                      controlPoint2: CGPoint(x: 150, y: 0))
//
//
//
//        //Shape Part
//        let shape = CAShapeLayer()
//        shape.path = path.cgPath
//        shape.lineWidth = 4.0
//        shape.fillColor = NSColor.clear.cgColor
//        shape.strokeColor = NSColor.orange.cgColor
//        rootLayer.addSublayer(shape)
        
        let thermometerTip = CAShapeLayer()
        thermometerTip.path = XPBezierPath(
            roundedRect: NSRect(
                origin: CGPoint(x: bounds.size.width / 2.0 - 380.0, y: frame.size.height / 2.0 - 6.0),
                size: CGSize(width: 100.0, height: 12.0)
            ),
            cornerRadius: 8.0
        ).cgPath
        thermometerTip.fillColor = NSColor.darkGray.cgColor
        layer?.addSublayer(thermometerTip)
        
        
        let thermometerBody = CAShapeLayer()
        thermometerBody.path = XPBezierPath(
            roundedRect: NSRect(
                origin: CGPoint(x: bounds.size.width / 2.0 - 320.0, y: frame.size.height / 2.0 - 10.0),
                size: CGSize(width: 640.0, height: 20.0)
            ),
            cornerRadius: 10.0
        ).cgPath
        thermometerBody.fillColor = NSColor.lightGray.cgColor
        layer?.addSublayer(thermometerBody)
        
        
        let thermometerFill = CAShapeLayer()
        thermometerFill.path = XPBezierPath(
            rect: NSRect(
                origin: CGPoint(x: bounds.size.width / 2.0 - 270.0 - 20.0, y: frame.size.height / 2.0 - 6.0),
                size: CGSize(width: 40.0, height: 12.0)
            )
        ).cgPath
        thermometerFill.fillColor = NSColor.red.cgColor
        layer?.addSublayer(thermometerFill)


    }
    
    
    private func renderTicks() {
        
        let tapeMeasure = TapeMeasure(
            positionBounds: -280.0...280.0,
            segmentValue: 36.0,
            segmentLength: 100.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: 32.0...212.0,
            valueOriginOffset: -4.0
        )
        
        let ticks = tapeMeasure.ticks(forAnchorValue: 32.0, atAnchorPosition: tapeMeasure.startPosition)
        
        let baseline = frame.size.height / 2.0 + 20.0
        let center = frame.size.width / 2.0
        
        let ticksLayer = CAShapeLayer()
        
        let path = XPBezierPath()
        
        var lineHeight = CGFloat.zero
        
        for tick in ticks {
            tick.report()
            switch tick.segmentTickIndex {
            case 0:
                lineHeight = 20.0
                let textView = NSTextView(frame: NSRect(origin: CGPoint(x: center + tick.position - 30.0, y: baseline + lineHeight + 4.0), size: CGSize(width: 60.0, height: 20.0)))
                textView.font = NSFont.systemFont(ofSize: 14)
                textView.alignment = .center
                textView.textColor = .white
                textView.backgroundColor = .black
                textView.string = String(tick.value) + "º"
                addSubview(textView)
            case 2:
                lineHeight = 10.0
            default:
                lineHeight = 5.0
            }
            path.move(to: CGPoint(x: center + tick.position, y: baseline + lineHeight))
            path.line(to: CGPoint(x: center + tick.position, y: baseline))

        }
        
        ticksLayer.path = path.cgPath
        ticksLayer.lineWidth = 2.0
        ticksLayer.strokeColor = NSColor.white.cgColor
        
        layer?.addSublayer(ticksLayer)

        
    }
    
}
