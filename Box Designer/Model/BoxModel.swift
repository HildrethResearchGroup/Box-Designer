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

    var walls: [WallModel]
    var boxWidth: Double {
        willSet {
            if innerDimensions {
                self.boxWidth = newValue + 2 * materialThickness
            } else {
                self.boxWidth = newValue
            }
        }
    }
    var boxLength: Double {
        willSet {
            if innerDimensions {
                self.boxLength = newValue + 2 * materialThickness
            } else {
                self.boxLength = newValue
            }
        }
    }
    var boxHeight: Double {
        willSet {
            if innerDimensions {
                self.boxHeight = newValue + 2 * materialThickness
            } else {
                self.boxHeight = newValue
            }
        }
    }
    var materialThickness: Double {
        didSet {
            if materialThickness != oldValue {
                for wall in self.walls {
                    wall.materialThickness = self.materialThickness
                }
            }
        }
    }
    var innerDimensions: Bool {
        didSet {
            if innerDimensions != oldValue {
                if innerDimensions {
                    /*
                     Invoking these properties' willSet functions;
                     this will handle the adaptation to the innerDimension
                     setting.  Trying to actively add the thickness here
                     will result in it being added twice.
                     
                     I kind of hate that this works, but hey, it works.
                     */
                    self.boxLength = self.boxLength + 0
                    self.boxWidth = self.boxWidth + 0
                    self.boxHeight = self.boxHeight + 0
                }
            }
        }
    }
    var joinType: JoinType {
        didSet {
            if joinType != oldValue {
                for wall in self.walls {
                    wall.joinType = self.joinType
                }
            }
        }
    }
    var tabWidth: Double? {
        didSet {
            if tabWidth != oldValue {
                for wall in self.walls {
                    wall.tabWidth = self.tabWidth
                }
            }
        }
    }
    
    //This initializer can be used to create a box using data loaded from a file
    init(_ walls: [WallModel], _ width: Double, _ length: Double, _ height: Double, _ materialThickness: Double, _ innerDimensions: Bool, _ joinType: JoinType, _ tabWidth: Double?) {
        self.walls = walls
        self.boxWidth = width
        self.boxLength = length
        self.boxHeight = height
        self.materialThickness = materialThickness
        self.innerDimensions = innerDimensions
        self.joinType = joinType
        self.tabWidth = tabWidth
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
        self.boxWidth = 4.0
        self.boxLength = 4.0
        self.boxHeight = 4.0
        self.materialThickness = 0.50
        self.innerDimensions = false
        self.joinType = JoinType.overlap
    }
    
    func smallestDimension() -> Double {
        var smallest = boxWidth
        if boxLength < smallest {
            smallest = boxLength
        }
        if boxHeight < smallest {
            smallest = boxHeight
        }
        return smallest
    }
}
