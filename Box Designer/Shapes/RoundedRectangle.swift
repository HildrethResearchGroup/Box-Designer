import Foundation
import Cocoa
/**
 This class provides the structure and path appending for the rounded rectangle cutouts.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: RoundedRectangle.swift was created on 11/13/2020.
 */
class RoundedRectangle : Shape {
    
    override init(_ rect : NSRect, _ type : ShapeType, _ xRad : CGFloat, _ yRad : CGFloat) {
        super.init(rect,type, xRad, yRad)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func draw(_ path : NSBezierPath) {
        path.appendRoundedRect(super.areaRectangle, xRadius: CGFloat(self.xRadius), yRadius: CGFloat(self.yRadius))
    }
}
