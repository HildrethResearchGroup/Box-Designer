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
    
    
    init(_ path: NSBezierPath,_ lineThickness: CGFloat, insideLine:Bool = false){
        self.insideLine = insideLine
        self.lineThickness = lineThickness
        
        self.path = path
        self.updatePaths(self.getLines(path))
        self.shape = self.generateShape()
    }
    
    private var insideLine:Bool
    private var lineThickness: CGFloat
    private var path: NSBezierPath
    
    var snapSize: CGFloat = 0.1
    var shape:SCNShape = SCNShape()
    
    var insidePath = NSBezierPath()
    var outsidePath = NSBezierPath()
    var grandPath = NSBezierPath()
    
    func getLines(_ locPath:NSBezierPath) -> [Line]{
        var returnValue:[Line] = []
        var pointArray:[NSPoint] = []
        
        let point: NSPointPointer = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        //gets the points in a path
        for x in 0..<locPath.elementCount{
            locPath.element(at: x, associatedPoints: point)
            pointArray.append(point[0])
        }
        //cretes line array
        for x in 0...(pointArray.count - 2){
            if(pointArray[x] != pointArray[x+1]){
                let tempLine = Line(pointArray[x], pointArray[x+1], thickness: self.lineThickness)
                //ensure that no points are added
                if(!tempLine.point()){
                    returnValue.append(tempLine)
                } 
            }
        }
        return returnValue
    }
        
    func updatePaths(_ lines:[Line]){
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
            
            //test right side
            
            
            if(path.contains(centerPoints[0])){
                if(inside == path.contains(squarePoints[1])){
                    topLeft = squarePoints[1]
                }else{
                    topLeft = squarePoints[0]
                }
                inside = path.contains(centerPoints[1])
                if(inside == path.contains(squarePoints[3])){
                    topRight = squarePoints[3]
                }else{
                    topRight = squarePoints[2]
                }
            }else{
                inside = path.contains(centerPoints[0])
                if(inside == path.contains(squarePoints[0])){
                    topLeft = squarePoints[0]
                }else{
                    topLeft = squarePoints[1]
                }
                inside = path.contains(centerPoints[1])
                if(inside == path.contains(squarePoints[2])){
                    topRight = squarePoints[2]
                }else{
                    topRight = squarePoints[3]
                }
            }
            //============= Bottom Point =================
            squarePoints = idvLine.returnTestPoints(linePos.bottom)
            //test left side
           
            //test right side
            if(path.contains(centerPoints[0])){
                inside = path.contains(centerPoints[0])
                if(inside == path.contains(squarePoints[1])){
                    bottomLeft = squarePoints[1]
                }else{
                    bottomLeft = squarePoints[0]
                }
                inside = path.contains(centerPoints[1])
                if(inside == path.contains(squarePoints[3])){
                    bottomRight = squarePoints[3]
                }else{
                    bottomRight = squarePoints[2]
                }
            }else{
                inside = path.contains(centerPoints[0])
                if(inside == path.contains(squarePoints[0])){
                    bottomLeft = squarePoints[0]
                }else{
                    bottomLeft = squarePoints[1]
                }
                inside = path.contains(centerPoints[1])
                if(inside == path.contains(squarePoints[2])){
                    bottomRight = squarePoints[2]
                }else{
                    bottomRight = squarePoints[3]
                }
            }
            
            //debugging tool
            /*
            let breakPoint: NSPoint = NSMakePoint(3.6, 1.8)
            if(bottomLeft == breakPoint || bottomRight == breakPoint || topLeft == breakPoint || topRight == breakPoint){
                var squarePoints:[NSPoint] = idvLine.returnTestPoints(linePos.top)
                print("hit")
            }
            */
            
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
        grandPath.append(insidePath)
        grandPath.append(outsidePath)
    }
    
    func findClosedPath(_ lines:[Line])->[[NSPoint]]{
        var points: [NSPoint] = []
        var connections: [Int: Set<Int>] = [:]
        

        for idvLine in lines{
            points.append(idvLine.topPoint)
            points.append(idvLine.bottomPoint)
        }
        //the dictionary index for the points corispond to the index of points in unique points
        var uniquePoints: [NSPoint] = []
        for x in NSSet(array: points){uniquePoints.append(x as! NSPoint)}
        print(uniquePoints)
        for x in 0..<uniquePoints.count{
            
            let corner = uniquePoints[x]
            var connectionSet = Set<Int>()
            
            for idvLine in lines{
                if(idvLine.topPoint == corner){
                    connectionSet.insert(uniquePoints.firstIndex(of: idvLine.bottomPoint)!)
                }else if(idvLine.bottomPoint == corner){
                    connectionSet.insert(uniquePoints.firstIndex(of: idvLine.topPoint)!)
                }
            }
            connections[x] = connectionSet
        }
        for (index, nodes) in connections{
            if(nodes.count <= 1){
                connections.removeValue(forKey: index)
                for (indexS, _) in connections{
                    connections[indexS]?.remove(index)
                }
            }
        }
        print(connections)
        var currentPath:[Int]
        for (index, _) in connections{
            currentPath = [index]
            recursiveSearch(currentPath, connections)
        }
        currentPaths = removeDuplicates(currentPaths)
        
        //put the cordinates back in the array
        var returnValue:[[NSPoint]] = []
        for indvPath in currentPaths{
            var pointArray:[NSPoint] = []
            for index in 0..<indvPath.count{
                pointArray.append(uniquePoints[indvPath[index]])
            }
            returnValue.append(pointArray)
        }
        return returnValue
    }
    //may want to refactor this design
    var currentPaths:Set<[Int]> = Set()
    
    func recursiveSearch(_ currentPath:[Int], _ connections: [Int: Set<Int>]){
        var returnValue = currentPath
        for locConnection in connections[currentPath.last!]!{
            if (returnValue.contains(locConnection)){continue}
            returnValue.append(locConnection)
            if(isValidLoop(returnValue, connections)){
                currentPaths.insert(returnValue)
            }
            recursiveSearch(returnValue, connections)
            _ = returnValue.popLast()
        }
        //Does not run if empty
    }
    
    func removeDuplicates(_ paths:Set<[Int]>)->Set<[Int]>{
        var returnValue = paths
        for path in returnValue{
            var delete = false
            for comparePath in returnValue{
                if(Set(path) == Set(comparePath) && path != comparePath){
                    delete = true
                }
            }
            if(delete){
                returnValue.remove(path)
                delete = false
            }
            
        }
        return returnValue
    }
    
    func isValidLoop(_ currentPath:[Int], _ connections: [Int: Set<Int>])->Bool{
        //verify correct size
        if(currentPath.count <= 2){return false}
        for a1 in 0..<currentPath.count{
            if(a1 == (currentPath.count - 1)){
                if(!(connections[currentPath.first!]!.contains(currentPath.last!))){
                    return false
                }
            }else{
                if(!(connections[currentPath[a1]]!.contains(currentPath[a1+1]))){
                    return false
                }
            }
        }
        
        return true
    }
    
    func generateShape(shapeExtrusionDepth:CGFloat = 0.001)->SCNShape{
        var returnValue: SCNShape
        if(insideLine){
            self.path = self.insidePath
            //reset variables
            self.insidePath = NSBezierPath()
            self.outsidePath = NSBezierPath()
            self.grandPath = NSBezierPath()
            self.insideLine = false
            
            //regenerate paths
            self.updatePaths(self.getLines(self.path))
            self.shape = self.generateShape()
            returnValue = SCNShape(path: grandPath, extrusionDepth: shapeExtrusionDepth)
        }else{
            returnValue = SCNShape(path: grandPath, extrusionDepth: shapeExtrusionDepth)
        }
        return returnValue
    }
    
    func generateIndv()->[SCNShape]{
        var shapes:[SCNShape] = []
        
        if(insideLine){
            self.path = self.insidePath
            //reset variables
            self.insidePath = NSBezierPath()
            self.outsidePath = NSBezierPath()
            self.grandPath = NSBezierPath()
            self.insideLine = false
            
            //regenerate paths
            self.updatePaths(self.getLines(self.path))
        }else{
            let lines = self.getLines(self.path)
            var points: [NSPoint] = []

            for idvLine in lines{
                points.append(idvLine.topPoint)
                points.append(idvLine.bottomPoint)
                let shapePath = idvLine.rectanglePath()
                shapes.append(SCNShape(path: shapePath, extrusionDepth: 0.0001))
                
                //draw midpoint triangle
                let center = idvLine.midpoint()
                let trianglePath = NSBezierPath()
                
                trianglePath.move(to: NSMakePoint(center.x - snapSize/2, center.y - snapSize/2))
                trianglePath.relativeLine(to: NSMakePoint(snapSize/2, snapSize))
                trianglePath.relativeLine(to: NSMakePoint(snapSize/2, -snapSize))
                trianglePath.close()
                shapes.append(SCNShape(path: trianglePath, extrusionDepth: 0.0001))
            }
            //eliminates duplicates
            let uniquePoints = Array(NSSet(array: points))
            for point in uniquePoints{
                //draw corner squares
                let corner = point as! NSPoint
                let circlePath = NSBezierPath(rect: NSMakeRect(corner.x - (snapSize/2), corner.y - (snapSize/2), snapSize, snapSize))
                shapes.append(SCNShape(path: circlePath, extrusionDepth: 0.0001))
            }
        }
        return shapes
    }
    
}

