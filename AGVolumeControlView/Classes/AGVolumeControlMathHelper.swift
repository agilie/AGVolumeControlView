//
//  AGVolumeControlMathHelper.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

internal extension CGVector {
    
    init(sourcePoint source: CGPoint, endPoint end: CGPoint) {
        let dx = end.x - source.x
        let dy = end.y - source.y
        self.init(dx: dx, dy: dy)
    }
    
    func dotProduct(_ v: CGVector) -> CGFloat {
        let dotProduct = (dx * v.dx) + (dy * v.dy)
        return dotProduct
    }
    
    func determinant(_ v: CGVector) -> CGFloat {
        let determinant = (v.dx * dy) - (dx * v.dy)
        return determinant
    }
    
    static func dotProductAndDeterminant(fromSourcePoint source: CGPoint, firstPoint first: CGPoint, secondPoint second: CGPoint) -> (dotProduct: Float, determinant: Float) {
        let u = CGVector(sourcePoint: source, endPoint: first)
        let v = CGVector(sourcePoint: source, endPoint: second)
        
        let dotProduct = u.dotProduct(v)
        let determinant = u.determinant(v)
        return (Float(dotProduct), Float(determinant))
    }
}

internal extension CGRect {
    
    // get the center of rect (bounds or frame)
    internal var center: CGPoint {
        get {
            let center = CGPoint(x: midX, y: midY)
            return center
        }
    }
}

// MARK: - Internal Helper
internal class AGVolumeControlMathHelper {
    
    @nonobjc static let circleMinValue: CGFloat = 0
    @nonobjc static let circleMaxValue: CGFloat = CGFloat(2 * Double.pi) /* - CGFloat.pi / 2 */
    @nonobjc static let circleInitialAngle: CGFloat = -CGFloat(Double.pi / 2)
    
    internal static func degrees(fromRadians value: CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(Double.pi)
    }
    
    internal static func rad(fromDegrees value: CGFloat) -> CGFloat {
        return value /  180 * 3.14
    }
    
    internal static func angle(betweenFirstPoint firstPoint: CGPoint, secondPoint: CGPoint, inCircleWithCenter center: CGPoint) -> CGFloat {

        let uv = CGVector.dotProductAndDeterminant(fromSourcePoint: center, firstPoint: firstPoint, secondPoint: secondPoint)
        let angle = atan2(uv.determinant, uv.dotProduct)
        
        let newAngle = (angle < 0) ? -angle : Float(Double.pi * 2) - angle
        return CGFloat(newAngle)
    }
    
    internal static func endPoint(fromCircle circle: CircleStruct, angle: CGFloat) -> CGPoint {
        
        let x = circle.radius * cos(angle) + circle.origin.x // cos(α) = x / radius
        let y = circle.radius * sin(angle) + circle.origin.y // sin(α) = y / radius
        let point = CGPoint(x: x, y: y)
        
        return point
    }
    
    internal static func scaleValue(_ value: CGFloat, fromInterval source: IntervalStruct, toInterval destination: IntervalStruct) -> CGFloat {
        let sourceRange = (source.max - source.min)
        let destinationRange = (destination.max - destination.min)
        let scaledValue = source.min + (value - source.min).truncatingRemainder(dividingBy: sourceRange)
        let newValue =  (((scaledValue - source.min) * destinationRange) / sourceRange) + destination.min
        
        return  newValue
    }
    
    internal static func scaleToAngle(value aValue: CGFloat, inInterval oldInterval: IntervalStruct) -> CGFloat {
        let angleInterval = IntervalStruct(min: circleMinValue , max: circleMaxValue)
        
        let angle = scaleValue(aValue, fromInterval: oldInterval, toInterval: angleInterval)
        return  angle
    }
        
    internal static func delta(in interval: IntervalStruct, for angle: CGFloat, oldValue: CGFloat) -> CGFloat {
        let angleIntreval = IntervalStruct(min: circleMinValue , max: circleMaxValue)
        
        let oldAngle = scaleToAngle(value: oldValue, inInterval: interval)
        let deltaAngle = self.angle(from: oldAngle, to: angle)
        
        return scaleValue(deltaAngle, fromInterval: angleIntreval, toInterval: interval)
    }
    
    private static  func angle(from alpha: CGFloat, to beta: CGFloat) -> CGFloat {
        let halfValue = circleMaxValue/2
        // Rotate right
        let offset = alpha >= halfValue ? circleMaxValue - alpha : -alpha
        let offsetBeta = beta + offset
        
        if offsetBeta > halfValue {
            return offsetBeta - circleMaxValue
        }
        else {
            return offsetBeta
        }
    }
    
    internal static func startEndPoints(angle : CGFloat) -> (CGPoint, CGPoint)
    {
        var currentAngle = self.degrees(fromRadians: angle)
        
        if currentAngle < 0.0 {
            currentAngle = self.degrees(fromRadians: CGFloat.pi * 2) + self.degrees(fromRadians: angle)
        }
        
        // offset of 45 is needed to make logic work
        currentAngle = currentAngle + 135
        
        let multiplier = Int(currentAngle / 360)
        if (multiplier > 0)
        {
            currentAngle = currentAngle - self.degrees(fromRadians: CGFloat.pi * 2 * CGFloat(multiplier))
        }
        
        var rotCalX: CGFloat = 0.0
        var rotCalY: CGFloat = 0.0
        
        let rotate = currentAngle / 90
        
        if rotate <= 1
        {
            rotCalY = rotate
        }
        else if rotate <= 2
        {
            rotCalY = 1
            rotCalX = rotate - 1
        }
        else if rotate <= 3
        {
            rotCalX = 1
            rotCalY = 1 - (rotate - 2)
        }
        else if rotate <= 4
        {
            rotCalX = 1 - (rotate - 3)
        }
        
        let start = CGPoint(x: 1 - CGFloat(rotCalY), y: 0 + CGFloat(rotCalX))
        let end = CGPoint(x: 0 + CGFloat(rotCalY), y: 1 - CGFloat(rotCalX))
        
        return (start, end)
    }
}
