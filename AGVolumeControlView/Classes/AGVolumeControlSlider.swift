//
//  AGVolumeControlSlider.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AGVolumeControlSlider: AGVolumeControlDrawView {
    
    public var volumeControlRadius: CGFloat = 0.0
    
    open var minimumValue: CGFloat = 0.0 {
        didSet {
            if endPointValue < minimumValue {
                endPointValue = minimumValue
            }
        }
    }
      
    open var maximumValue: CGFloat = 1.0 {
        didSet {
            if endPointValue > maximumValue {
                endPointValue = maximumValue
            }
        }
    }

    public var progressValue : CGFloat = 0

    open var endPointValue: CGFloat = 0.0 {
        didSet {
            if oldValue == endPointValue {
                return
            }
            if endPointValue > maximumValue {
                endPointValue = maximumValue
            }            
            setNeedsDisplay()
        }
    }

    public var thumbColor: UIColor = .white

    public var currentAngle : CGFloat = 0.0
    
    fileprivate var newTempAngle : CGFloat = 0.0
    fileprivate var oldTempAngle : CGFloat = 0.0
    
    lazy public var volumeControlColor : UIColor =
    {
        [unowned self] in
        return UIColor.сoloredGradientWithSectors(size: self.frame.size,
                                                   scale: 3.0,
                                                   sectorThickness : 5,
                                                   hueStart: self.hueStart,
                                                   hueEnd: self.hueEnd,
                                                   saturationStart: self.saturationStart,
                                                   saturationEnd: self.saturationEnd)
    }()
    
    override func setup() {
        self.backgroundColor = UIColor.clear
    }
    
    fileprivate func updateVolumeControl (newValue: CGFloat, touchPoint : CGPoint, progressValue : CGFloat, currentAngle : CGFloat, withTouch : Bool)
    {
        let frameSize = CGSize(width: volumeControlRadius * 2, height: volumeControlRadius * 2)
        let circleBezierPath = self.updateCircleBezierPath(frameSize: frameSize,
                                                           newValue: newValue,
                                                           touchPoint: touchPoint,
                                                           progressValue: progressValue,
                                                           currentAngle: currentAngle,
                                                           withTouch: withTouch)
        self.drawVolumeControl(size: frameSize, circlePath: circleBezierPath)
    }
    
    override open func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let valuesInterval = IntervalStruct(min: minimumValue, max: maximumValue)
        let endAngle = AGVolumeControlMathHelper.scaleToAngle(value: endPointValue, inInterval: valuesInterval) + AGVolumeControlMathHelper.circleInitialAngle -
            self.progressValue * AGVolumeControlMathHelper.rad(fromDegrees: 7)
        
        drawFilledArc(fromAngle: AGVolumeControlMathHelper.circleInitialAngle,
                      toAngle: AGVolumeControlMathHelper.circleMaxValue,
                      radius: (self.radius + self.maxVolumeHeight) * 1.1,
                      inContext: context,
                      color: UIColor.black,
                      mode: .fill)
        
        drawFilledArc(fromAngle: AGVolumeControlMathHelper.circleInitialAngle,
                      toAngle: AGVolumeControlMathHelper.circleMaxValue,
                      radius: volumeControlRadius,
                      inContext: context,
                      color: thumbColor,
                      mode: .stroke)
        
        drawThumb(withAngle: endAngle, inContext: context)
    }
    
    public func beginTracking (_ touch: UITouch)
    {
        let touchPosition = touch.location(in: self)
        let startPoint = CGPoint(x: bounds.center.x, y: 0)

        self.newTempAngle = AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint,
                                                         secondPoint: touchPosition,
                                                         inCircleWithCenter: bounds.center)
        self.oldTempAngle = self.newTempAngle
    }
    
    @discardableResult
    public func continueTracking(_ touch: UITouch) -> CGFloat
    {
        let touchPosition = touch.location(in: self)
        let startPoint = CGPoint(x: bounds.center.x,
                                 y: 0)

        let clockwise = self.isClockwise(startPoint: startPoint,
                                         touchPosition: touchPosition)
        
        let tempAngle = self.newTempAngle + AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint,
                                                                            secondPoint: touchPosition,
                                                                            inCircleWithCenter: bounds.center) - oldTempAngle
        
         if (tempAngle > 0.0 && tempAngle < CGFloat.pi / 2) && (oldTempAngle <= CGFloat.pi * 2 && oldTempAngle > CGFloat.pi) && clockwise == true {
            self.progressValue = 1
            self.updateVolumeControlWith(newValue: maximumValue,
                                         currentAngle: CGFloat.pi * 2,
                                         touchPosition: touchPosition)
            return CGFloat.pi * 2
        } else if tempAngle >= (CGFloat.pi * 3) / 2 && oldTempAngle <= CGFloat.pi / 2  && clockwise == false {
            self.progressValue = 0
            self.updateVolumeControlWith(newValue: minimumValue,
                                         currentAngle: 0,
                                         touchPosition: touchPosition)
            return 0.0
        }
        if (tempAngle < oldTempAngle && clockwise == false) || (tempAngle > oldTempAngle && clockwise == true)
        {
            self.newTempAngle += AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint,
                                                              secondPoint: touchPosition,
                                                              inCircleWithCenter: bounds.center) - oldTempAngle
            let value = newValue(from: endPointValue,
                                 touch: touchPosition,
                                 start: startPoint)
            self.progressValue = (maximumValue != 0 && value > 0.1) ? value/maximumValue : 0
            self.updateVolumeControlWith(newValue: value,
                                         currentAngle: self.currentAngle,
                                         touchPosition: touchPosition)
            return self.currentAngle
        }
        return self.currentAngle
    }
    
    fileprivate func newSliderValue(from oldValue: CGFloat, touch touchPosition: CGPoint, start startPosition: CGPoint) -> CGFloat
    {
        self.oldTempAngle = AGVolumeControlMathHelper.angle(betweenFirstPoint: startPosition, secondPoint: touchPosition, inCircleWithCenter: bounds.center)
        
        self.currentAngle = AGVolumeControlMathHelper.angle(betweenFirstPoint: startPosition, secondPoint: touchPosition, inCircleWithCenter: bounds.center)
        let interval = IntervalStruct(min: minimumValue, max: maximumValue)
        let deltaValue = AGVolumeControlMathHelper.delta(in: interval, for: self.currentAngle, oldValue: oldValue)
        
        return oldValue + deltaValue
    }
    
    fileprivate func newValue(from oldValue: CGFloat, touch touchPosition: CGPoint, start startPosition: CGPoint) -> CGFloat {
        var newValue = self.newSliderValue(from: oldValue, touch: touchPosition, start: startPosition)
        let range = maximumValue - minimumValue
                
        if newValue > maximumValue {
            newValue -= range
        }
        else if newValue < minimumValue {
            newValue += range
        }
        return newValue
    }
}

