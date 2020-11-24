import Foundation
import Cocoa
/**
 This class provides the structure and path appending for the rectangle cutouts.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: Rectangle.swift was created on 11/13/2020.
 */
class Rectangle : Shape {
    
    override init(_ rect : NSRect, _ type : ShapeType, _ xRad : CGFloat = 0.0, _ yRad : CGFloat = 0.0) {
        super.init(rect,type,xRad,yRad)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func draw(_ path : NSBezierPath) {
        path.appendRect(self.areaRectangle)
    }
}
