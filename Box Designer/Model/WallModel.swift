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
/**
 This class provides the structure a single wall in the box model.
 
 - Authors:
    - CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 
 - Copyright:
    - Copyright © 2020 Hildreth Research Group. All rights reserved.
 
 */
class WallModel {

    /*
     These attributes are those strictly necessary for
     1) drawing the wall's outline as a pdf
     2) displaying the wall within a SCNView
    */
    /// This variable is essentialy the wall in vector form.
    var path: NSBezierPath
    /// This variable is the material thickness, as indicated by the user. It is mainly necessary to correctly display the model in the app and to correctly draw the walls in a PDF.
    var materialThickness: Double {
        /// This updates the path if the material thickness changes.
        didSet {
            if materialThickness != oldValue {
                updatePath()
            }
        }
    }
    /// This variable indicates where the path should start drawing; it is necessary so the model displays cohesively on the screen.
    var position: SCNVector3
    
    /*
     These attributes are necessary for updating and
     modifying the wall's path whenever changes
     are made.
     */
    /** This variable describes the dimension of the sides along the x-axis during path creation.
    - Note: This may not correspond to the actual width of the box itself-- for example, if a wall is overlapped by another wall, it will need to be smaller to account for the material thickness.
     */
    var width: Double {
        /// Update the wall's path if the width changes.
        didSet {
            if width != oldValue {
                updatePath()
            }
        }
    }
    /** This variable describes the dimension of the sides along the y-axis during path creation.
    - Note: This may not correspond to the actual length of the box itself-- for example, if a wall is overlapped by another wall, it will need to be smaller to account for the material thickness.
     */
    var length: Double {
        /// Update the wall's path if the length changes.
        didSet {
            if length != oldValue {
                updatePath()
            }
        }
    }
    /// This variable indicates the type of wall (necessary for how the path is drawn).
    var wallType: WallType
    /// This variable indicates the type of join (tab, overlop, or slotted).
    var joinType: JoinType {
        /// Update the wall's path if the joinType changes.
        didSet {
            if joinType != oldValue {
                updatePath()
            }
        }
    }
    /// This variable indicates the number of tabs the user wants if the joinType == WallType.join.  The type of wall changes how the tabs are drawn.
    var numberTabs: Double? {
        /// Update the path if the numberTabs changes.
        didSet {
            if numberTabs != oldValue {
                updatePath()
            }
        }
    }
    
    /// This function sets the wall's path from the return of PathGenerator's generatePath function, using its self-updating variables.
    private func updatePath(){
        self.path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, numberTabs: self.numberTabs)
    }
    
    /**
     This initializer creates a wall from its parameters.
    - Note: The wall does not need a third dimension, as (for a single wall), the third dimension is technically material thickness.
     - Parameters:
        - width: this is the wall width
        - length: this is the wall length
        - materialThickness: this is the wall material thickness
        - wallType: this is the type of wall (largeCorner, longCorner, or smallCorner)
        - joinType: this is the join type between walls
        - position: this is where the path of the wall starts
        - numberTabs: this is the number of tabs for the wall
     */
    init(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, _ position: SCNVector3, numberTabs: Double?) {
        self.width = width
        self.length = length
        self.materialThickness = materialThickness
        self.wallType = wallType
        self.joinType = joinType
        self.numberTabs = numberTabs
        self.position = position
        self.path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, numberTabs: numberTabs)
    }
}
