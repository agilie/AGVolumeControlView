//
//  AGVolumeControlLinearGradientBackground.swift
//  Pods
//
//  Created by Michael Liptuga on 09.06.17.
//
//

import Foundation
import UIKit

open class AGVolumeControlLinearGradientBackground : UIView
{
    public var gradientMaskColor: UIColor = .black
        
    open override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colors = [gradientMaskColor.cgColor,
                      gradientMaskColor.withAlphaComponent(0.4).cgColor,
                        UIColor.clear.cgColor
                      ] as CFArray

        if let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        {
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0,
                                                      y: frame.height),
                                       end:  CGPoint(x : 0,
                                                     y :0),
                                       options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
    }
}
