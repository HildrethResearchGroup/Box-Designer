import Foundation
import Cocoa
import SceneKit
/**
 This class provides the structure for the compete box model.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxModel.swift was created on 6/6/2020.
 
 */
class BoxModel {
    /// This is a variable that's associated with internal separators. However, it would be wise to refactor how internal separators are dealt with.
    var counterLength = 0
    /// This variable ensures the current box model has access to the scene, so that it can update its variables.
    let sceneGenerator = SceneGenerator.shared
    /// This variable is an array of all the current walls that make up the box model.
    var walls: Dictionary<Int,WallModel>
    /// This variable refers to the box dimension along the x-axis.
    var boxWidth: Double {
        /// This updates the box width. If user wants their inputted box width to be the inner dimensions, box width is updated accordingly.
        willSet {
            if innerDimensions {
                self.boxWidth = newValue + 2 * materialThickness
            } else {
                self.boxWidth = newValue
            }
        }
        /// This updates all the current walls with the new box width, according to their wall type. It will also update a wall's position if necessary.
        didSet {
            if boxWidth != oldValue {
                for wall in self.walls.values {
                    if (wall.wallType == WallType.largeCorner) {
                        wall.width = boxWidth
                    } else if (wall.innerWall && wall.innerPlane == WallType.longCorner) {
                        let originalPlacement = wall.position.x/CGFloat(oldValue)
                        wall.position = SCNVector3Make(CGFloat(Double(originalPlacement)*boxWidth), 0.0,0.0)
                    } else if (wall.wallType == WallType.smallCorner) {
                        wall.width = boxWidth
                    } else if (wall.wallType == WallType.longCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(CGFloat(oldValue - materialThickness/2), 0.0, 0.0)) {
                            wall.position = SCNVector3Make(CGFloat(boxWidth - materialThickness/2), 0.0, 0.0)
                        }
                    }
                }
            }
            /// Make sure the scene updates after changes.
            sceneGenerator.generateScene(self)
        }
    }
    /// This variable refers to the box dimension along the z-axis.
    var boxLength: Double {
        /// This updates the box lenth. If user wants their inputted box length to be the inner dimensions, box length is updated accordingly.
        willSet {
            if innerDimensions {
                self.boxLength = newValue + 2 * materialThickness
            } else {
                self.boxLength = newValue
            }
        }
        /// This updates all the current walls with the new box length, according to their wall type. It will also update a wall's position if necessary.
        didSet {
            if boxLength != oldValue {
                for wall in self.walls.values {
                    if (wall.wallType == WallType.largeCorner || (wall.innerWall && wall.innerPlane == WallType.largeCorner)) {
                        wall.length = boxLength
                    } else if (wall.innerWall && wall.innerPlane == WallType.smallCorner){
                        let originalPlacement = wall.position.z/CGFloat(oldValue)
                        wall.position = SCNVector3Make(0.0, 0.0,CGFloat(Double(originalPlacement)*boxLength))
                    } else if (wall.wallType == WallType.smallCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(oldValue - materialThickness/2))) {
                            wall.position = SCNVector3Make(0.0, 0.0, CGFloat(boxLength - materialThickness/2))
                        }
                    } else if (wall.wallType == WallType.longCorner || (wall.innerWall && wall.innerPlane == WallType.longCorner)) {
                        wall.width = boxLength
                    }
                }
                /// Make sure the scene updates after changes.
                sceneGenerator.generateScene(self)
            }
        }
    }
    /// This variable refers to the  box dimension along the y-axis.
    var boxHeight: Double {
        willSet {
            /// This updates the box height. If user wants their inputted box length to be the inner dimensions, box height is updated accordingly.
            if innerDimensions {
                self.boxHeight = newValue + 2 * materialThickness
            } else {
                self.boxHeight = newValue
            }
        }
        /// This updates all the current walls with the new box length, according to their wall type. It will also update a wall's position if necessary.
        didSet {
            if boxHeight != oldValue {
                for wall in self.walls.values {
                    if (wall.wallType == WallType.largeCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(oldValue - materialThickness/2), 0.0)) {
                            wall.position = SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness/2), 0.0)
                        }
                    } else if (wall.innerWall && wall.innerPlane == WallType.largeCorner){
                        let originalPlacement = wall.position.y/CGFloat(oldValue)
                        wall.position = SCNVector3Make(0.0, CGFloat(Double(originalPlacement)*boxHeight), 0.0)
                    }else if (wall.wallType == WallType.smallCorner) {
                        wall.length = boxHeight
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.length = boxHeight
                    }
                }
                /// Make sure the scene updates after changes.
                sceneGenerator.generateScene(self)
            }
        }
    }
    /// This variable refers to the material thickness. The material thickness is necessary for drawing the components the correct size on the PDF, to ensure the components fit together without spaces.
    var materialThickness: Double {
        /// This updates the material thickness of the box model and its walls. It then updates the position of all the current walls to correctly display on the screen.
        didSet {
            if materialThickness != oldValue {
                for wall in self.walls.values {
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
                /// Make sure the scene updates after changes.
                sceneGenerator.generateScene(self)
            }
        }
    }
    /// This variable indicates whether the current width, height, and length of the box model should indicate 1) only the space between components (true) or 2) the between components, along with the walls themselves (false).
    var innerDimensions: Bool {
        /// This adjusts the box length, height, and width if the user wants those values to indicate the inner dimensions instead of the total dimensions.
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
                    
                    /// Make sure the scene updates after changes.
                    sceneGenerator.generateScene(self)
                }
            }
        }
        /// This adjusts the box length, height, and width if the user wants those values to indicate the total dimensions instead of the inner dimensions.
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
                    
                    /// Make sure the scene updates after changes.
                    sceneGenerator.generateScene(self)
                }
            }
        }
    }
    /// This variable indicates the join type between walls (tab, overlap, or slotted).
    var joinType: JoinType {
        /// This updates all the current walls with the new join type.
        didSet {
            if joinType != oldValue {
                for wall in self.walls.values {
                    wall.joinType = self.joinType
                }
                /// Make sure the scene updates after changes.
                sceneGenerator.generateScene(self)
            }
        }
    }
    /// This variable indicates the number of tabs that the user wants, if the join type is "tab." **This may need to be refactored if we want to give the choice of number tabs or tab width.
    var numberTabs: Double? {
        didSet {
            /// This updates the current walls' number of tabs.
            if numberTabs != oldValue {
                for wall in self.walls.values {
                    wall.numberTabs = self.numberTabs
                }
                /// Make sure the scene updates after changes.
                sceneGenerator.generateScene(self)
            }
        }
    }
    /// This variable indicates whether the top wall (the lid) should be included in the box model (true) or not (false).
