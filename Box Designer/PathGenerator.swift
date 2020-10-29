//
//  PathGenerator.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

/**
This class is the driver behind rendering the user's desired box correctly on the screen. It handles the tab and overlap join types and ensures the paths are drawn correctly.
 
 - Authors:
    - CSM Field Session Summer 2020 and Fall 2020.
 
 - Copyright:
    - Copyright © 2020 Hildreth Research Group. All rights reserved.
 
 */
class PathGenerator {
    
    /**
     This function uses the joinType and wallType parameters to select which function to use
     for generating a path (as of now, the choices are overlap or tab joins).
     
     - Parameters:
            - width: this is the user-inputted box model width
            - length: this is the user-inputted box model length
            - materialThickness: this is the user-inputted box model material thickness
            - wallType: this is the type of wall, which ensures that the walls on the same coordinate plane are drawn correctly
            - joinType: this is the type of join, which ensures the path is drawn according to the tab type or overlap type
            - nTab: this is the user-inputted number of tabs for the tab join type
     
     - Returns (NSBezierPath): this function returns a path that can be drawn in the scene
     */
    static func generatePath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, nTab: Double?) -> NSBezierPath {
        // instantiate a new path
        var path = NSBezierPath()
        
        // create paths according to the join type (overlap or tab)
        switch (joinType) {
        case JoinType.overlap:
            path = generateOverlapPath(width, length, materialThickness, wallType)
        case JoinType.tab:
            path = generateTabPath(width, length, materialThickness, wallType, nTab: nTab!)
        }
        return path
    }
    
    /**
     This function draws the necessary overlap join path for a specified wall type -- the output path is a single wall component that can be drawn in the view.
     - Parameters:
            - width: this is the user-inputted box model width
            - length: this is the user-inputted box model length
            - materialThickness: this is the user-inputted box model material thickness
            - wallType: this is the type of wall, which ensures that the walls on the same coordinate plane are drawn correctly
     - Returns (NSBezierPath): this function returns a path that can be drawn in the scene -- it is a single wall component
     */
    static func generateOverlapPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType) -> NSBezierPath {
        let path = NSBezierPath()
        switch (wallType) {
        case WallType.largeCorner:
            // top and bottom cover the other sides (this type overlaps all walls and will be the true dimensions of the desired box
            createOverlapPath(path: path, x12: 0.0, x34: width, y14: 0.0, y23: length)
        case WallType.longCorner:
            // make sure longCorner walls are overlapped by largeCorner walls
            createOverlapPath(path: path, x12: 0.0, x34: width, y14: materialThickness, y23: length-materialThickness)
            return path
        case WallType.smallCorner:
            // make sure smallCorner walls are overlapped by largeCorner and longCorner walls
            createOverlapPath(path: path, x12: materialThickness, x34: width-materialThickness, y14: materialThickness, y23: length-materialThickness)
            return path
        }
        return path
    }
    /**
     This function adjusts an overlap-type path according to its inputs, which are dependent on wallType and decided in generateOverlapPath function. It does not return a path, simply alters that NSBezierPath that's passed in.
    - Parameters:
        - path: this is the NSBezierPath that needs to be altered
        - x12: this is the x coordinate for the first two alterations of the path
        - x34; this is the x coordinate for the 3rd and 4th alterations of the path
        - y14: this is the y coordinate for the 1st and 4th alterations of the path
        - y23: this is the y coordinate for the 2nd and 3rd alterations of the path
     */
    static func createOverlapPath(path: NSBezierPath, x12: Double, x34: Double, y14: Double, y23: Double) {
        path.move(to: CGPoint(x: x12, y: y14))
        path.line(to: CGPoint(x: x12, y: y23))
        path.line(to: CGPoint(x: x34, y: y23))
        path.line(to: CGPoint(x: x34, y: y14))
        path.close()
        
    }
    static func generateTabPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, nTab: Double) -> NSBezierPath {
        var path = NSBezierPath()
        switch (wallType) {
        case WallType.largeCorner:
            //path = NSBezierPath()
            path = generateTabLargeLongCornerPath(wallType,width, length, materialThickness, Int(nTab))
        case WallType.longCorner:
            //path = NSBezierPath()
            path = generateTabLargeLongCornerPath(wallType,width, length, materialThickness, Int(nTab))
        case WallType.smallCorner:
            //path = NSBezierPath()
            path = generateTabSmallCornerPath(width, length, materialThickness, Int(nTab))
        }
        return path
    }
    
    /*we may be able to compress this down since the left and right sides are the same (exceptMaterialThickness is set to 0) and top and bottom are different*/
    static func generateTabLargeLongCornerPath(_ wallType: WallType, _ width: Double, _ length: Double, _ materialThickness: Double, _ nTabs: Int) -> NSBezierPath {
        
        let largeCorner = (wallType == WallType.largeCorner)
        //the number of sections
        var nSections : Int
        if largeCorner { nSections = (nTabs * 2) - 1} else { nSections = (nTabs * 2) + 1}
        
        //the length of sections
        var sectionLength : Double
        if largeCorner {sectionLength = length/Double(nSections) } else {sectionLength = (length-(materialThickness*2))/Double(nSections - 2)}
        var sectionWidth : Double
        if largeCorner { sectionWidth = width/Double(nSections) } else { sectionWidth = width/Double(nSections - 2)}
        
        let path = NSBezierPath()
        if largeCorner {path.move(to: CGPoint(x: 0.0, y: 0.0))} else {path.move(to: CGPoint(x: 0.0, y: materialThickness))}
        
        //left side
        path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        for _ in 0...(nTabs - 2){
            createTabPath(path: path, point1: [materialThickness,0.0], point2: [0.0,sectionLength], point3: [-materialThickness,0.0], point4: [0.0,sectionLength])
        }
        
        //top side
        path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            largeCorner ?
                createTabPath(path: path, point1: [0.0,-materialThickness], point2: [sectionWidth,0.0], point3: [0.0,materialThickness], point4: [sectionWidth,0.0]) :
                createTabPath(path: path, point1: [0.0,materialThickness], point2: [sectionWidth,0.0], point3: [0.0,-materialThickness], point4: [sectionWidth,0.0])
        }
        
        //right side
        path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        for _ in 0...(nTabs - 2){
            createTabPath(path: path, point1: [-materialThickness,0.0], point2: [0.0,-sectionLength], point3: [materialThickness,0.0], point4: [0.0,-sectionLength])
        }
        
        //bottom side
        path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            largeCorner ?
                createTabPath(path: path, point1: [0.0,materialThickness], point2: [-sectionWidth,0.0], point3: [0.0,-materialThickness], point4: [-sectionWidth,0.0]) :
                createTabPath(path: path, point1: [0.0,-materialThickness], point2: [-sectionWidth,0.0], point3: [0.0,materialThickness], point4: [-sectionWidth,0.0])
        }
        
        path.close()
        return path
    }

    
    static func generateTabSmallCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ nTabs: Int) -> NSBezierPath {
        
        //the number of sections
        let nSections = (nTabs * 2) + 1
        //the length of sections
        let sectionLength = (length-(materialThickness*2))/Double(nSections - 2)
        let sectionWidth = width/Double(nSections - 2)
        let gap = sectionWidth - materialThickness
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: sectionWidth, y: 0.0))
        //left side
        path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
        path.relativeLine(to: CGPoint(x: -gap, y: 0.0))
        for _ in 0...(nTabs - 2){
            createTabPath(path: path, point1: [0.0,sectionLength], point2: [-materialThickness,0.0], point3: [0.0,sectionLength], point4: [materialThickness,0.0])
        }
        
        createTabPath(path: path, point1: [0.0,sectionLength], point2: [gap,0.0], point3: [0.0,materialThickness], point4: [sectionWidth,0.0])
        
        for _ in 0...(nTabs - 3){ //here 3
            createTabPath(path: path, point1: [0.0,-materialThickness], point2: [sectionWidth,0.0], point3: [0.0,materialThickness], point4: [sectionWidth,0.0])
        }
        
        path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
        path.relativeLine(to: CGPoint(x: gap, y: 0.0))
        
        for _ in 0...(nTabs - 2){
            createTabPath(path: path, point1: [0.0,-sectionLength], point2: [materialThickness,0.0], point3: [0.0,-sectionLength], point4: [-materialThickness,0.0])
        }
        createTabPath(path: path, point1: [0.0,-sectionLength], point2: [-gap,0.0], point3: [0.0,-materialThickness], point4: [-sectionWidth,0.0])
        
        for _ in 0...(nTabs - 3){ // here 3
            createTabPath(path: path, point1: [0.0,materialThickness], point2: [-sectionWidth,0.0], point3: [0.0,-materialThickness], point4: [-sectionWidth,0.0])
        }
        
        path.close()
        return path
    }
    
    static func createTabPath(path: NSBezierPath, point1: [Double], point2: [Double], point3: [Double], point4: [Double]) {
        path.relativeLine(to: CGPoint(x: point1[0], y: point1[1]))
        path.relativeLine(to: CGPoint(x: point2[0], y: point2[1]))
        path.relativeLine(to: CGPoint(x: point3[0], y: point3[1]))
        path.relativeLine(to: CGPoint(x: point4[0], y: point4[1]))
    }
}
