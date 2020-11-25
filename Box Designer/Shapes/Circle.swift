import Foundation
import Cocoa
/**
 This class provides the structure and path-appending for the circle cutouts.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: Circle.swift was created on 11/13/2020.
 */
class Circle : Shape {
    
    /**
     This initializer instantiates a Codable-conforming circle cutout.
     - Parameters:
        - rect : the rectangle that specifies that boundaries for the cutout
        - type : the type of shape that is being instantiated
        - xRad : the x-radius for roundness in a rounded rectangle cutout (default of 0 for retangles)
        - yRad : the y-radius for roundness in a rounded rectangle cutout (default of 0 for rectangles)
     */
    override init(_ rect : NSRect, _ type : ShapeType, _ xRad : CGFloat = 0.0, _ yRad : CGFloat = 0.0) {
        super.init(rect,type,xRad,yRad)
    }
    /**
     This is just the required initializer due to Circle's parent conforming to Codable.
     - Parameters :
        - decoder : for our purposes, this will always be a JSONDecoder()
     */
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    /**
     This function appends a circle to the given NSBezierPath.
     - Parameters :
        - path : this is the NSBezierPath of the wall that a circle is being cut out from
     */
    override func draw(_ path : NSBezierPath) {
        path.appendOval(in: self.areaRectangle)
    }
}