//    var lidOn: Bool {
//        /// This either adds or a removes the lid in the current box model.
//        didSet {
//            if lidOn != oldValue {
//                let wallLid = WallModel(boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness / 2), 0.0), numberTabs: numberTabs)
//                if (lidOn == false){
//                    if let index = walls.lastIndex(where: {$0.wallType == WallType.largeCorner}) {
//                        walls.remove(at: index)
//                    }
//                }else{
//                    walls.append(wallLid)
//                }
//                /// Make sure the scene updates after changes.
//                sceneGenerator.generateScene(self)
//            }
//        }
//    }
    /**
     This variable adds an internal separator if there's room (true).
     - Note: Right now, the model can only add two internal separators at pre-defined locations. We will need to refactor this so the user can 1) choose where to put the inner wall and 2) which plane it should be on.
     */
//    var addInternalSeparator : Bool {
//        /// This adds a max of 2 internal separators on the x-z plane (I think), at 1/3 and 2/3 distance from the outer wall.
//        didSet {
//            if addInternalSeparator && counterLength == 1 {
//                // add separator in the box
//                let innerWallModel = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, self.joinType, SCNVector3Make(0.0, 0.0, CGFloat((1/3) * self.boxLength) ), numberTabs: numberTabs)
//                if(addInternalSeparator) {
//                    walls.append(innerWallModel)
//                    addInternalSeparator = false
//                    /// Make sure the scene updates after changes.
//                    sceneGenerator.generateScene(self)
//                }
//            }
//                // add another separator in the box
//            else if addInternalSeparator && counterLength == 2 {
//                let innerWallModel2 = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, self.joinType, SCNVector3Make(0.0, 0.0,CGFloat((2/3) * self.boxLength)), numberTabs: numberTabs)
//                    if(addInternalSeparator) {
//                        walls.append(innerWallModel2)
//                        addInternalSeparator  = false
//                        /// Make sure the scene updates after changes.
//                        sceneGenerator.generateScene(self)
//                    }
//                }
//
//            }
//
//    }
    
    /**
     This variable handles removing an internal separator (true).
     - Note: This should become obsolete when we add the functionality to add or remove a selected wall. To do this, we need to be able to associate the selected wall with the its index in BoxModel.walls array.
     */
