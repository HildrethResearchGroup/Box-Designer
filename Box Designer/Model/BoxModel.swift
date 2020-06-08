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
    //refers to box dimension along x axis
    var boxWidth: Double {
        willSet {
            if innerDimensions {
                self.boxWidth = newValue + 2 * materialThickness
            } else {
                self.boxWidth = newValue
            }
        }
        didSet {
            if boxWidth != oldValue {
                for wall in self.walls {
                    if (wall.wallType == WallType.largeCorner) {
                        wall.width = boxWidth
                    } else if (wall.wallType == WallType.smallCorner) {
                        wall.width = boxWidth
                    } else if (wall.wallType == WallType.longCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(CGFloat(oldValue), 0.0, 0.0)) {
                            wall.position = SCNVector3Make(CGFloat(boxWidth), 0.0, 0.0)
                        }
                    }
                }
            }
            //inform SceneGenerator
        }
    }
    //refers to box dimension along z axis
    var boxLength: Double {
        willSet {
            if innerDimensions {
                self.boxLength = newValue + 2 * materialThickness
            } else {
                self.boxLength = newValue
            }
        }
        didSet {
            if boxLength != oldValue {
                for wall in self.walls {
                    if (wall.wallType == WallType.largeCorner) {
                        wall.length = boxLength
                    } else if (wall.wallType == WallType.smallCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(oldValue))) {
                            wall.position = SCNVector3Make(0.0, 0.0, CGFloat(boxLength))
                        }
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.width = boxLength
                    }
                }
                //inform SceneGenerator
            }
        }
    }
    //refers to box dimension along y axis
    var boxHeight: Double {
        willSet {
            if innerDimensions {
                self.boxHeight = newValue + 2 * materialThickness
            } else {
                self.boxHeight = newValue
            }
        }
        didSet {
            if boxHeight != oldValue {
                for wall in self.walls {
                    if (wall.wallType == WallType.largeCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(oldValue), 0.0)) {
                            wall.position = SCNVector3Make(0.0, CGFloat(boxHeight), 0.0)
                        }
                    } else if (wall.wallType == WallType.smallCorner) {
                        wall.length = boxHeight
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.length = boxHeight
                    }
                }
                //inform SceneGenerator
            }
        }
    }
    var materialThickness: Double {
        didSet {
            if materialThickness != oldValue {
                for wall in self.walls {
                    wall.materialThickness = self.materialThickness
                }
                //inform SceneGenerator
            }
        }
    }
    var innerDimensions: Bool {
        willSet {
            if innerDimensions != newValue {
                if newValue == true {
                    /*
                     when changing TO innerdimensions,
                     manually add the extra length
                     to each dimension BEFORE switching
                     future changes will be adjusted
                     by the dimensions themselves
                    */
                    self.boxLength += 2 * materialThickness
                    self.boxWidth += 2 * materialThickness
                    self.boxHeight += 2 * materialThickness
                    //inform SceneGenerator
                }
            }
        }
        didSet {
            if innerDimensions != oldValue {
                if oldValue == true {
                    /*
                     when changing FROM innerdimensions,
                     manually remove the extra length
                     from each dimension AFTER switching
                     future changes will not need or
                     receive any adjustment.
                     */
                    self.boxLength -= 2 * materialThickness
                    self.boxWidth -= 2 * materialThickness
                    self.boxHeight -= 2 * materialThickness
                    //inform SceneGenerator
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
                //inform SceneGenerator
            }
        }
    }
    var tabWidth: Double? {
        didSet {
            if tabWidth != oldValue {
                for wall in self.walls {
                    wall.tabWidth = self.tabWidth
                }
                //inform SceneGenerator
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
        let walls = [wall0, wall1, wall2, wall3, wall4]
        
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
