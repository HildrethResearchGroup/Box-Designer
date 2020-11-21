import Foundation
import Cocoa
/**
 This is the enumerated type for the way the box walls are joined together.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: JoinType.swift was created on 6/6/2020.
 
 */
enum JoinType {
    /// The tab join is interlocking; for now, the application allows for the number of tabs to be changed by the user. The construction of this type of join is dependent on material thickness, as the box shouldn't have overhanging sides.
    case tab
    /// The overlap join requires some type of adhesive after being laser-cut in order to construct the box. The construction of this type of join is dependent on the material thickness, as the box shouldn't have overhanging sides.
    case overlap
    
    case slot
}
