//
//  BoxModel.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class BoxModel {
    /*
     This attribute stores all the WallModel objects that make up the current box design.
     */
    var walls: [WallModel]
    
    //This initializer can be used to create a box using data loaded from a file
    init(_ walls: [WallModel]) {
        self.walls = walls
    }
    
    //This initializer creates the default box model which is loaded whenever the application is launched
    init() {
        //bottom wall
        let wall0 = WallModel(4.0, 4.0, 0.50, WallType.largeCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 0.0), tabWidth: nil)
        //left and right walls
        let wall1 = WallModel(4.0, 4.0, 0.50, WallType.longCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 0.0), tabWidth: nil)
        let wall2 = WallModel(4.0, 4.0, 0.50, WallType.longCorner, JoinType.overlap, SCNVector3Make(4.0, 0.0, 0.0), tabWidth: nil)
        //back and front walls
        let wall3 = WallModel(4.0, 4.0, 0.50, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 0.0), tabWidth: nil)
        let wall4 = WallModel(4.0, 4.0, 0.50, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 4.0), tabWidth: nil)
        var walls = [wall0, wall1, wall2, wall3, wall4]
        self.walls = walls
    }
    
    /*
     These attributes may not necessarily be set at any time.
     However, they make the process of adjusting the individual
     walls of the path significantly easier.
     */
    var boxWidth: Double?
    var boxLength: Double?
    var boxHeight: Double?
    var innerDimensions: Bool?
    var joinType: JoinType?
    var tabWidth: Double?
}
