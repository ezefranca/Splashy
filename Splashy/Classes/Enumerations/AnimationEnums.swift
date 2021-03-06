//
//  AnimationEnums.swift
//  Splashy
//
//  Created by Pedro Carrasco on 24/02/18.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import UIKit

enum AnimationsDelay: Double {
    case short = 0.25
}

enum AnimationDurations: Double {
    case short = 0.33
    case normal = 0.66
    case long = 1
}

enum AnimationType {
    case appearing
    case disappearing
}

enum AnimationStyling {
    enum Scale: CGFloat {
        case low = 0.5
        case high = 2.0
    }
}
