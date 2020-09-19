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
    
    
    init(_ path: NSBezierPath,_ lineThickness: CGFloat){
        self.lineThickness = lineThickness
        self.path = path
        self._getLines()
        
    }
    
    private var lineThickness: CGFloat
    private var path: NSBezierPath
    private var lines:[Line] = []
    
    let insidePath = NSBezierPath()
    let outsidePath = NSBezierPath()
    let grandPath = NSBezierPath()
    
    private func _getLines(){
        var pointArray:[NSPoint] = []
        
        let point: NSPointPointer = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        //gets the points in a path
        for x in 0...(path.elementCount-1){
            path.element(at: x, associatedPoints: point)
            pointArray.append(point[0])
        }
        //cretes line array
        for x in 0...(pointArray.count - 2){
            if(pointArray[x] != pointArray[x+1]){
                var tempLine = Line(pointArray[x], pointArray[x+1], thickness: self.lineThickness)
                if(!tempLine.point()){
                    lines.append(tempLine)
                    print(tempLine)
                }
                
            }
        }
        let insidePath = NSBezierPath()
        let outsidePath = NSBezierPath()
        
        for idvLine in lines{
            var topLeft: NSPoint
            var bottomLeft: NSPoint
            var topRight: NSPoint
            var bottomRight: NSPoint
            
            // 0 is left and 1 is right
            let centerPoints:[NSPoint] = idvLine.returnTestPoints(linePos.center)
            
            
            //================ Top Point ===================
            var squarePoints:[NSPoint] = idvLine.returnTestPoints(linePos.top)
            //test left side
            var inside = path.contains(centerPoints[0])
            if(inside == path.contains(squarePoints[0])){
                topLeft = squarePoints[0]
            }else{
                topLeft = squarePoints[1]
            }
            //test right side
            inside = path.contains(centerPoints[1])
            if(inside == path.contains(squarePoints[3])){
                topRight = squarePoints[3]
            }else{
                topRight = squarePoints[2]
            }
            
            //============= Bottom Point =================
            squarePoints = idvLine.returnTestPoints(linePos.bottom)
            //test left side
            inside = path.contains(centerPoints[0])
            if(inside == path.contains(squarePoints[0])){
                bottomLeft = squarePoints[0]
            }else{
                bottomLeft = squarePoints[1]
            }
            //test right side
            inside = path.contains(centerPoints[1])
            if(inside == path.contains(squarePoints[3])){
                bottomRight = squarePoints[3]
            }else{
                bottomRight = squarePoints[2]
            }
            
            if(bottomLeft == NSMakePoint(-0.028, 0.361) || bottomRight == NSMakePoint(-0.028, 0.361) || topLeft == NSMakePoint(-0.028, 0.361) || topRight == NSMakePoint(-0.028, 0.361)){
                print("hit")
            }
            
            if(path.contains(centerPoints[0])){
                //left inside
                if(insidePath.isEmpty){
                    insidePath.move(to: bottomLeft)
                }else if(insidePath.currentPoint != bottomLeft){
                    //not empty
                    insidePath.line(to: bottomLeft)
                }
                //right outdside
                if(outsidePath.isEmpty){
                    outsidePath.line(to: bottomRight)
                }else if(outsidePath.currentPoint != bottomRight){
                    //not empty
                    outsidePath.line(to: bottomRight)
                }
                outsidePath.line(to: topRight)
                insidePath.line(to: topLeft)

            }else{
                //right inside
                if(insidePath.isEmpty){
                    insidePath.move(to: bottomRight)
                }else if(insidePath.currentPoint != bottomRight){
                    //not empty
                    insidePath.line(to: bottomRight)
                }
                //left outside
                if(outsidePath.isEmpty){
                    outsidePath.move(to: bottomLeft)
                }else if(outsidePath.currentPoint != bottomLeft){
                    //not empty
                    outsidePath.line(to: bottomLeft)
                }
                outsidePath.line(to: topLeft)
                insidePath.line(to: topRight)
            }
            
            
        }
        for x in 0...(outsidePath.elementCount-1){
            outsidePath.element(at: x, associatedPoints: point)
            print(point[0])
        }
        
        grandPath.append(insidePath)
        grandPath.append(outsidePath)
        shape = SCNShape(path: grandPath, extrusionDepth: 0.0001)
    }
    
    var shape: SCNShape = SCNShape()
    
}

