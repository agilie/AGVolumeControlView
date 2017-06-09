//
//  ColoredGradientColorWithSectors.swift
//  VolumeControl
//
//  Created by Michael Liptuga on 31.05.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    public class func сoloredGradientWithSectors(size : CGSize,
                                                scale : CGFloat,
                                      sectorThickness : Int,
                                             hueStart : CGFloat,
                                               hueEnd : CGFloat,
                                      saturationStart : CGFloat,
                                        saturationEnd : CGFloat) -> UIColor {

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let sectors : Int = 360
        
        let center = CGPoint(x: size.width / 2,
                             y: size.height / 2)
        
        let angle = 2 * CGFloat.pi/CGFloat(sectors)
        
        let thickness = max(sectorThickness, 1)
        
        let gradientColor = UIColor.circleSpectrumGradientColor(size: size,
                                                                scale: scale,
                                                                hueStart: hueStart,
                                                                hueEnd: hueEnd,
                                                                saturationStart: saturationStart,
                                                                saturationEnd: saturationEnd)
        for i in 0..<sectors
        {
            if (i % (thickness + 1) == 0)
            {
                let bezierPath = UIBezierPath.init(arcCenter: center,
                                                   radius: size.width / 2,
                                                   startAngle: CGFloat(i) * angle,
                                                   endAngle: CGFloat(i + thickness) * angle,
                                                   clockwise: true)
                
                    bezierPath.addLine(to: center)
                    bezierPath.close()
                
                    gradientColor.setFill()
                    bezierPath.fill()
            }
        }
        var color2 = UIColor.white
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            color2 = UIColor.init(patternImage: newImage)
        }
        UIGraphicsEndImageContext()
        return color2
    }    
    
    public class func circleSpectrumGradientColor (size: CGSize,
                                                   scale : CGFloat,
                                                   hueStart : CGFloat,
                                                   hueEnd : CGFloat,
                                                   saturationStart : CGFloat,
                                                   saturationEnd : CGFloat) -> UIColor
    {
        
        if let spectrumImage = self.circleSpectrumGradientImage(size: size,
                                                                scale: scale,
                                                                hueStart: hueStart,
                                                                hueEnd: hueEnd,
                                                                saturationStart: saturationStart,
                                                                saturationEnd: saturationEnd,
                                                                centerPoint: nil)
        {
            return UIColor.init(patternImage: spectrumImage)
        }
        return UIColor.white
    }

    public class func circleSpectrumGradientColor (size: CGSize,
                                                   scale : CGFloat,
                                                   hueStart : CGFloat,
                                                   hueEnd : CGFloat,
                                                   saturationStart : CGFloat,
                                                   saturationEnd : CGFloat,
                                                   centerPoint: CGPoint?) -> UIColor
    {
        
        if let spectrumImage = self.circleSpectrumGradientImage(size: size,
                                                                scale: scale,
                                                                hueStart: hueStart,
                                                                hueEnd: hueEnd,
                                                                saturationStart: saturationStart,
                                                                saturationEnd: saturationEnd,
                                                                centerPoint: centerPoint)
        {
            return UIColor.init(patternImage: spectrumImage)
        }
        return UIColor.white
    }

    public class func backgroundColor (frame: CGRect,
                                       scale : CGFloat,
                                       hueStart : CGFloat,
                                       hueEnd : CGFloat) -> UIColor
    {
        let maxSize = min(frame.size.width, frame.size.height)
        let newFrameSize : CGFloat = CGFloat(sqrt(pow(maxSize * 2, 2) + pow(maxSize * 2, 2)))
        
        let minHue = min(hueStart, hueEnd)
        let maxHue = max(hueStart, hueEnd)
        
        let range = maxHue - minHue
        
        var centerPoint = CGPoint (x: frame.center.x - frame.origin.x,
                                   y: frame.center.y - frame.origin.y)
        switch maxHue {
        case 0.00001..<0.25:
            centerPoint.x -= (maxSize / 1.5) / (1 / (1 - range))
            centerPoint.y -= (maxSize / 1.5) / (1 / (1 - range))
        case 0.25..<0.5:
            centerPoint.x -= (maxSize / 1.5) / (1 / (1 - range))
            centerPoint.y += (maxSize / 1.5) / (1 / (1 - range))
        case 0.5..<0.75:
            centerPoint.x += (maxSize / 1.5) / (1 / (1 - range))
            centerPoint.y += (maxSize / 1.5) / (1 / (1 - range))
        default:
            centerPoint.x += (maxSize / 1.5) / (1 / (1 - range))
            centerPoint.y -= (maxSize / 1.5) / (1 / (1 - range))
        }
        
        let size : CGSize = CGSize(width: newFrameSize, height: newFrameSize)
        
        return self.circleSpectrumGradientColor(size: size,
                                                scale: 3,
                                                hueStart: 0,
                                                hueEnd: 1,
                                                saturationStart: 1,
                                                saturationEnd: 1,
                                                centerPoint: centerPoint)
    }
    
    private class func circleSpectrumGradientImage (size: CGSize,
                                                    scale : CGFloat,
                                                    hueStart : CGFloat,
                                                    hueEnd : CGFloat,
                                                    saturationStart : CGFloat,
                                                    saturationEnd : CGFloat,
                                                    centerPoint: CGPoint?) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let sectors : Int = 720
        let startAngle : Int = 180
        
        var center = CGPoint(x: size.width / 2, y: size.height / 2)
        if centerPoint != nil {
            center = centerPoint!
        }
        
        let angle = 2 * CGFloat.pi/CGFloat(sectors)
        
        let hueRange = max(hueStart, hueEnd) - min(hueStart, hueEnd)
        let saturationRange = max(saturationStart, saturationEnd) - min(saturationStart, saturationEnd)
        
        for i in startAngle..<sectors+startAngle
        {
            let bezierPath = UIBezierPath.init(arcCenter: center,
                                               radius: size.width / 2,
                                               startAngle: CGFloat(i) * angle,
                                               endAngle: CGFloat(i + 1) * angle,
                                               clockwise: true)
            
            bezierPath.addLine(to: center)
            bezierPath.close()
            
            let hue = hueStart + hueRange * CGFloat(sectors - i + startAngle)/CGFloat(sectors)
            let saturation : CGFloat = saturationEnd + saturationRange * CGFloat(sectors - i + startAngle)/CGFloat(sectors)
            
            let color = UIColor.init(hue: hue, saturation: saturation, brightness: 1.0, alpha: 0.8)
            color.setFill()
            bezierPath.fill()
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
