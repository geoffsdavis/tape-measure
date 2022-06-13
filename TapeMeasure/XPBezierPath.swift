//
//  XPBezierPath.swift
//  TapeMeasure
//
//  Created by Geoff Davis on 6/8/22.
//

import Foundation
import SwiftUI

#if !os(macOS)

    import UIKit
    public typealias XPBezierPath = UIBezierPath

    public extension UIBezierPath {
        
        func line(to: CGPoint) {
            self.addLine(to: to)
        }
        
    }

#else

    import Cocoa
    public typealias XPBezierPath = NSBezierPath

    public extension NSBezierPath {
        
        convenience init(roundedRect rect: CGRect, cornerRadius: CGFloat) {
            self.init(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
        }
        
        var cgPath: CGPath {
            let path = CGMutablePath()
            var points = [CGPoint](repeating: .zero, count: 3)
            
            for i in 0 ..< self.elementCount {
                let type = self.element(at: i, associatedPoints: &points)
                switch type {
                    case .moveTo:
                        path.move(to: points[0])
                    case .lineTo:
                        path.addLine(to: points[0])
                    case .curveTo:
                        path.addCurve(to: points[2], control1: points[0], control2: points[1])
                    case .closePath:
                        path.closeSubpath()
                    default:
                        break
                }
            }
            
            return path
        }
        
    }

#endif


public extension XPBezierPath {
    
    enum Direction {
        case up
        case left
        case right
        case down
    }
    
    // allows relative bezier control point coordinates
    func curve(
        from fromPoint: CGPoint,
        to toPoint: CGPoint,
        relativeControlPoint1: CGPoint,
        relativeControlPoint2: CGPoint
    ) {
        let absControlPoint1 = CGPoint(x: fromPoint.x + relativeControlPoint1.x, y: fromPoint.y + relativeControlPoint1.y)
        let absControlPoint2 = CGPoint(x: toPoint.x + relativeControlPoint2.x, y: toPoint.y + relativeControlPoint2.y)
        #if os(macOS)
            self.curve(to: toPoint, controlPoint1: absControlPoint1, controlPoint2: absControlPoint2)
        #else
            self.addCurve(to: toPoint, controlPoint1: absControlPoint1, controlPoint2: absControlPoint2)
        #endif
    }
    
    static func dialogBubble(width: CGFloat, height: CGFloat, tailDirection: XPBezierPath.Direction, tailOffset: CGFloat) -> XPBezierPath {

        let circleRatio: CGFloat = 0.55228
        
        let cornerRadius: CGFloat = 20.0
        let cornerOffset: CGFloat = cornerRadius * circleRatio
        
        // minY is top, maxY is bottom
        let minX: CGFloat = -width / 2.0
        let maxX = width / 2.0
        let minY: CGFloat = -height / 2.0
        let maxY = height / 2.0
        
        let adjustedTailOffset = tailOffset - (width / 2.0)
        let tailPadding: CGFloat = (cornerRadius * 2.0) + 10.0
        let actualTailOffset = adjustedTailOffset.clamped(min: minX + tailPadding, max: maxX - tailPadding)

        let path = XPBezierPath()

        // upper-left corner
        path.move(to: CGPoint(x: minX, y: minY + cornerRadius)) // initial move
        path.curve(
            from: path.currentPoint,
            to: CGPoint(x: minX + cornerRadius, y: minY),
            relativeControlPoint1: CGPoint(x: 0.0, y: -cornerOffset),
            relativeControlPoint2: CGPoint(x: -cornerOffset, y: 0.0)
        )
        
        // upward tail
        if tailDirection == .up {
            path.line(to: CGPoint(x: actualTailOffset - 20.0, y: minY))
            path.line(to: CGPoint(x: actualTailOffset, y: minY - 30.0))
            path.line(to: CGPoint(x: actualTailOffset + 20.0, y: minY))
        }

        // upper-right corner
        path.line(to: CGPoint(x: maxX - cornerRadius, y: minY))
        path.curve(
            from: path.currentPoint,
            to: CGPoint(x: maxX, y: minY + cornerRadius),
            relativeControlPoint1: CGPoint(x: cornerOffset, y: 0.0),
            relativeControlPoint2: CGPoint(x: 0.0, y: -cornerOffset)
        )

        // lower-right corner
        path.line(to: CGPoint(x: maxX, y: maxY - cornerRadius))
        path.curve(
            from: path.currentPoint,
            to: CGPoint(x: maxX - cornerRadius, y: maxY),
            relativeControlPoint1: CGPoint(x: 0.0, y: cornerOffset),
            relativeControlPoint2: CGPoint(x: cornerOffset, y: 0.0)
        )
        
        // downward tail
        if tailDirection == .down {
            path.line(to: CGPoint(x: actualTailOffset + 20.0, y: maxY))
            path.line(to: CGPoint(x: actualTailOffset, y: maxY + 30.0))
            path.line(to: CGPoint(x: actualTailOffset - 20.0, y: maxY))
        }

        // lower-left corner
        path.line(to: CGPoint(x: minX + cornerRadius, y: maxY))
        path.curve(
            from: path.currentPoint,
            to: CGPoint(x: minX, y: maxY - cornerRadius),
            relativeControlPoint1: CGPoint(x: -cornerOffset, y: 0.0),
            relativeControlPoint2: CGPoint(x: 0.0, y: cornerOffset)
        )

        path.close()

        return path
            
    }
    
}




public struct BezierShape: Shape {
    
    let bezierPath: XPBezierPath

    public init(bezierPath: XPBezierPath) {
        self.bezierPath = bezierPath
    }
    
    public func path(in rect: CGRect) -> Path {
        return Path(bezierPath.cgPath)
    }
    
}
