import Foundation
import Cocoa
import SceneKit
/**
 This class provides the structure for the complete box model. It can encode and decode itself in order to a save a box template and reopen it in the app, and it deals with all intersecting wall issues (as well as general maintenance when user changes features in the app).
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxModel.swift was created on 6/6/2020.
 
 */
class BoxModel : Codable {
    
    /// This variable ensures the current box model has access to the scene, so that it can update the scene after updating its attributes.
    let sceneGenerator = SceneGenerator.shared
    /// This variable is a dictionary of all the current walls that make up the box model. Its key is the wall number (a global variable), and its value is the associated wall. This data structure helps associate user-selected nodes in the application and their associated walls, as the nodes have the same name as the wall they are made from (see SceneGenerator.swift).
    var walls: Dictionary<Int,WallModel>
    /// This variable contains the pairs of intersecting walls in the box model (for internal separator dimension adjustments). The key is the wall that needs to adjust according to the walls in its value array. Put another way: the key is the intersecting wall, and its values are the walls it's intersecting. Note: intersecting wall handling is done in chronological order of when the user adds internal walls.
    var intersectingWalls = Dictionary<WallModel,[WallModel]>()
    /// This variable refers to the box dimension along the x-axis. Adjusting it changes the width of walls on the Y-Z and X-Z plane and the position of walls on the X-Y plane.
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
                    if (wall.wallType == WallType.topSide || wall.wallType == WallType.bottomSide) {
                        wall.width = boxWidth
                    } else if (wall.innerWall && wall.innerPlane == WallType.longCorner) {
                        /// If internal wall, change position according to its previous placement.
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
            /// Update the dimensions of intersecting walls after changing box width. Scene is generated in this function to reflect changes.
            self.adjustAllIntersections()
        }
    }
    /// This variable refers to the box dimension along the z-axis. Adjusting it changes the length of walls on the X-Z and Y-Z planes and the position of walls on the X-Y plane.
    var boxLength: Double {
        /// This updates the box length. If user wants their inputted box length to be the inner dimensions, box length is updated accordingly.
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
                    if (wall.wallType == WallType.topSide || wall.wallType == WallType.bottomSide || (wall.innerWall && wall.innerPlane == WallType.topSide || wall.innerPlane == WallType.bottomSide)) {
                        wall.length = boxLength
                    } else if (wall.innerWall && wall.innerPlane == WallType.smallCorner){
                        /// If internal wall, change position according to its previous placement.
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
                /// Update the dimensions of intersecting walls after changing box length. Scene is generated in this function to reflect changes.
                self.adjustAllIntersections()
            }
        }
    }
    /// This variable refers to the  box dimension along the y-axis. Adjusting it changes the length of walls on the X-Y and Y-Z planes and the position of walls on the X-Z plane.
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
                    if (wall.wallType == WallType.topSide || wall.wallType == WallType.bottomSide) {
                        if SCNVector3EqualToVector3(wall.position, SCNVector3Make(0.0, CGFloat(oldValue - materialThickness/2), 0.0)) {
                            wall.position = SCNVector3Make(0.0, CGFloat(boxHeight - materialThickness/2), 0.0)
                        }
                    } else if (wall.innerWall && (wall.innerPlane == WallType.topSide || wall.innerPlane == WallType.bottomSide)){
                        let originalPlacement = wall.position.y/CGFloat(oldValue)
                        wall.position = SCNVector3Make(0.0, CGFloat(Double(originalPlacement)*boxHeight), 0.0)
                    }else if (wall.wallType == WallType.smallCorner) {
                        wall.length = boxHeight
                    } else if (wall.wallType == WallType.longCorner) {
                        wall.length = boxHeight
                    }
                }
                /// Update the dimensions of intersecting walls.
                self.adjustAllIntersections()
                /// Update the dimensions of intersecting walls after changing box height. Scene is generated in this function to reflect changes.
            }
        }
    }
    /// This variable refers to the material thickness. The material thickness is necessary for drawing the components the correct size on the PDF, to ensure the components fit together without spaces or overhangs. Adjusting it changes the length or width of intersecting walls, which is dependent on what plane they are on and the plane of the intersected wall.
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
                /// Update the dimensions of intersecting walls after changing material thickness. Scene is generated in this function to reflect changes.
                self.adjustAllIntersections()
            }
        }
    }
    /// This variable indicates whether the current width, height, and length of the box model should indicate 1) only the space between components (true) or 2) the space between components, along with the walls themselves (false).
    var innerDimensions: Bool {
        /// This adjusts the box length, height, and width if the user wants those values to indicate the inner dimensions instead of the total dimensions.
        willSet {
            if innerDimensions != newValue {
                if newValue {
                    /// When changing TO innerdimensions,  manually add the extra length to each dimension BEFORE switching. Future changes will be adjusted by the dimensions themselves.
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
                    /// When changing FROM innerDimensions, manually remove the extra length  from each dimension AFTER switching. Future changes will not need or receive any adjustment.
                    self.boxLength -= 2 * materialThickness
                    self.boxWidth -= 2 * materialThickness
                    self.boxHeight -= 2 * materialThickness
                    
                    /// Make sure the scene updates after changes.
                    sceneGenerator.generateScene(self)
                }
            }
        }
    }
    /// This variable indicates the join type between walls (tab, overlap, or slotted). Internal separators are always JoinType.overlap, which is dealt with in WallModel.swift, as well as the path generation for all walls when their JoinType changes..
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
    /// This variable indicates the number of tabs that the user wants, if the join type is "tab." The minimum is 3, due to how PathGeneration.swift generates tab paths.
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
    
    /// This global variable allows the walls and their nodes be associated without worrying about index changes after a wall is deleted from self.walls -- the node is named the same as the wall when they are instantiated in SceneGenerator. This helps with organizing and deleting walls. It also associates the user's selection with the WallModel class. It is a global variable so that walls can get a unique identifier each time one is instantiated.
    static var wallNumberStatic = 0
    /// This initializer creates the default box model which is loaded whenever the application is launched.
    init() {
        
        /// initialize default values first so that they can be easily changed if you want to change the default
        self.boxWidth = 4.0
        self.boxLength = 4.0
        self.boxHeight = 4.0
        self.materialThickness = 0.50
        self.numberTabs = 3
        self.innerDimensions = false
        self.joinType = JoinType.overlap
        
        /// create variables for positioning the walls (because it's initially a box, offset2 could use the height, length, or width to create positions)
        /// if the default model is not a cube, this will not work
        let offset1 = materialThickness/2
        let offset2 = self.boxWidth - materialThickness/2
        
        /// create the initial walls for viewing; global variable wallNumberStatic is incremented in WallModel init()
        
        let wallBottom = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.bottomSide, joinType, SCNVector3Make(0.0, CGFloat(offset1), 0.0), numberTabs: numberTabs)
        let wallLeft = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset1), 0.0, 0.0), numberTabs: numberTabs)
        let wallRight = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.longCorner, joinType, SCNVector3Make(CGFloat(offset2), 0.0, 0.0), numberTabs: numberTabs)
        let wallFront = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset1)), numberTabs: numberTabs)
        let wallBack = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset2)), numberTabs: numberTabs)
        let wallLid = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.topSide, joinType, SCNVector3Make(0.0, CGFloat(offset2), 0.0), numberTabs: numberTabs)
        
        /// add walls to dictionary
        self.walls = [wallBottom.getWallNumber() : wallBottom,wallLeft.getWallNumber() : wallLeft, wallRight.getWallNumber() : wallRight, wallFront.getWallNumber() : wallFront, wallBack.getWallNumber() : wallBack, wallLid.getWallNumber() : wallLid]
    }
    /**
    This function adds a wall to the box model according to type (internal or external wall), plane (X-Y, Y-Z, X-Z; these are synonmous with WallType), and placement (how far from the origin do you want the wall to be placed? This is a fraction. Note: for external walls, it only make sense for them to be 0 or 1 so that they get placed on the outside).
     - Parameters:
        - inner: this is a boolean value that dictates whether the added wall should be an internal separator or an external wall.
        - type: although this is WallType type, this indicates the plane the added wall should be oriented on.
        - placement: this is a fraction that indicates where the wall should be positioned -- the position is calculated by (placement)*(dimension corresponding to correct axis)
    */
    func addWall(inner: Bool, type: WallType, placement: Double) {
        /// dummy wall to be changed
        var newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.topSide, joinType, SCNVector3Make(0.0, CGFloat(0.0), 0.0), numberTabs: numberTabs)
        if inner {
            /// add internal separators
            switch (type) {
            case WallType.topSide, WallType.bottomSide:
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, CGFloat(placement*boxHeight), 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.longCorner:
                newWall = WallModel(BoxModel.wallNumberStatic,boxLength, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(CGFloat(placement*boxWidth), 0.0, 0.0), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            case WallType.smallCorner:
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxHeight, materialThickness, WallType.smallCorner, JoinType.overlap, SCNVector3Make(0.0, 0.0, CGFloat(placement*boxLength)), numberTabs: numberTabs, innerWall : true, innerPlane: type)
            }
            /// if other inner walls that would intersect, deal with that; this is where the chronology of adding walls comes into play for intersections, as the for loop iterates from older added internal walls to newer added internal walls and makes comparisons
            for wall in walls.values {
                if wall.innerWall && !SCNVector3EqualToVector3(wall.position, newWall.position) && wall.innerPlane != newWall.innerPlane {
                    /// add entry to intersecting walls dictionary
                    if intersectingWalls[newWall] == nil {
                        intersectingWalls[newWall] = [wall]
                    } else {intersectingWalls[newWall]?.append(wall)}
                }
            }
        } else {
            /// add external walls; 1 means furthest from the origin, 0 means starting at the origin. Offsets account for material thickness -- the extrusion when making the 3D wall is +/- materialThickness/2 (see SceneGenerator.generateScene()).
            var offset3 = 0.0
            
            switch (type) {
            case WallType.topSide, WallType.bottomSide:
                placement == 1.0 ? (offset3 = self.boxHeight - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxLength, materialThickness, type, self.joinType, SCNVector3Make(0.0, CGFloat(offset3), 0.0), numberTabs: numberTabs)
            case WallType.longCorner:
                placement == 1.0 ? (offset3 = self.boxWidth - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxLength, boxHeight, materialThickness, type, self.joinType, SCNVector3Make(CGFloat(offset3), 0.0, 0.0), numberTabs: numberTabs)
            case WallType.smallCorner:
                placement == 1.0 ? (offset3 = self.boxLength - materialThickness/2) : (offset3 = materialThickness/2)
                newWall = WallModel(BoxModel.wallNumberStatic,boxWidth, boxHeight, materialThickness, type, self.joinType, SCNVector3Make(0.0, 0.0, CGFloat(offset3)), numberTabs: numberTabs)
            }
        }
        /// if wall is already in same place, don't add it
        for wall in self.walls.values {
            if SCNVector3EqualToVector3(wall.position, newWall.position) {return}
        }
        /// Otherwise, adjust dimensions for intersectiions, if any, and add to the walls dictionary.
        self.walls[newWall.getWallNumber()] = newWall
        self.adjustAllIntersections()
        
    }
    /**
     This function deals with the situation where an intersected wall is deleted from the box model, so the intersectingWalls dictionary needs to be updated.
     */
    func updateIntersectingWalls() {
        /// If internal intersecting walls are deleted, the dictionary should be updated.
        for intersecting in self.intersectingWalls.keys {
            /// If intersecting wall is deleted, set its values to nil.
            if self.walls[intersecting.getWallNumber()] == nil {
                self.intersectingWalls[intersecting] = nil
                
            } else {
                for (index,intersected) in self.intersectingWalls[intersecting]!.enumerated() {
                    /// remove an intersected wall from the value array for an associated intersecting wall, if it's deleted
                    if self.walls[intersected.getWallNumber()] == nil {
                        if index < self.intersectingWalls[intersecting]!.count {
                            self.intersectingWalls[intersecting]!.remove(at: index)}
                    }
                }
            }
        }
        /// adjust dimensions for new intersecting wall dictionary
        self.adjustAllIntersections()
    }
    /**
     This function adjusts two intersecting walls depending on 1) which one is being intersected and 2) which planes they are no (in order to correct the right dimension for the intersecting wall's plane).
     - Parameters:
        - currentWall: This is the wall that was already in the box model and would be intersected by the new wall without dimension adjustment.
        - addedWall: This is the new wall that is being added to the box model and must adjust its dimensions according to the wall it would intersect.
     - Note: There is probably a better, more dynamic way to deal with wall intersection. However, SCNHitTestResult does not find the intersecting between two nodes, unless they are SCNPhysicsBody objects (and I'm not sure that would work, as our nodes don't have an associated physicsBody property). I also tried to use the hit test between a segment (vector) and a node, but I was never able to get a result from a hit test, even when I knew two walls were going to intersect. There's probably a way to do it, but we ran out of time.
     */
    private func adjustForIntersection(_ currentWall: WallModel, _ addedWall : WallModel) {
        /// These adjustments take into account that, even though two internal walls are on separate planes, they might not necessarily intersect (if the old wall is already adjusted to accomadate an intersection, the new wall might not intersect it).
        if (currentWall.innerPlane == WallType.longCorner && addedWall.innerPlane == WallType.smallCorner) {
            if currentWall.width > Double(addedWall.position.z) {addedWall.width = Double(currentWall.position.x) + materialThickness/2}
        } else if (currentWall.innerPlane == WallType.longCorner && WallType.topSide || addedWall.innerPlane == WallType.bottomSide) {
            if currentWall.length > Double(addedWall.position.y) {addedWall.width = Double(currentWall.position.x) + materialThickness/2}
        } else if (currentWall.innerPlane == WallType.smallCorner && addedWall.innerPlane == WallType.longCorner) {
            if currentWall.width > Double(addedWall.position.x) {addedWall.width = Double(currentWall.position.z) + materialThickness/2}
        } else if (currentWall.innerPlane == WallType.smallCorner && WallType.topSide || addedWall.innerPlane == WallType.bottomSide) {
            if currentWall.length > Double(addedWall.position.y) {addedWall.length = Double(currentWall.position.z) + materialThickness/2}
        } else if (currentWall.innerPlane == WallType.topSide || currentWall.innerPlane == WallType.bottomSide && addedWall.innerPlane == WallType.smallCorner) {
            if currentWall.length > Double(addedWall.position.z) {addedWall.length = Double(currentWall.position.y) + materialThickness/2}
        } else if (currentWall.innerPlane == WallType.topSide || currentWall.innerPlane == WallType.bottomSide && addedWall.innerPlane == WallType.longCorner) {
            if currentWall.width > Double(addedWall.position.x) {addedWall.length = Double(currentWall.position.y) + materialThickness/2}
        }
    }
    /**
     This function simply iterates through the intersectingWalls dictionary and adjusts dimensions accordingly -- mainly used for when the box's attributes change from user input.
     */
    private func adjustAllIntersections() {
        /// If internal intersecting walls, their dimensions should be updated.
        for intersecting in self.intersectingWalls.keys {
            for intersected in self.intersectingWalls[intersecting]! {
                adjustForIntersection(intersected, intersecting)
                
            }
        }
        sceneGenerator.generateScene(self)
    }
    /**
    This initializer is used to decode the Data from a user-selected JSON by using its CodingKeys. It is necessary for BoxModel to conform to Codable (specifically, Decodable protocol).
     - Parameters:
        - decoder: this will be the JSONDecoder() initialized in FileHandlingControl when user tries to open a saved BoxModel.
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
    /**
     This function enables BoxModel to conform to Codable (specifically, the Encodable protocol). It outputs Data, which is then converted to a string and saved at specific location (see FileHandlingControl.swift).
     */
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
    /**
     This enum allows BoxModel to be encoded and decoded without needing to encode/decode all its variables -- specifically, the sceneGenerator variable does not need to be saved, as it would be a little harder to make SceneGenerator conform to Codable, and it's not necessary anyway. The "cases" are simply the variables you want to be encoded/decoded.
     */
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



