//
//  AGIntervalStruct.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

internal struct IntervalStruct {
    var min: CGFloat = 0.0
    var max: CGFloat = 0.0
    
    init(min: CGFloat, max: CGFloat) {
        assert(min <= max, NSLocalizedString("Illegal interval", comment: ""))
        self.min = min
        self.max = max
    }
}
