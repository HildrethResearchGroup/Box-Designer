import Foundation
import Cocoa
/**
 This class provides a protocol for the allowed cutout shapes. This means that the types of cutout shapes can be easily extended in the future.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: Shape.swift was created on 11/13/2020.
 */
class Shape : Codable {
    var xRadius : CGFloat
    var yRadius : CGFloat
    var areaRectangle : NSRect
    var type : ShapeType
    init (_ rect: NSRect, _ type : ShapeType, _ xRad : CGFloat = 0.0, _ yRad : CGFloat = 0.0) {
        self.areaRectangle = rect
        self.type = type
        self.xRadius = xRad
        self.yRadius = yRad
    }
    func draw(_ path: NSBezierPath) {
        fatalError("Subclasses needed to implement the 'draw()' method.")
    }
}
