//
//  JoinType.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
/**
 This is the enumerated type for the way the box walls are joined together.
 
 - Authors:
    - CSM Field Session Summer 2020 and Fall 2020.
 
 - Copyright:
    - Copyright © 2020 Hildreth Research Group. All rights reserved.
 
 */
enum JoinType {
    /// The tab join is interlocking; for now, the application allows for the number of tabs to be changed by the user. The construction of this type of join is dependent on material thickness, as the box shouldn't have overhanging sides.
    case tab
    /// The overlap join requires some type of adhesive after being laser-cut in order to construct the box. The construction of this type of join is dependent on the material thickness, as the box shouldn't have overhanging sides.
    case overlap
}
