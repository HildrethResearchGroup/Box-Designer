import Foundation
import Cocoa
import SceneKit
/**
 This class provides the structure for the compete box model.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxModel.swift was created on 6/6/2020.
 
 */
class BoxModel : Codable {

    /// This variable ensures the current box model has access to the scene, so that it can update its variables.
    let sceneGenerator = SceneGenerator.shared
    /// This variable is a dictionary of all the current walls that make up the box model. Its key is the wall number, and its value is the associated wall.
    var walls: Dictionary<Int,WallModel>
    /// This variable contains the pairs of intersecting walls in the box model (for internal separator dimensions adjustments). The key is the wall that needs to adjust accordin g to the walls in
    var intersectingWalls = Dictionary<WallModel,[WallModel]>()
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
            self.adjustAllIntersections()
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
                    } else if (wall.wallType == WallType.longCorner || (wall.innerWall && wall.innerPlane == WallType.longCorner)) {
                        wall.width = boxLength
                    } else if (wall.wallType == WallType.smallCorner) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, 0.0, CGFloat(oldValue - materialThickness/2))) {
                            wall.position = SCNVector3Make(0.0, 0.0, CGFloat(boxLength - materialThickness/2))
                        }
                    }
                }
                self.adjustAllIntersections()
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
                self.adjustAllIntersections()
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
                self.adjustAllIntersections()
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
    
    /// This variable allows the walls and their associated nodes be associated -- the node is named the same as the wall when they are instantiated in SceneGenerator. This helps with organizing and deleting walls. It also associates the user's selection with the WallModel class. It is a global variable so that walls can get a unique identifier each time one is instantiated.
    static var wallNumberStatic = 0
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
        
        // create variables for positioning the walls (because it's initially a box, offset2 could use the height, length, or width to create positions)
        // if the default model is not a cube, this will not work
        let offset1 = materialThickness/2
        let offset2 = self.boxWidth - materialThickness/2
        
        // create the initial walls for viewing
        
        let wallBottom = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(offset1), 0.0), numberTabs: numberTabs)
        let wallLeft = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset1), 0.0, 0.0), numberTabs: numberTabs)
        let wallRight = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset2), 0.0, 0.0), numberTabs: numberTabs)
        let wallFront = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset1)), numberTabs: numberTabs)
        let wallBack = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset2)), numberTabs: numberTabs)
        let wallLid = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(offset2), 0.0), numberTabs: numberTabs)
        
        let walls = [wallBottom.getWallNumber() : wallBottom,wallLeft.getWallNumber() : wallLeft, wallRight.getWallNumber() : wallRight, wallFront.getWallNumber() : wallFront, wallBack.getWallNumber() : wallBack, wallLid.getWallNumber() : wallLid]
        
        // add walls to array
        self.walls = walls
    }
    
    func addWall(inner: Bool, type: WallType, innerPlacement: Double) {
        
        var newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.largeCorner, joinType, SCNVector3Make(0.0, CGFloat(0.0), 0.0), numberTabs: numberTabs)
        if inner {
            /// add internal separators
            switch (type) {
            case WallType.largeCorner:
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, CGFloat(innerPlacement*boxHeight), 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.longCorner:
                newWall = WallModel(BoxModel.wallNumberStatic,boxLength, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(CGFloat(innerPlacement*boxWidth), 0.0, 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.smallCorner:
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, CGFloat(innerPlacement*boxLength)), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            }
            // if other inner walls that would intersect, deal with that
            for wall in walls.values {
                if wall.innerWall && !SCNVector3EqualToVector3(wall.position, newWall.position){
                    /// add entry to intersecting walls dictionary
                    if intersectingWalls[newWall] == nil {
                        intersectingWalls[newWall] = [wall]
                    } else {intersectingWalls[newWall]?.append(wall)}
                }
            }
        } else {
            /// add external walls
            var offset3 = 0.0
            
            switch (type) {
            case WallType.largeCorner:
                innerPlacement == 1.0 ? (offset3 = self.boxHeight - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, type, self.joinType, SCNVector3Make(0.0, CGFloat(offset3), 0.0), numberTabs: numberTabs)
            case WallType.longCorner:
                innerPlacement == 1.0 ? (offset3 = self.boxWidth - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxLength, boxHeight, materialThickness, type, self.joinType, SCNVector3Make(CGFloat(offset3), 0.0, 0.0), numberTabs: numberTabs)
            case WallType.smallCorner:
                innerPlacement == 1.0 ? (offset3 = self.boxLength - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxHeight, materialThickness, type, self.joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset3)), numberTabs: numberTabs)
            }
        }
        // if wall is already in same place, don't add it
        for wall in self.walls.values {
            if SCNVector3EqualToVector3(wall.position, newWall.position) {return}
        }
        self.adjustAllIntersections()
        self.walls[newWall.getWallNumber()] = newWall
    }
    func updateIntersectingWalls() {
        /// If internal intersecting walls are deleted, the dictionary should be updated.
        for intersecting in self.intersectingWalls.keys {
            if self.walls[intersecting.getWallNumber()] == nil {
                self.intersectingWalls[intersecting] = nil
                break
            }
            for (index,intersected) in self.intersectingWalls[intersecting]!.enumerated() {
                if self.walls[intersected.getWallNumber()] == nil {
                    self.intersectingWalls[intersecting]?.remove(at: index)
                }
            }
        }
        /// adjust dimensions for new intersecting wall dictionary
        self.adjustAllIntersections()
    }
    private func adjustForIntersection(_ currentWall: WallModel, _ addedWall : WallModel) {
        
        if (currentWall.innerPlane == WallType.longCorner && addedWall.innerPlane == WallType.smallCorner) {
            addedWall.width = Double(currentWall.position.x) + materialThickness/2
        } else if (currentWall.innerPlane == WallType.longCorner && addedWall.innerPlane == WallType.largeCorner) {
            addedWall.width = Double(currentWall.position.x) + materialThickness/2
        } else if (currentWall.innerPlane == WallType.smallCorner && addedWall.innerPlane == WallType.longCorner) {
            addedWall.width = Double(currentWall.position.z) + materialThickness/2
        } else if (currentWall.innerPlane == WallType.smallCorner && addedWall.innerPlane == WallType.largeCorner) {
            addedWall.length = Double(currentWall.position.z) + materialThickness/2
        } else if (currentWall.innerPlane == WallType.largeCorner && addedWall.innerPlane == WallType.smallCorner) {
            addedWall.length = Double(currentWall.position.y) + materialThickness/2
        } else if (currentWall.innerPlane == WallType.largeCorner && addedWall.innerPlane == WallType.longCorner) {
            addedWall.length = Double(currentWall.position.y) + materialThickness/2
        }
    }
    private func adjustAllIntersections() {
        /// If internal intersecting walls, their dimensions should be updated.
        for intersecting in self.intersectingWalls.keys {
            for intersected in self.intersectingWalls[intersecting]! {
                adjustForIntersection(intersected, intersecting)
            }
        }
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
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        walls = try values.decode(Dictionary.self, forKey: .walls)
        intersectingWalls = try values.decode(Dictionary.self, forKey: .intersectingWalls)
        boxWidth = try values.decode(Double.self,forKey: .boxWidth)
        boxLength = try values.decode(Double.self, forKey: .boxLength)
        boxHeight = try values.decode(Double.self,forKey: .boxHeight)
        materialThickness = try values.decode(Double.self, forKey: .materialThickness)
        numberTabs = try values.decode(Double.self, forKey: .numberTabs)
        innerDimensions = try values.decode(Bool.self, forKey: .innerDimensions)
        joinType = try values.decode(JoinType.self, forKey: .joinType)
        BoxModel.wallNumberStatic = try values.decode(Int.self, forKey: .wallNumberStatic)
        sceneGenerator.generateScene(self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(walls,forKey: .walls)
        try container.encode(intersectingWalls,forKey: .intersectingWalls)
        try container.encode(boxWidth,forKey: .boxWidth)
        try container.encode(boxLength,forKey: .boxLength)
        try container.encode(boxHeight,forKey: .boxHeight)
        try container.encode(materialThickness,forKey: .materialThickness)
        try container.encode(numberTabs,forKey: .numberTabs)
        try container.encode(innerDimensions,forKey: .innerDimensions)
        try container.encode(joinType,forKey: .joinType)
        try container.encode(BoxModel.wallNumberStatic,forKey: .wallNumberStatic)
        
    }
    enum CodingKeys: CodingKey {
        case walls
        case intersectingWalls
        case boxWidth
        case boxLength
        case boxHeight
        case materialThickness
        case numberTabs
        case innerDimensions
        case joinType
        case wallNumberStatic
        
    }
}



