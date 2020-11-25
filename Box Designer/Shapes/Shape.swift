import Foundation
import Cocoa
/**
 This class provides an abstract-like class for the allowed cutout shapes. This set up enables the types of cutout shapes to be easily extended in the future. Note: although it's usually better to use protocols as a substitute for abstract classes in Swift, protocols cannot conform to Codable. Therefore, this class was used.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: Shape.swift was created on 11/13/2020.
 */
class Shape : Codable {
    /// This is the x-radius for the rounded radius for rounded rectangle shapes.
    var xRadius : CGFloat
    /// This is the y-radius for the rounded radius for rounded rectangle shapes.
    var yRadius : CGFloat
    /// This is the rectangle that describes the boundaries for the different cut out shapes.
    var areaRectangle : NSRect
    /// This is the type of shape. It is necessary for decoding the cutout shapes from a JSON correctly -- because WallModel has a [Shape] array, and this class is supposed to emulate an abstract class, the NSBezierPaths would not be able to draw without specifying the type of shape that was saved (see the draw() function below and the overridden draw() functions in Shape's child classes.
    var type : ShapeType
    /**
     This initializer instantiates a Codable-conforming Shape cutout.
     - Parameters:
        - rect : the rectangle that specifies that boundaries for the cutout
        - type : the type of shape that is being instantiated
        - xRad : the x-radius for roundness in a rounded rectangle cutout
        - yRad : the y-radius for roundness in a rounded rectangle cutout
     */
    init (_ rect: NSRect, _ type : ShapeType, _ xRad : CGFloat = 0.0, _ yRad : CGFloat = 0.0) {
        self.areaRectangle = rect
        self.type = type
        self.xRadius = xRad
        self.yRadius = yRad
    }
    /**
     This is an abstract function. The children of the Shape class will draw their own NSBezierPaths onto the wall.
     - Parameters :
        - path : this is the NSBezierPath that the children of the Shape class append themselves too -- it is the path of the wall that they're being cut out on
     */
    func draw(_ path: NSBezierPath) {
        fatalError("Subclasses needed to implement the 'draw()' method.")
    }
}
