//
//  AGArcStruct.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

internal struct ArcStruct {
    
    var circle = CircleStruct(origin: CGPoint.zero, radius: 0)
    var startAngle: CGFloat = 0.0
    var endAngle: CGFloat = 0.0
    
    init(circle: CircleStruct, startAngle: CGFloat, endAngle: CGFloat) {
        
        self.circle = circle
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
}