extension AGVolumeControlSlider {
    
    fileprivate func isClockwise (startPoint : CGPoint, touchPosition : CGPoint) -> Bool
    {
        if (oldTempAngle > (CGFloat.pi * 3) / 2 && AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint, secondPoint: touchPosition, inCircleWithCenter: bounds.center) < CGFloat.pi && AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint, secondPoint: touchPosition, inCircleWithCenter: bounds.center) > oldTempAngle - CGFloat.pi * 2)
        {
            return true
        } else if (oldTempAngle > 0 && oldTempAngle <= CGFloat.pi / 2
            && AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint, secondPoint: touchPosition, inCircleWithCenter: bounds.center) <= 2 * CGFloat.pi
            && AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint, secondPoint: touchPosition, inCircleWithCenter: bounds.center) >=  3 * CGFloat.pi / 2)
        {
            return false
        } else {
            return AGVolumeControlMathHelper.angle(betweenFirstPoint: startPoint, secondPoint: touchPosition, inCircleWithCenter: bounds.center) > oldTempAngle
        }
    }
    
    fileprivate func updateVolumeControlWith (newValue : CGFloat, currentAngle : CGFloat, touchPosition : CGPoint)
    {
        self.updateVolumeControl(newValue: newValue / 3, touchPoint: touchPosition, progressValue: self.progressValue, currentAngle: currentAngle, withTouch: true)
        endPointValue = newValue
    }

    
    fileprivate func updateCircleBezierPath(frameSize : CGSize, newValue: CGFloat, touchPoint : CGPoint, progressValue : CGFloat, currentAngle : CGFloat, withTouch : Bool) -> UIBezierPath {
        self.removeSublayers()
        
        let circleBezierPath = UIBezierPath.init()
        
        var firstPoint : CGPoint? = nil
        
        let startAngle = Int(AGVolumeControlMathHelper.degrees(fromRadians: (CGFloat.pi * 3) / 2))
        let endAngle = Int(AGVolumeControlMathHelper.degrees(fromRadians: (CGFloat.pi * 7) / 2))
        
        for i in startAngle...endAngle
        {
            if (i % 6) == 0 {
                let volumeControlParams = self.radiusAndAngleFor(circlePointIndex: i,
                                                                 currentAngle: currentAngle,
                                                                 newValue: newValue,
                                                                 progressValue: progressValue)
                
                let x = frameSize.width/2 + (self.frame.width - frameSize.width)/2 + volumeControlParams.radius * cos(volumeControlParams.rad)
                let y = frameSize.height/2 + (self.frame.height - frameSize.height)/2 + volumeControlParams.radius * sin(volumeControlParams.rad)
                
                if (firstPoint == nil) {
                    firstPoint = CGPoint(x: x, y: y)
                    circleBezierPath.move(to: firstPoint!)
                }
                
                let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                
                let currentCurrent = volumeControlParams.rad
                
                let currentCurrent2 = AGVolumeControlMathHelper.rad(fromDegrees: CGFloat(i+1))
                
                circleBezierPath.addArc(withCenter: center,
                                        radius: volumeControlParams.radius,
                                        startAngle: currentCurrent,
                                        endAngle: currentCurrent2,
                                        clockwise: true)
            }
        }
        circleBezierPath.close()
        circleBezierPath.lineCapStyle = .round
        return circleBezierPath
    }
    
    fileprivate func radiusAndAngleFor (circlePointIndex: Int, currentAngle : CGFloat, newValue: CGFloat, progressValue: CGFloat) -> (radius : CGFloat, rad: CGFloat)
    {
        var rad = AGVolumeControlMathHelper.rad(fromDegrees: CGFloat(circlePointIndex))
        let correctionAngle = (CGFloat.pi + CGFloat.pi / 2)
        var height : CGFloat = 0.0
        
        let heightNewValue = self.maxVolumeHeight * progressValue + 0.0
        
        if (rad - correctionAngle) <= currentAngle {
            let angle = rad - correctionAngle
            height = CGFloat(heightNewValue * CGFloat(CGFloat(angle - AGVolumeControlMathHelper.circleMinValue) / CGFloat(AGVolumeControlMathHelper.circleMaxValue - AGVolumeControlMathHelper.circleMinValue)))
        }
        
        //Use it Only for gradient color with sectors
        let correctionBezierMinAngle = AGVolumeControlMathHelper.rad(fromDegrees: CGFloat(circlePointIndex - 4))
        let correctionBezierMaxAngle = AGVolumeControlMathHelper.rad(fromDegrees: CGFloat(circlePointIndex + 4))
        
        if (correctionBezierMinAngle - correctionAngle) <= currentAngle
            && (correctionBezierMaxAngle - correctionAngle) >= currentAngle
        {
            height = 0.0
            rad = AGVolumeControlMathHelper.rad(fromDegrees: CGFloat(circlePointIndex - 5))
        }
        let r = volumeControlRadius + height
        return (radius : r, rad : rad)
    }
    
    fileprivate func drawVolumeControl (size : CGSize, circlePath : UIBezierPath)
    {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let shapeRect = CGRect(x: 0,
                               y: 0,
                               width: size.width,
                               height: size.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: size.width/2, y: size.height/2)
        
        shapeLayer.fillColor = self.volumeControlColor.cgColor
        
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.opacity = 1.0
        
        let shapeLayerBezier = UIBezierPath()
        
            shapeLayerBezier.append(circlePath)
        
        let innerCircleBezierRect = CGRect(x: (self.frame.size.width - size.width) / 2,
                                           y: (self.frame.size.height - size.height) / 2,
                                           width: size.width,
                                           height: size.height)
        
        let innerCircleBezier = UIBezierPath.init(roundedRect: innerCircleBezierRect,
                                                  cornerRadius: innerCircleBezierRect.height/2)
            innerCircleBezier.close()
        
        shapeLayerBezier.append(innerCircleBezier)
        shapeLayerBezier.close()
        
        shapeLayer.path = shapeLayerBezier.cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func removeSublayers() {
        if let sublayers = self.layer.sublayers
        {
            for layer in sublayers
            {
                layer.removeFromSuperlayer()
            }
        }
    }
}