//    var removeInnerWall: Bool {
//        didSet {
//
//            if removeInnerWall && (counterLength > 0) {
//                counterLength -= 1
//                if let index = walls.lastIndex(where: {$0.wallType == WallType.smallCorner}){
//                     walls.remove(at: index)
//                 }
//                removeInnerWall = false
//                sceneGenerator.generateScene(self)
//            }
//
//        }
//
//    }
    /// This variable allows the walls to be deleted from the BoxModel.walls array (and thus, the box model)
    static var wallIndex = 0
    
    /// This initializer creates the default box model which is loaded whenever the application is launched
    init() {
        
        // initialize default values first so that they can be easily changed if you want to change the default
        self.boxWidth = 4.0
        self.boxLength = 4.0
        self.boxHeight = 4.0
        self.materialThickness = 0.50
        self.numberTabs = 3
        self.innerDimensions = false
        self.joinType = JoinType.overlap
//        self.lidOn = true
//        self.addInternalSeparator = false
//        self.removeInnerWall = false
        
        // create variables for positioning the walls (because it's initially a box, offset2 could use the height, length, or width to create positions)
        // if the default model is not a cube, this will not work
        let offset1 = materialThickness/2
        let offset2 = self.boxWidth - materialThickness/2
        
        // create the initial walls for viewing
        
        let wallBottom = WallModel(boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(offset1), 0.0), numberTabs: numberTabs)
        let wallLeft = WallModel(boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset1), 0.0, 0.0), numberTabs: numberTabs)
        let wallRight = WallModel(boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset2), 0.0, 0.0), numberTabs: numberTabs)
        let wallFront = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset1)), numberTabs: numberTabs)
        let wallBack = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset2)), numberTabs: numberTabs)
        let wallLid = WallModel(boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(offset2), 0.0), numberTabs: numberTabs)
        
        let walls = [wallBottom.getIndex() : wallBottom,wallLeft.getIndex() : wallLeft, wallRight.getIndex() : wallRight, wallFront.getIndex() : wallFront, wallBack.getIndex() : wallBack, wallLid.getIndex() : wallLid]
        
        // add walls to array
        self.walls = walls
    }
    
    func addWall(inner: Bool, type: WallType, innerPlacement: Double) {
        var newWall = WallModel(boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(0.0), 0.0), numberTabs: numberTabs)
        if inner {
            switch (type) {
            case WallType.largeCorner:
                newWall = WallModel(boxWidth, boxLength, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, CGFloat(innerPlacement*boxHeight), 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.longCorner:
                newWall = WallModel(boxLength, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(CGFloat(innerPlacement*boxWidth), 0.0, 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.smallCorner:
                newWall = WallModel(boxWidth, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, CGFloat(innerPlacement*boxLength)), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            }
        }
        // if wall is already in same place, don't add it
        for wall in self.walls.values {
            if SCNVector3EqualToVector3(wall.position, newWall.position) {return}
        }
        self.walls[newWall.getIndex()] = newWall
    }
    /**
    This initializer can be used to create a box using its parameters. It is necessary for opening a box model saved in a JSON file into the application.
     - Note:The functionality to load in a box model from a JSON file is not complete in JSONFileHandling.swift yet.
     - Parameters:
        - walls: an array walls that are included in the box model file
        - width: the box width indicated in the file
        - length: the box length indicated in the file
        - height: the box height indicated in the file
        - materialThickness: the box material thickness indicated in the file
        - innerDimensions: the value indicating whether the box dimensions in the file refer to inner or outer
        - joinType: the box join type indicated in the file
        - numberTabs: the number of tabs the box has, as indicated in the file
     */
    init(_ walls: Dictionary<Int,WallModel>, _ width: Double, _ length: Double, _ height: Double, _ materialThickness: Double, _ innerDimensions: Bool, _ joinType: JoinType, _ numberTabs: Double?) {
        self.walls = walls
        self.boxWidth = width
        self.boxLength = length
        self.boxHeight = height
        self.materialThickness = materialThickness
        self.innerDimensions = innerDimensions
        self.joinType = joinType
        self.numberTabs = numberTabs
//        self.lidOn = true
//        self.addInternalSeparator = false
//        self.removeInnerWall = false
    }
    
}
