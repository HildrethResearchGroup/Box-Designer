import Foundation
import Cocoa
import SceneKit.SCNGeometry
/**
 This class provides the structure for a single wall in the box model.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: WallModel.swift was created on 6/6/2020.
 */
class WallModel : Equatable, Codable {
    
    /// This variable indicates the key of a wall in the BoxModel.walls dictionary -- it is intended to be the name of a wall.
    private let wallNumber : Int
    /*
     These attributes are those strictly necessary for
     1) drawing the wall's outline as a pdf
     2) displaying the wall within a SCNView
    */
    /// This variable is essentially the wall in multi-vector form.
    var path: NSBezierPath
    /// This variable is an array that includes all the cut out shapes on itself (the wall). While there isn't functionality for deleting cutouts yet, this structure should make adding that functionality somewhat easy.
    var wallShapes = [Shape]()
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
    
    /** For largeCorner and smallCorner wall types, this variable is associated with BoxModel.boxWidth. For longCorner wall type, this variable is associated with BoxModel.boxLength.
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
    /** For longCorner and smallCorner wall types, this variable is associated with BoxModel.boxHeight. For largeCorner wall type, this variable is associated with BoxModel.boxLength.
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
    /// This variable indicates the type of wall (necessary for how the path is drawn). Internal walls should only be WallType.smallCorner (they should be overlapped by all other walls).
    var wallType: WallType
    /// This variable indicates the type of join (tab, overlap, or slotted). It accounts for the fact that internal walls should only be JoinType.overlap.
    var joinType: JoinType {
        didSet {
            if joinType != oldValue {
                /// inner walls should never have tabs
                if innerWall {joinType = JoinType.overlap}
                updatePath()
            }
        }
    }
    /// This variable indicates the number of tabs the user wants if the joinType == WallType.join.  The type of wall changes how the tabs are drawn.
    var numberTabs: Double? {
        didSet {
            if numberTabs != oldValue {
                updatePath()
            }
        }
    }
    /// This variable indicates if the wall is an internal separator, as these should never be JoinType.tab and should always be WallType.smallCorner.
    var innerWall: Bool
    /// This variable indicates the plane that the inner wall should be oriented on -- the WallTypes are associated with planes (see WallType.swift).
    var innerPlane : WallType
    
    /// This variable determines if the selected wall should have a handle or not on it
    var handle : Bool {
        didSet {
            if handle != oldValue {
                updatePath()
            }
        }
    }
    
    /// This function sets the wall's path from the return of PathGenerator's generatePath function, using its self-updating variables.
    func updatePath(){
        self.path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, numberTabs: self.numberTabs, handle: self.handle,self.wallShapes)
        
        for (index,shape) in wallShapes.enumerated() {
            /// If cutout lies outside the updated box, remove it
            if (shape.areaRectangle.minX + shape.areaRectangle.width == self.path.bounds.maxX) || (shape.areaRectangle.minY + shape.areaRectangle.height == self.path.bounds.maxY) {
                wallShapes.remove(at: index)
                updatePath()
            }
        }
    }
    
    /// This function returns the wall number of itself, as it's a private variable.
    func getWallNumber() -> Int {
        return self.wallNumber
    }
    /**
     This function makes WallModel conform to the Equatable protocol. For our purposes, a wall is "equal" to another if it's in the same position. This function must be implemented for WallModel to be Hashable for a Dictionary (like BoxModel.walls and BoxModel.intersectinWalls.
     */
    static func == (lhs: WallModel, rhs: WallModel) -> Bool {
        
        if SCNVector3EqualToVector3(lhs.position, rhs.position) {
            return true
        } else {return false}
    }
    /**
     This initializer creates a wall from its parameters. It also increments BoxModel.wallNumberStatic so that each new wall in the model is guaranteed to have a unique ID.
    - Note: The wall does not need a third dimension, as (for a single wall), the third dimension is technically material thickness (which is dealt with in SceneGenerator when the wall is converted to SCNNode and extruded.
     - Parameters:
        - wallNumber: this is the unique ID of the wall, determined by BoxModel.wallNumberStatic
        - width: this is the wall's width (not neccesarily box's width, see WallModel.width for info)
        - length: this is the wall's length (not necessarily box's length, see WallModel.length for info)
        - materialThickness: this is the wall's material thickness
        - wallType: this is the type of wall (largeCorner, longCorner, or smallCorner)
        - joinType: this is the join type between walls
        - position: this is where the path of the wall starts
        - numberTabs: this is the number of tabs for the wall
        - innerWall: this is a boolean value indicated whether a wall is internal or external (default is false so that external walls don't need to input anything)
        - innerPlane: this is a WallType that indicates the plane an inner wall is oriented on (default is WallType.smallCorner so that external walls don't need to input anything)
     */
    init(_ wallNumber: Int,_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, _ position: SCNVector3, numberTabs: Double?, innerWall : Bool = false, innerPlane : WallType = WallType.smallCorner, handle: Bool = false) {
        self.width = width
        self.length = length
        self.materialThickness = materialThickness
        self.wallType = wallType
        self.joinType = joinType
        self.numberTabs = numberTabs
        self.position = position
        self.handle = false
        self.path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, numberTabs: numberTabs, handle: self.handle,self.wallShapes)
        self.wallNumber = wallNumber
        self.innerWall = innerWall
        self.innerPlane = innerPlane
        BoxModel.wallNumberStatic += 1
    }
    /**
    This initializer is used to decode the Data from a user-selected JSON by using its CodingKeys. It is necessary for WallModel to conform to Codable (specifically, Decodable protocol).
     - Parameters:
        - decoder: this will be the JSONDecoder() initialized in FileHandlingControl when user tries to open a saved BoxModel -- because WallModel is nested, it also needs to decode.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decode(Double.self,forKey: .width)
        length = try container.decode(Double.self, forKey: .length)
        wallType = try container.decode(WallType.self, forKey: .wallType)
        joinType = try container.decode(JoinType.self,forKey: .joinType)
        position = try container.decode(SCNVector3.self,forKey: .position)
        innerWall = try container.decode(Bool.self, forKey: .innerWall)
        innerPlane = try container.decode(WallType.self, forKey: .innerPlane)
        wallNumber = try container.decode(Int.self, forKey: .wallNumber)
        materialThickness = try container.decode(Double.self, forKey: .materialThickness)
        numberTabs = try container.decode(Double.self, forKey: .numberTabs)
        handle = try container.decode(Bool.self, forKey: .handle)
        wallShapes = try container.decode(Array.self, forKey: .wallShapes)
        /// necessary to instantiate the correct shape type so it draws correctly (when the shapes are decoded, they're of type "Shape," but Shape.draw() is abstract. Thus, the array needs to house only Circle, Rectangle, or RoundedRectangle objects)
        var wallShapesWithType = [Shape]()
        for shape in wallShapes {
            switch shape.type {
            case ShapeType.rectangle:
                wallShapesWithType.append(Rectangle(shape.areaRectangle,shape.type))
            case ShapeType.circle:
                wallShapesWithType.append(Circle(shape.areaRectangle,shape.type))
            case ShapeType.roundedRectangle:
                wallShapesWithType.append(RoundedRectangle(shape.areaRectangle,shape.type,shape.xRadius,shape.yRadius))
            }
        }
        wallShapes = wallShapesWithType
        /// Now generate the path, with the correct wallShapes array
        path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, numberTabs: numberTabs, handle: handle,wallShapes)
        
    }
    /**
     This function enables BoxModel to conform to Codable (specifically, the Encodable protocol). It outputs Data, which is then converted to a string and saved at specific location (see FileHandlingControl.swift).
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(length,forKey: .length)
        try container.encode(wallType,forKey: .wallType)
        try container.encode(joinType,forKey: .joinType)
        try container.encode(position,forKey: .position)
        try container.encode(innerWall,forKey: .innerWall)
        try container.encode(innerPlane,forKey: .innerPlane)
        try container.encode(wallNumber,forKey: .wallNumber)
        try container.encode(materialThickness,forKey: .materialThickness)
        try container.encode(numberTabs,forKey: .numberTabs)
        try container.encode(handle,forKey: .handle)
        try container.encode(wallShapes, forKey: .wallShapes)
    }
    /**
     This enum allows WallModel to be encoded and decoded without needing to encode/decode all its variables -- specifically, the path variable does not need to be saved, as it would be a little harder to make an NSBezierPath conform to Codable, and it's not necessary anyway. The path is simply generated when all the inputs to PathGenerator.generatePath() are decoded. The "cases" are the variables you want to be encoded/decoded.
     */
    enum CodingKeys : CodingKey {
        case width
        case length
        case wallType
        case joinType
        case position
        case innerWall
        case innerPlane
        case wallNumber
        case materialThickness
        case numberTabs
        case handle
        case wallShapes
    }
}
/**
 This enables the WallModel's position to be encoded and decoded, as it is a necessary piece of information when re-constructing a saved box template.
 */
extension SCNVector3: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init()
        self.x = try container.decode(CGFloat.self)
        self.y = try container.decode(CGFloat.self)
        self.z = try container.decode(CGFloat.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.x)
        try container.encode(self.y)
        try container.encode(self.z)
    }
}
/**
 This allows WallModel to conform to the Hashable protocol, which is necessary for the dictionary data structures in BoxModel that include WallModel as a key or value.
 */
extension WallModel : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}


