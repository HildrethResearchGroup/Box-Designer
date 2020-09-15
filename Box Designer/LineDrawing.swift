//
//  LineDrawing.swift
//  Box Designer
//
//  Created by Michael Berg on 9/15/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

class LineDrawing{
    //this class is intended to make 3d shapes from paths
    //this will not work with paths with curves
    
    init(_ path: NSBezierPath){
        self.path = path
        self._getLines()
    }
    
    private var path: NSBezierPath
    
    
    private func _getLines(){
        var pointArray:[NSPoint] = []
        
        let point: NSPointPointer = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        for x in 0...(path.elementCount-1){
            path.element(at: x, associatedPoints: point)
            pointArray.append(point[0])
        }
        print(pointArray)
    }
    
    var shape: SCNShape = SCNShape()
    
}
