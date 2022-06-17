//
//  StageView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import AppKit


class StageView: NSView {
    
    var xCenter: CGFloat {
        frame.size.width / 2.0
    }
    
    var yCenter: CGFloat {
        frame.size.height / 2.0
    }
    
    var mercuryLayer: CAShapeLayer = CAShapeLayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)
        print("frame: \(frame)")
        layer = CALayer()
        layer?.addSublayer(mercuryLayer)

        renderThermometer()
        renderMercury(toPosition: -240.0)
        createTicks()
        renderMarkers()
    }
    
    private func renderMarkers() {
        let yOffset: CGFloat = -57.0
        let leftText = createMarkerText(value: -300.0, origin: CGPoint(x: xCenter - 300.0, y: yCenter + yOffset))
        addSubview(leftText)
        let centerText = createMarkerText(value: 0.0, origin: CGPoint(x: xCenter, y: yCenter + yOffset))
        addSubview(centerText)
        let rightText = createMarkerText(value: 300.0, origin: CGPoint(x: xCenter + 300.0, y: yCenter + yOffset))
        addSubview(rightText)
        
        let tickOffset: CGFloat = -36.0
        let tickHeight: CGFloat = 10.0
        
        let ticksLayer = CAShapeLayer()
        let path = XPBezierPath()
        
        path.move(to: CGPoint(x: xCenter - 300.0, y: yCenter + tickOffset))
        path.line(to: CGPoint(x: xCenter - 300.0, y: yCenter + tickOffset + tickHeight))
        path.move(to: CGPoint(x: xCenter, y: yCenter + tickOffset))
        path.line(to: CGPoint(x: xCenter, y: yCenter + tickOffset + tickHeight))
        path.move(to: CGPoint(x: xCenter + 300.0, y: yCenter + tickOffset))
        path.line(to: CGPoint(x: xCenter + 300.0, y: yCenter + tickOffset + tickHeight))

        ticksLayer.path = path.cgPath
        ticksLayer.lineWidth = 2.0
        ticksLayer.strokeColor = NSColor.green.cgColor
        
        layer?.addSublayer(ticksLayer)
    }
    
    private func renderThermometer() {

        let thermometerTip = CAShapeLayer()
        thermometerTip.path = XPBezierPath(
            roundedRect: NSRect(
                origin: CGPoint(x: xCenter - 300.0 - 80.0, y: yCenter - 16.0),
                size: CGSize(width: 100.0, height: 12.0)
            ),
            cornerRadius: 8.0
        ).cgPath
        thermometerTip.fillColor = NSColor.darkGray.cgColor
        layer?.addSublayer(thermometerTip)
        
        
        let thermometerBody = CAShapeLayer()
        thermometerBody.path = XPBezierPath(
            roundedRect: NSRect(
                origin: CGPoint(x: xCenter - 320.0, y: yCenter - 20.0),
                size: CGSize(width: 640.0, height: 20.0)
            ),
            cornerRadius: 10.0
        ).cgPath
        thermometerBody.fillColor = NSColor.lightGray.cgColor
        layer?.addSublayer(thermometerBody)
        
    }
    
    private func renderMercury(toPosition position: Double) {
        
        mercuryLayer.removeFromSuperlayer()
        mercuryLayer = CAShapeLayer()
        mercuryLayer.path = XPBezierPath(
            rect: NSRect(
                origin: CGPoint(x: xCenter - 300.0, y: yCenter - 16.0),
                size: CGSize(width: position + 300, height: 12.0)
            )
        ).cgPath
        mercuryLayer.fillColor = NSColor.red.cgColor
        if let layer = layer, let sublayers = layer.sublayers {
            layer.insertSublayer(mercuryLayer, at: UInt32(sublayers.count))
        }

    }

    
    private func createTicks() {
        
        // 1
        var tapeMeasure = TapeMeasure(
            positionBounds: -300...300.0,
            segmentValue: 10.0,
            segmentLength: 60.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: nil,
            valueOriginOffset: 0.0
        )

        var anchorValue: CGFloat = 0.0
        var anchorPosition = tapeMeasure.startPosition

        // 2
        tapeMeasure.segmentValue = 36.0
                
        // 3
        tapeMeasure.valueOriginOffset = -4.0

        // 4
        tapeMeasure.valueClippingBounds = 32...212.0

        // 5
        anchorValue = 32.0

        // 6
        tapeMeasure.positionBounds = -260.0...260.0

        // 7
        anchorPosition = tapeMeasure.startPosition

        // 8
        tapeMeasure.segmentLength = 100.0

        // 9
        tapeMeasure = TapeMeasure(
            positionBounds: -300...300.0,
            segmentValue: 2.0,
            segmentLength: 80.0,
            ticksPerSegment: 4,
            direction: .ascending,
            valueClippingBounds: 94.0...106.0,
            valueOriginOffset: 0.0
        )
        anchorValue = 100.0
        anchorPosition = 0.0
                
        let ticks = tapeMeasure.ticks(forAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
                
        renderTicks(ticks: ticks)

                
        // 10
//        let normalTemp: Double = 98.6
//        let normalPosition = tapeMeasure.position(forValue: normalTemp, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)
//
//        renderMercury(toPosition: normalPosition)
//
//        let indicator = renderIndicator(value: normalTemp, position: normalPosition)
//        addSubview(indicator)
                
        // 11
        let feverPosition: CGFloat = 152.0
        let feverValue = tapeMeasure.value(atPosition: feverPosition, withAnchorValue: anchorValue, atAnchorPosition: anchorPosition)

        renderMercury(toPosition: feverPosition)

        let indicator = renderIndicator(value: feverValue, position: feverPosition)
        addSubview(indicator)
        
    }
        
        
    private func renderTicks(ticks: [TapeMeasure.Tick]) {
        
        let baseline = yCenter + 2.0
        let center = xCenter
        
        let ticksLayer = CAShapeLayer()
        
        let path = XPBezierPath()
        
        var lineHeight = CGFloat.zero
        
        for tick in ticks {
            //tick.report()
            switch tick.segmentTickIndex {
            case 0:
                lineHeight = 20.0
                let textView = NSTextView(
                    frame: NSRect(
                        origin: CGPoint(
                            x: center + tick.position - 30.0,
                            y: baseline + lineHeight + 4.0
                        ),
                        size: CGSize(
                            width: 60.0,
                            height: 20.0
                        )
                    )
                )
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
        
    private func createMarkerText(value: Double, origin: CGPoint) -> NSTextView {
        let textView = NSTextView(
            frame: NSRect(
                origin: CGPoint(x: origin.x - 40.0, y: origin.y),
                size: CGSize(
                    width: 80.0,
                    height: 20.0
                )
            )
        )
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.alignment = .center
        textView.textColor = .green
        textView.backgroundColor = .black
        textView.string = String(Int(value)) + "pt"
        return textView
    }
    
    private func renderIndicator(value: Double, position: CGFloat) -> NSView {
        var origin = CGPoint(x: xCenter, y: yCenter)
        origin.x += position

        let indicatorView = NSView()
        indicatorView.layer = CALayer()
        indicatorView.frame = NSRect(
            origin: CGPoint(x: origin.x - 40.0, y: origin.y + 8.0),
            size: CGSize(
                width: 80.0,
                height: 50.0
            )
        )
        
        let textView = NSTextView(
            frame: NSRect(
                origin: CGPoint(x: 0.0, y: 12.0),
                size: CGSize(
                    width: 80.0,
                    height: 30.0
                )
            )
        )
        textView.font = NSFont.systemFont(ofSize: 20)
        textView.alignment = .center
        textView.textColor = .yellow
        textView.backgroundColor = .clear
        textView.string = String(value.roundToDecimal(1)) + "º"
        
        indicatorView.addSubview(textView)
        
        let indicatorBackground = CAShapeLayer()
        indicatorBackground.path = XPBezierPath(
            roundedRect: NSRect(
                origin: CGPoint(x: 6.0, y: 16.0),
                size: CGSize(width: 80.0 - 12.0, height: 40.0 - 12.0)
            ),
            cornerRadius: 6.0
        ).cgPath
        indicatorBackground.lineWidth = 2.0
        indicatorBackground.strokeColor = NSColor.yellow.cgColor
        indicatorBackground.fillColor = NSColor.black.cgColor

        indicatorView.layer?.addSublayer(indicatorBackground)
        
        let arrow = CAShapeLayer()
        let path = XPBezierPath()
        
        path.move(to: CGPoint(x: 40.0, y: 0.0))
        path.line(to: CGPoint(x: 40.0 - 10.0, y: 15.0))
        path.line(to: CGPoint(x: 40.0 + 10.0, y: 15.0))
        path.line(to: CGPoint(x: 40.0, y: 0.0))
        arrow.path = path.cgPath
        
        arrow.fillColor = NSColor.yellow.cgColor
        
        indicatorView.layer?.addSublayer(arrow)
        
        return indicatorView
    }
    
}
