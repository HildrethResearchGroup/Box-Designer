//
//  Ray.swift
//  Box Designer
//
//  Created by Michael Berg on 9/24/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

class Ray{
    init(_ basePoint:NSPoint, _ angle:CGFloat){
        self.basePoint = basePoint
        self.angle = angle
    }
    
    //the angle is based of the x axis going counter clockwise
    func generatePoint(distance: CGFloat)->NSPoint{
        return NSMakePoint(basePoint.x + distance*cos(angle), basePoint.y + distance*sin(angle))
    }
    
    func flipAngle(){
        angle += CGFloat.pi
        if(angle >= 2*CGFloat.pi){ angle -= 2*CGFloat.pi }
    }
    
    private var angle: CGFloat
    private let basePoint:NSPoint
}
