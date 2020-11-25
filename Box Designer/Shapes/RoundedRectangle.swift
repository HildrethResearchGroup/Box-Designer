import Foundation
import Cocoa
/**
 This class provides the structure and path-appending for the rounded rectangle cutouts.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: RoundedRectangle.swift was created on 11/13/2020.
 */
class RoundedRectangle : Shape {
    /**
     This initializer instantiates a Codable-conforming rounded rectangle cutout.
     - Parameters:
        - rect : the rectangle that specifies that boundaries for the cutout
        - type : the type of shape that is being instantiated
        - xRad : the x-radius for roundness in a rounded rectangle cutout
        - yRad : the y-radius for roundness in a rounded rectangle cutout
     */
    override init(_ rect : NSRect, _ type : ShapeType, _ xRad : CGFloat, _ yRad : CGFloat) {
        super.init(rect,type, xRad, yRad)
    }
    /**
     This is just the required initializer due to RoundedRectangle's parent conforming to Codable.
     - Parameters :
        - decoder : for our purposes, this will always be a JSONDecoder()
     */
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    /**
     This function appends a rounded rectangle to the given NSBezierPath.
     - Parameters :
        - path : this is the NSBezierPath of the wall that a circle is being cut out from
     */
    override func draw(_ path : NSBezierPath) {
        path.appendRoundedRect(super.areaRectangle, xRadius: CGFloat(self.xRadius), yRadius: CGFloat(self.yRadius))
    }
}
