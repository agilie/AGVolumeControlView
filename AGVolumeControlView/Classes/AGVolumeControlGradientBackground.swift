//
//  AGVolumeControlGradientBackground.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class AGVolumeControlGradientBackground: AGVolumeControlDrawView
{
    
    public var rotationAngle : CGFloat = 0.0
    
    fileprivate lazy var gradientBackgroundColor : UIColor =
    {
         [unowned self] in
         return UIColor.backgroundColor(frame: self.frame, scale: 3.0, hueStart: self.hueStart, hueEnd: self.hueEnd)
    }()
    
    override func setup () {
        self.backgroundColor = .clear
    }

    override open func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        drawVolumeControlBackgroundColor(withAngle: rotationAngle, inContext: context, size: self.frame.size)
        drawRadialGradient(context: context, size: self.frame.size)
    }
}

extension AGVolumeControlGradientBackground
{
    internal func drawVolumeControlBackgroundColor (withAngle angle: CGFloat, inContext context: CGContext, size : CGSize) {
        self.gradientBackgroundColor.setFill()
        
        let circle = CircleStruct(origin: bounds.center, radius: 1)

        let thumbOrigin = AGVolumeControlMathHelper.endPoint(fromCircle: circle, angle: angle)
        
        var minSize = min(size.width, size.height) / 2 /*- self.radius*/

        minSize = min((self.radius + self.maxVolumeHeight) + (min(bounds.width, bounds.height) / 2), minSize)
        
        let thumbCircle = CircleStruct(origin: thumbOrigin, radius: minSize)
        let thumbArc = ArcStruct(circle: thumbCircle, startAngle: AGVolumeControlMathHelper.circleMinValue, endAngle: AGVolumeControlMathHelper.circleMaxValue)
        
        AGVolumeControlGradientBackground.drawArc(withArc: thumbArc, lineWidth: 2, inContext: context)
    }

    fileprivate func drawRadialGradient (context: CGContext, size : CGSize)
    {
        let minSize = min(size.width, size.height)
        
        let gradientSize = CGSize (width: minSize * 1.1, height: minSize * 1.1)
        
        let colors = [UIColor.clear.cgColor,
                      UIColor.clear.cgColor,
                      UIColor.clear.cgColor,
                      UIColor.clear.cgColor,
                      UIColor.init(white: 0.0, alpha: 0.1).cgColor,
                      UIColor.init(white: 0.0, alpha: 0.3).cgColor,
                      UIColor.init(white: 0.0, alpha: 0.5).cgColor,
                      UIColor.init(white: 0.0, alpha: 0.7).cgColor,
                      UIColor.init(white: 0.0, alpha: 0.9).cgColor,
                      UIColor.init(white: 0.0, alpha: 0.95).cgColor,
                      UIColor.black.cgColor
            ] as CFArray
        
        let endRadius = min(gradientSize.width, gradientSize.height) / 2
        
        let center = CGPoint (x: self.center.x - self.frame.origin.x,
                              y: self.center.y - self.frame.origin.y)
        
        if let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil) {
            context.drawRadialGradient(gradient,
                                       startCenter: center,
                                       startRadius: 0.0,
                                       endCenter: center,
                                       endRadius: endRadius,
                                       options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
    }
}
