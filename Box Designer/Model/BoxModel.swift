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
    var counterLength = 0
    var counterPerp = 0
    let sceneGenerator = SceneGenerator.shared
    var walls: [WallModel]
    //refers to box dimension along x axis
    var boxWidth: Double {
        //TO DO: refactor this. this code should not be in a variable declaration
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
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(CGFloat(oldValue - materialThickness/2), 0.0, 0.0)) {
                            wall.position = SCNVector3Make(CGFloat(boxWidth - materialThickness/2), 0.0, 0.0)
                        }
                        
                    }
                }
            }
            //inform SceneGenerator
            sceneGenerator.generateScene(self)
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
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(oldValue - materialThickness/2))) {
                            wall.position = SCNVector3Make(0.0, 0.0, CGFloat(boxLength - materialThickness/2))
                        }
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0,CGFloat((1/3) * oldValue))){
                           wall.position = SCNVector3Make(0.0, 0.0, CGFloat((1/3) * self.boxLength))
                        }
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0,CGFloat((2/3) * oldValue))){
                           wall.position = SCNVector3Make(0.0, 0.0, CGFloat((2/3) * self.boxLength))
                        }
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.width = boxLength
                    }
                }
                //inform SceneGenerator
                sceneGenerator.generateScene(self)
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
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(oldValue - materialThickness/2), 0.0)) {
                            wall.position = SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness/2), 0.0)
                        }
                    } else if (wall.wallType == WallType.smallCorner) {
                        wall.length = boxHeight
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.length = boxHeight
                    }
                }
                //inform SceneGenerator
                sceneGenerator.generateScene(self)
            }
        }
    }
    var materialThickness: Double {
        didSet {
            if materialThickness != oldValue {
                for wall in self.walls {
                    wall.materialThickness = self.materialThickness
                    if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(oldValue/2), 0.0)) {
                        wall.position = SCNVector3Make(0.0, CGFloat(materialThickness/2), 0.0)
                    } else if SCNVector3EqualToVector3(wall.position, SCNVector3Make(CGFloat(oldValue/2), 0.0, 0.0)) {
                        wall.position = SCNVector3Make(CGFloat(materialThickness/2), 0.0, 0.0)
                    } else if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(oldValue/2))) {
                        wall.position = SCNVector3Make(0.0, 0.0, CGFloat(materialThickness/2))
                    } else if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(boxLength - oldValue/2))) {
                        wall.position = SCNVector3Make(0.0, 0.0, CGFloat(boxLength - materialThickness/2))
                    } else if SCNVector3EqualToVector3(wall.position, SCNVector3Make(CGFloat(boxWidth - oldValue/2), 0.0, 0.0)) {
                        wall.position = SCNVector3Make(CGFloat(boxWidth - materialThickness/2), 0.0, 0.0)
                    } else if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(boxHeight - oldValue/2), 0.0)) {
                        wall.position = SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness/2), 0.0)
                    }
                }
                //inform SceneGenerator
                sceneGenerator.generateScene(self)
            }
        }
    }
        
    var innerDimensions: Bool {
        willSet {
            if innerDimensions != newValue {
                if newValue {
                    /*
                     When changing TO innerdimensions,
                     manually add the extra length
                     to each dimension BEFORE switching.
                     Future changes will be adjusted
                     by the dimensions themselves.
                    */
                    self.boxLength += 2 * materialThickness
                    self.boxWidth += 2 * materialThickness
                    self.boxHeight += 2 * materialThickness
                    
                    //inform SceneGenerator
                    sceneGenerator.generateScene(self)
                }
            }
        }
        didSet {
            if innerDimensions != oldValue {
                if oldValue {
                    /*
                     When changing FROM innerDimensions,
                     manually remove the extra length
                     from each dimension AFTER switching.
                     Future changes will not need or
                     receive any adjustment.
                     */
                    self.boxLength -= 2 * materialThickness
                    self.boxWidth -= 2 * materialThickness
                    self.boxHeight -= 2 * materialThickness
                    
                    //inform SceneGenerator
                    sceneGenerator.generateScene(self)
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
                sceneGenerator.generateScene(self)
            }
        }
    }
    var nTab: Double? {
        didSet {
            if nTab != oldValue {
                for wall in self.walls {
                    wall.nTab = self.nTab
                }
                //inform SceneGenerator
                sceneGenerator.generateScene(self)
            }
        }
    }
    var lidOn: Bool {
        didSet {
            if lidOn != oldValue {
                let wallLid = WallModel(boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness / 2), 0.0), tabWidth: nTab)
                if (lidOn == false){
                    if let index = walls.lastIndex(where: {$0.wallType == WallType.largeCorner}) {
                        walls.remove(at: index)
                    }
                }else{
                    walls.append(wallLid)
                }
                //inform SceneGenerator
                sceneGenerator.generateScene(self)
            }
        }
    }
    var lengthWall : Bool {
        didSet {
            if lengthWall && counterLength == 1 {
                // add separator in the box
                let innerWallModel = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, self.joinType, SCNVector3Make(0.0, 0.0, CGFloat((1/3) * self.boxLength) ), tabWidth: nil)
                if(lengthWall) {
                    walls.append(innerWallModel)
                    lengthWall = false
                    sceneGenerator.generateScene(self)
                }
            }
                // add another separator in the box
            else if lengthWall && counterLength == 2 {
                let innerWallModel2 = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, self.joinType, SCNVector3Make(0.0, 0.0,CGFloat((2/3) * self.boxLength)), tabWidth: nil)
                    if(lengthWall) {
                        walls.append(innerWallModel2)
                        lengthWall  = false
                        sceneGenerator.generateScene(self)
                    }
                }
            
            }
        
    }
    
    var removeInnerWall: Bool {
        didSet {
            
            if removeInnerWall && (counterLength > 0) {
                counterLength -= 1
                if let index = walls.lastIndex(where: {$0.wallType == WallType.smallCorner}){
                     walls.remove(at: index)
                 }
                removeInnerWall = false
                sceneGenerator.generateScene(self)
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
        self.nTab = tabWidth
        self.lidOn = true
        self.lengthWall = false
        self.removeInnerWall = false
    }
    
    //This initializer creates the default box model which is loaded whenever the application is launched
    init() {
        //bottom and top walls
        let wallBottom = WallModel(4.0, 4.0, 0.50, WallType.largeCorner, JoinType.overlap, SCNVector3Make(0.0, 0.25, 0.0), tabWidth: nil)
        let wallLid = WallModel(4.0, 4.0, 0.50, WallType.largeCorner, JoinType.overlap, SCNVector3Make(0.0, 3.75, 0.0), tabWidth: nil)
        //left and right walls
        let wallLeft = WallModel(4.0, 4.0, 0.50, WallType.longCorner, JoinType.overlap, SCNVector3Make(0.25, 0.0, 0.0), tabWidth: nil)
        let wallRight = WallModel(4.0, 4.0, 0.50, WallType.longCorner, JoinType.overlap, SCNVector3Make(3.75, 0.0, 0.0), tabWidth: nil)
        //back and front walls
        let wallFront = WallModel(4.0, 4.0, 0.50, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 0.25), tabWidth: nil)
        let wallBack = WallModel(4.0, 4.0, 0.50, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, 3.75), tabWidth: nil)
        let walls = [wallBottom,wallLeft, wallRight, wallFront, wallBack, wallLid]
        self.walls = walls
        self.boxWidth = 4.0
        self.boxLength = 4.0
        self.boxHeight = 4.0
        self.materialThickness = 0.50
        self.innerDimensions = false
        self.joinType = JoinType.overlap
        self.lidOn = true
        self.lengthWall = false
        self.removeInnerWall = false
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
