import Foundation
import Cocoa
/**
 These enum cases correspond to the three types of wall construction commonly used when designing
 laser-cut box templates.  Creating walls so that those in the same plane have the same
 WallType ensures that the walls will correctly fit together.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: WallType.swift was created on 6/6/2020.
 
 */
enum WallType {
    
    /**
     case largeCorner: parallel to the x-z plane
     if overlapping join, this corresponds to the wall that "covers" all of its side
     if tabbed join, this corresponds to the wall whose corners have an outward tab in both directions
     */
    //case largeCorner
    
    /**
     case smallCorner: parallel to the x-y plane
     if overlapping join, this corresponds to the wall that is "inset" into its side
     if tabbed join, this corresponds to the wall whose corners have an inward tab in both directions
     */
    case smallCorner
    
    /**
     case longCorner: parallel to the y-z plane
     if overlapping join, this corresponds to the wall that is rectangular, "panelling" its side
     if tabbed join, this corresponds to the wall whose corners have an outward tab in one direction and an outward tab in the other direction
     */
    case longCorner
    
    case topSide
    
    case bottomSide
}
