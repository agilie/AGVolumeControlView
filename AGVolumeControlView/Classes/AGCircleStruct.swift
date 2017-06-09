//
//  AGCircleStruct.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

internal struct CircleStruct {
    var origin = CGPoint.zero
    var radius: CGFloat = 0
    
    init(origin: CGPoint, radius: CGFloat) {
        assert(radius >= 0, NSLocalizedString("Illegal radius value", comment: ""))
        
        self.origin = origin
        self.radius = radius
    }
}
