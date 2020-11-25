import Foundation
import Cocoa
/**
 This class provides the possible cutouts as an enum. It is necessary for WallModel.wallShapes' [Shape] to conform to the Decodable protocol. It can also be easily extended to add more cutout shapes.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: ShapeType.swift was created on 11/13/2020.
 */

enum ShapeType : String, Codable{
    /// This is the circle cutout shape.
    case circle
    /// This is the rectangle cutout shape.
    case rectangle
    /// This is the rounded rectangle cutout shape.
    case roundedRectangle
}
