//
//  AGVolumeControlDrawView.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 09.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

@IBDesignable
open class AGVolumeControlDrawView: UIView {
    
    internal var radius: CGFloat = 0.0

    public var thumbRadius: CGFloat = 3.0
    
    public var hueStart : CGFloat = 0.1
    public var hueEnd   : CGFloat = 0.2
    
    public var saturationStart : CGFloat = 1.0
    public var saturationEnd   : CGFloat = 0.2
   
    public var maxVolumeHeight   : CGFloat = 0.0
        
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup () {
    
    }

    internal static func drawArc(withArc arc: ArcStruct, lineWidth: CGFloat = 2, mode: CGPathDrawingMode = .fillStroke, inContext context: CGContext) {
        
        let circle = arc.circle
        let origin = circle.origin
        
        UIGraphicsPushContext(context)
        context.beginPath()
        
        context.setLineWidth(lineWidth)
        context.setLineCap(CGLineCap.round)
        context.addArc(center: origin, radius: circle.radius, startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: false)
        context.move(to: CGPoint(x: origin.x, y: origin.y))
        context.drawPath(using: mode)
        
        UIGraphicsPopContext()
    }
    
    internal func drawFilledArc(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, radius : CGFloat, inContext context: CGContext, color : UIColor, mode: CGPathDrawingMode) {
        color.setFill()
        color.setStroke()
        
        let circle = CircleStruct(origin: bounds.center, radius: radius)
        let arc = ArcStruct(circle: circle, startAngle: startAngle, endAngle: endAngle)
        AGVolumeControlDrawView.drawArc(withArc: arc, lineWidth: 2, mode: mode, inContext: context)
    }
    
    
    internal func drawThumb(withAngle angle: CGFloat, inContext context: CGContext) {
        let circle = CircleStruct(origin: bounds.center, radius: self.radius)
        let thumbOrigin = AGVolumeControlMathHelper.endPoint(fromCircle: circle, angle: angle)
        let thumbCircle = CircleStruct(origin: thumbOrigin, radius: thumbRadius)
        let thumbArc = ArcStruct(circle: thumbCircle, startAngle: AGVolumeControlMathHelper.circleMinValue, endAngle: AGVolumeControlMathHelper.circleMaxValue)
        
        AGVolumeControlDrawView.drawArc(withArc: thumbArc, lineWidth: 1, inContext: context)
    }

}
