import Foundation
import SceneKit
import Cocoa
/**
 - TODO: documenting this class
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: Ray.swift was created on 9/24/2020.
 */
class Ray {
    /// - TODO:
    private var angle: CGFloat
    /// - TODO:
    private let basePoint:NSPoint
    /**
     - TODO:
     */
    init(_ basePoint:NSPoint, _ angle:CGFloat){
        self.basePoint = basePoint
        self.angle = angle
    }
    
    /**
     - TODO:
     - Note: the angle is based off the x axis going counter clockwise
     - Parameters:
        - distance:
     */
    func generatePoint(distance: CGFloat)->NSPoint{
        return NSMakePoint(basePoint.x + distance*cos(angle), basePoint.y + distance*sin(angle))
    }
    
    /**
     - TODO:
     */
    func flipAngle(){
        angle += CGFloat.pi
        if(angle >= 2*CGFloat.pi){ angle -= 2*CGFloat.pi }
    }
    
    
}
