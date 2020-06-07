//
//  WallModel.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit.SCNGeometry

class WallModel {
    /*
     These attributes are those strictly necessary for
     1) drawing the wall's outline as a pdf
     2) displaying the wall within a SCNView
    */
    var path: NSBezierPath
    var materialThickness: Double
    var position: SCNVector3
    
    //This function can be used to create a wall using data from a saved file
    init(_ path: NSBezierPath, _ materialThickness: Double, _ position: SCNVector3) {
        self.path = path
        self.materialThickness = materialThickness
        self.position = position
    }
    
    //
    init(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, _ position: SCNVector3, tabWidth internalTabWidth: Double?) {
        self.width = width
        self.length = length
        self.materialThickness = materialThickness
        self.wallType = wallType
        self.joinType = joinType
        self.position = position
        self.path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, tabWidth: internalTabWidth)
    }
    
    /*
     These attributes may not necessarily be set at any time.
     However, they make the process of adjusting the wall path
     significantly easier.
     */
    var width: Double?
    var length: Double?
    var wallType: WallType?
    var joinType: JoinType?
}
