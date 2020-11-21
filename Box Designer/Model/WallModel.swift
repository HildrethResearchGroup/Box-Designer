import Foundation
import Cocoa
import SceneKit.SCNGeometry
/**
 This class provides the structure a single wall in the box model.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: WallModel.swift was created on 6/6/2020.
 */
class WallModel : Equatable, Codable {
    /// Add equality functionality to walls.
    static func == (lhs: WallModel, rhs: WallModel) -> Bool {
        /// For our purposes, a wall is "equal" to another if it's in the same position. This function must be implemented for WallModel to be Hashable for a Dictionary.
        if SCNVector3EqualToVector3(lhs.position, rhs.position) {
            return true
        } else {return false}
    }
    
    /// This variable indicates the key of a wall  in the BoxModel.walls dictionary -- it is intended to be the name of a wall.
    private let wallNumber : Int
    /*
     These attributes are those strictly necessary for
     1) drawing the wall's outline as a pdf
     2) displaying the wall within a SCNView
    */
    /// This variable is essentially the wall in vector form.
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
                // inner walls should never have tabs
                if innerWall {joinType = JoinType.overlap}
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
    /// This variable indicates if the wall is an internal separator, as these should never be JoinType.tab
    var innerWall: Bool
    /// This variable indicates the plane that the inner wall should be oriented on -- the WallTypes are associated with planes (see WallType.swift).
    var innerPlane : WallType
    
    /// This function sets the wall's path from the return of PathGenerator's generatePath function, using its self-updating variables.
    private func updatePath(){
        self.path = PathGenerator.generatePath(self.width, self.length, self.materialThickness, self.wallType, self.joinType, numberTabs: self.numberTabs)
    }
    
    /// This function returns the wall number of itself.
    func getWallNumber() -> Int {
        return self.wallNumber
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
    init(_ wallNumber: Int,_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, _ position: SCNVector3, numberTabs: Double?, innerWall : Bool = false, innerPlane : WallType = WallType.smallCorner) {
        self.width = width
        self.length = length
        self.materialThickness = materialThickness
        self.wallType = wallType
        self.joinType = joinType
        self.numberTabs = numberTabs
        self.position = position
        self.path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, numberTabs: numberTabs)
        self.wallNumber = wallNumber
        self.innerWall = innerWall
        self.innerPlane = innerPlane
        BoxModel.wallNumberStatic += 1
    }
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
        path = PathGenerator.generatePath(width, length, materialThickness, wallType, joinType, numberTabs: numberTabs)
    }
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
    }
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
    }
}
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
extension WallModel : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}


