import Foundation

/**
 This class provides and enum for the allowed shapes.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: ShapeType.swift was created on 11/13/2020.
 */
enum ShapeType : String, Codable {
    /// This is a simple circle, will be drawn with NSBezierPath.appendOval().
    case circle = "circle"
    /// This is a rounded rectangle, will be drawn with NSBezierPath.appendRoundedRect().
    case roundedRectangle = "roundedRectangle"
    /// This is a simple rectangle, will be drawn with NSBezierPath.appendRect().
    case rectangle = "rectangle"
}
