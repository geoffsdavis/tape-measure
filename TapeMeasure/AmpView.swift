//
//  AmpView.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/19/22.
//

import Foundation
import AppKit


class AmpView: NSView {
    
    enum Constants {
        static let labels = ["BASS", "MIDDLE", "TREBLE", "VOLUME I"]
        static let settings = [7.2, 10.0, 5.1, 10.0]
        static let labelColor = NSColor.black // NSColor(red: 0.35, green: 0.2, blue: 0.05, alpha: 1.0)
        static let dialPositions = [-300.0, -100.0, 100.0, 300.0]
        static let dialRadius: CGFloat = 30.0
    }
    
    var xCenter: CGFloat {
        frame.size.width / 2.0
    }
    
    var yCenter: CGFloat {
        frame.size.height / 2.0
    }

    lazy var dialViews: [NSView] = {
        var views = [NSView]()
        for i in 0..<Constants.labels.count {
            views.append(NSView())
        }
        return views
    }()
    
    lazy var dialLabelViews: [NSView] = {
        var views = [NSView]()
        for i in 0..<Constants.labels.count {
            views.append(NSView())
        }
        return views
    }()

    let tapeMeasrue = TapeMeasure(positionBounds: -3.0...3.0,
                                  segmentLength: 0.45,
                                  segmentValue: 1,
                                  ticksPerSegment: 1,
                                  direction: .ascending,
                                  valueClippingBounds: 0.0...11.0
    )

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)

        layer = CALayer()
        layer?.backgroundColor = NSColor(red: 0.8, green: 0.7, blue: 0.2, alpha: 1.0).cgColor
        
        renderLabels()
        renderDials()
        renderTicks()

    }
    
    
    private func renderLabels() {
        
        for i in 0..<Constants.labels.count {
            let labelView = NSTextView(frame:
                NSRect(x: xCenter + Constants.dialPositions[i] - 50.0,
                       y: yCenter + 63.0,
                       width: 100.0,
                       height: 20.0
                )
            )
            labelView.font = NSFont.systemFont(ofSize: 18.0, weight: .semibold)
            labelView.alignment = .center
            labelView.textColor = Constants.labelColor
            labelView.backgroundColor = .clear
            labelView.string = Constants.labels[i]
            addSubview(labelView)
        }
        
    }
    
    
    
    
    
    private func renderDials() {
        
        for i in 0..<Constants.labels.count {
            let dialView = dialLabelViews[i]
            dialView.frame = NSRect(x: xCenter + Constants.dialPositions[i],
                                    y: yCenter - 20.0,
                                    width: 140.0,
                                    height: 140.0
            )
            addSubview(dialView)
            dialView.layer = CALayer()

            dialView.wantsLayer = true
            
            let newAnchorPoint = CGPoint(x: 0.5, y: 0.5)
            dialView.layer?.anchorPoint = newAnchorPoint
            
            //dialView.layer?.backgroundColor = NSColor.red.cgColor
            
            let dialBackground = CAShapeLayer()
            dialBackground.path = XPBezierPath(
                roundedRect: NSRect(
                    origin: CGPoint(x: -Constants.dialRadius, y: -Constants.dialRadius),
                    size: CGSize(width: Constants.dialRadius * 2.0, height: Constants.dialRadius * 2.0)
                ),
                cornerRadius: Constants.dialRadius
            ).cgPath
            dialBackground.strokeColor = NSColor.black.cgColor
            dialBackground.lineWidth = 3.0
            dialBackground.fillColor = NSColor.lightGray.cgColor
            dialBackground.anchorPoint = newAnchorPoint
            dialBackground.position = CGPoint(x: dialView.frame.width / 2.0, y: dialView.frame.height / 2.0)


            dialView.layer?.addSublayer(dialBackground)
            
            let dialMarker = CAShapeLayer()
            let dialPath = XPBezierPath()
            let value = Constants.settings[i]
            let position = tapeMeasrue.position(forValue: value, withAnchorValue: 5.5, atAnchorPosition: 0.0)
            let xPos = (sin(position) * Constants.dialRadius)
            let yPos = (cos(position) * Constants.dialRadius)
            dialPath.move(to: CGPoint(x: xPos, y: yPos))
            dialPath.line(to: CGPoint(x: 0.0, y: 0.0))
            dialMarker.path = dialPath.cgPath
            dialMarker.strokeColor = NSColor.black.cgColor
            dialMarker.lineWidth = 5.0
            dialMarker.anchorPoint = newAnchorPoint
            dialMarker.position = CGPoint(x: dialView.frame.width / 2.0, y: dialView.frame.height / 2.0)

            dialView.layer?.addSublayer(dialMarker)
            
        }
        
    }
    
    
    private func renderTicks() {
        
        let ticks = tapeMeasrue.ticks(forAnchorValue: 5.5, atAnchorPosition: 0.0)
        //print(ticks)
        
        for i in 0..<Constants.labels.count {
            let dialView = dialLabelViews[i]
            let tickLayer = CAShapeLayer()
            tickLayer.strokeColor = NSColor.black.cgColor
            tickLayer.lineWidth = 2.0
            let path = XPBezierPath()
            for tick in ticks {
                let xPos = (sin(tick.position) * 58.0) + (dialView.frame.width / 2.0)
                let yPos = (cos(tick.position) * 58.0)
                if tick.value.truncatingRemainder(dividingBy: 2) == 0 || Int(tick.value) == 11 {
                    let labelView = NSTextView(frame:
                        NSRect(x: xPos - 60.0,
                               y: yPos - 40.0 + 38.0,
                               width: 120.0,
                               height: 80.0
                        )
                    )
                    labelView.font = NSFont.systemFont(ofSize: 18.0, weight: .bold)
                    labelView.alignment = .center
                    labelView.textColor = Constants.labelColor
                    labelView.backgroundColor = .clear
                    labelView.string = String(Int(tick.value))
                    dialView.addSubview(labelView)
                }
                else {
                    let xInnerPos = (sin(tick.position) * 48.0) + (dialView.frame.width / 2.0)
                    let yInnerPos = (cos(tick.position) * 48.0) + (dialView.frame.height / 2.0)
                    let xOuterPos = (sin(tick.position) * 64.0) + (dialView.frame.width / 2.0)
                    let yOuterPos = (cos(tick.position) * 64.0) + (dialView.frame.height / 2.0)
                    path.move(to: CGPoint(x: xInnerPos, y: yInnerPos))
                    path.line(to: CGPoint(x: xOuterPos, y: yOuterPos))
                }

            }
            tickLayer.path = path.cgPath
            dialView.layer?.addSublayer(tickLayer)

        }
            
        
        
    }
    

}
