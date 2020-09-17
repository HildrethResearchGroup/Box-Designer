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
        self._doThing(self._getLines())
    }
    
    private var path: NSBezierPath
    
    private var insidePath = NSBezierPath()
    private var outsidePath = NSBezierPath()
          
    var linePath = NSBezierPath()
  
    private func _getLines()->[Line]{
        var lines: [Line] = []
        var pointArray:[NSPoint] = []
        
        let point: NSPointPointer = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        for x in 0...(path.elementCount-1){
            path.element(at: x, associatedPoints: point)
            pointArray.append(point[0])
        }
        for x in 0...(path.elementCount-2){
            let line = Line(pointArray[x+1], pointArray[x])
            if(!line.point()){
                lines.append(line)
            }
        }
        print(lines)
        return lines
    }
    
    private func _doThing(_ lines:[Line]){
        for invLine in lines{
            var topLeft:NSPoint
            var bottomLeft:NSPoint
            var topRight:NSPoint
            var bottomRight:NSPoint
            //find the points to use on the left
            
        linePath.append(self.insidePath)
        //linePath.append(self.outsidePath)
        
        let point: NSPointPointer = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        print(lines)
        for x in 0...(insidePath.elementCount-1){
            insidePath.element(at: x, associatedPoints: point)
            print("inside: ", point[0])
        }
        //for x in 0...(outsidePath.elementCount-1){
        //   outsidePath.element(at: x, associatedPoints: point)
        //   print("outside: ", point[0])
        //}
    }
    
    func generateShape()->SCNShape{
        return SCNShape(path: linePath, extrusionDepth: 0.001)
    }
    
}
