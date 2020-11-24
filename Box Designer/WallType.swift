import Foundation
import Cocoa
/**
 These enum cases correspond to the three types of wall construction commonly used when designing
 laser-cut box templates.  Creating walls so that those in the same plane have the same
 WallType ensures that the walls will correctly fit together.  Associated strings are for WallType to conform to Codable.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: WallType.swift was created on 6/6/2020.
 
 */
enum WallType : String, Codable {
    
    /**
     case smallCorner: parallel to the x-y plane
     if overlapping join, this corresponds to the wall that is "inset" into its side
     if tabbed join, this corresponds to the wall whose corners have an inward tab in both directions
     */
    case smallCorner = "smallCorner"
    
    /**
     case longCorner: parallel to the y-z plane
     if overlapping join, this corresponds to the wall that is rectangular, "panelling" its side
     if tabbed join, this corresponds to the wall whose corners have an outward tab in one direction and an outward tab in the other direction
     */
    case longCorner = "longCorner"
    /**
     The topSide WallType is parallel to the X-Z plane. It must be differentiated from the bottom to correctly draw and render slot joins. For overlap joins, this wall overlaps both longCorner and smallCorner wall types. This type used to be defined by "largeCorner," but was refactored by FS Fall 2020.
     */
    case topSide = "topSide"
    /**
     The bottomSide WallType is parallel to the X-Z plane. It must be differentiated from the top to correctly draw and render slot joins. For overlap joins, this wall overlaps both longCorner and smallCorner wall types. This type used to be defined by "largeCorner," but was refactored by FS Fall 2020.
     */
    case bottomSide = "bottomSide"
}
