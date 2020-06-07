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
    var path: NSBezierPath {
        didSet {
            print("Path was changed.")
        }
    }
    var materialThickness: Double {
        didSet {
            if materialThickness != oldValue {
                path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, tabWidth: self.tabWidth)
            }
        }
    }
    var position: SCNVector3
    
    /*
     These attributes are necessary for updating and
     modifying the wall's path whenever changes
     are made.
     */
    //width describes the length of the sides along the x axis during path creation
    //this may NOT correspond to the actual width of the BOX
    var width: Double {
        didSet {
            if width != oldValue {
                path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, tabWidth: self.tabWidth)
            }
        }
    }
    //length describes the length of the sides along the y axis during path creation
    //this may NOT correspond to the actual length of the BOX
    var length: Double {
        didSet {
            if length != oldValue {
                path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, tabWidth: self.tabWidth)
            }
        }
    }
    var wallType: WallType
    var joinType: JoinType {
        didSet {
            if joinType != oldValue {
                path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, tabWidth: self.tabWidth)
            }
        }
    }
    var tabWidth: Double? {
        didSet {
            if tabWidth != oldValue {
                path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, tabWidth: self.tabWidth)
            }
        }
    }
    
    init(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, _ position: SCNVector3, tabWidth internalTabWidth: Double?) {
        self.width = width
        self.length = length
        self.materialThickness = materialThickness
        self.wallType = wallType
        self.joinType = joinType
        self.tabWidth = internalTabWidth
        self.position = position
        self.path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, tabWidth: internalTabWidth)
    }
}
