//
//  WallType.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

enum WallType {
    /*
     These cases correspond to the three types of wall construction commonly used when designing
     laser-cut box templates.  Creating walls so that those in the same plane have the same
     WallType ensures that the walls will correctly fit together.
     */
    
    /*
     case largeCorner:
     if overlapping join, this corresponds to the wall that "covers" all of its side
     if tabbed join, this corresponds to the wall whose corners have an outward tab in both directions
     */
    case largeCorner
    
    /*
     case smallCorner:
     if overlapping join, this corresponds to the wall that is "inset" into its side
     if tabbed join, this corresponds to the wall whose corners have an inward tab in both directions
     */
    case smallCorner
    
    /*
     case longCorner:
     if overlapping join, this corresponds to the wall that is rectangular, "panelling" its side
     if tabbed join, this corresponds to the wall whose corners have an outward tab in one direction and an outward tab in the other direction
     */
    case longCorner
}
