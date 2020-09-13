//
//  PathGenerator.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

class PathGenerator {
    
    /*
     This function uses the joinType and wallType parameters to select which function to use
     for generating a path.  Descriptions of the wall types - largeCorner, longCorner, and
     smallCorner - can be found in the WallType enum.
     */
    static func generatePath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, _ joinType: JoinType, tabWidth internalTabWidth: Double?) -> NSBezierPath {
        var path = NSBezierPath()
        switch (joinType) {
        case JoinType.overlap:
            path = generateOverlapPath(width, length, materialThickness, wallType)
        case JoinType.tab:
            if let tabWidth = internalTabWidth {
                path = generateTabPath(width, length, materialThickness, wallType, tabWidth: tabWidth)
            } else {
                /*
                 This path is reached when the JoinType: .tab is originally chosen;
                 at this moment, no tabWidth has been set yet.
                 */
                path = generateOverlapPath(width, length, materialThickness, wallType)
            }
        }
        return path
    }
    
    static func generateOverlapPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType) -> NSBezierPath {
        let path = NSBezierPath()
        switch (wallType) {
        case WallType.largeCorner:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.line(to: CGPoint(x: 0.0, y: length))
            path.line(to: CGPoint(x: width, y: length))
            path.line(to: CGPoint(x: width, y: 0.0))
            path.close()
        case WallType.longCorner:
            let path = NSBezierPath()
            path.move(to: CGPoint(x: 0.0, y: materialThickness))
            path.line(to: CGPoint(x: 0.0, y: length - materialThickness))
            path.line(to: CGPoint(x: width, y: length - materialThickness))
            path.line(to: CGPoint(x:width, y: materialThickness))
            path.close()
            return path
        case WallType.smallCorner:
            path.move(to: CGPoint(x: materialThickness, y: materialThickness))
            path.line(to: CGPoint(x: materialThickness, y: length - materialThickness))
            path.line(to: CGPoint(x: width - materialThickness, y: length - materialThickness))
            path.line(to: CGPoint(x: width - materialThickness, y: materialThickness))
            path.close()
            return path
        }
        return path
    }
    
    static func generateTabPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ wallType: WallType, tabWidth internalTabWidth: Double) -> NSBezierPath {
        var path = NSBezierPath()
        switch (wallType) {
        case WallType.largeCorner:
            //path = NSBezierPath()
            path = generateTabLargeCornerPath(width, length, materialThickness, 4)
        case WallType.longCorner:
            //path = NSBezierPath()
            path = generateTabLongCornerPath(width, length, materialThickness, 4)
        case WallType.smallCorner:
            //path = NSBezierPath()
            path = generateTabSmallCornerPath(width, length, materialThickness, 4)
        }
        return path
    }
    
    /*we may be able to compress this down since the left and right sides are the same (exceptMaterialThickness is set to 0) and top and bottom are different*/
    
    static func generateTabLargeCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ nTabs: Int) -> NSBezierPath {
 
        //the number of sections
        let nSections = ((nTabs) * 2) - 1
        //the length of sections
        let sectionLength = length/Double(nSections)
        let sectionWidth = width/Double(nSections)
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        //left side
        path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        }
        
        //top side
        path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        }
        
        //right side
        path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        }
        
        //bottom side
        path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        }
        
        path.close()
        return path
    }
    
    static func generateTabLongCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ nTabs: Int) -> NSBezierPath {
        
        //the number of sections
        let nSections = (nTabs * 2) + 1
        //the length of sections
        let sectionLength = (length-(materialThickness*2))/Double(nSections - 2)
        let sectionWidth = width/Double(nSections - 2)
        
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: materialThickness))
        
        //left side
        path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        }
        
        //top side
        path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        }
        
        //right side
        path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        }
        
        //bottom side
        path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
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
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
        }
        
        path.relativeLine(to: CGPoint(x: 0.0, y: sectionLength))
        path.relativeLine(to: CGPoint(x: gap, y: 0.0))
        path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
        path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        
        for _ in 0...(nTabs - 3){
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: sectionWidth, y: 0.0))
        }
        
        path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
        path.relativeLine(to: CGPoint(x: gap, y: 0.0))
        
        for _ in 0...(nTabs - 2){
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
            path.relativeLine(to: CGPoint(x: materialThickness, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
            path.relativeLine(to: CGPoint(x: -materialThickness, y: 0.0))
        }
        
        path.relativeLine(to: CGPoint(x: 0.0, y: -sectionLength))
        path.relativeLine(to: CGPoint(x: -gap, y: 0.0))
        path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
        path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        
        for _ in 0...(nTabs - 3){
            path.relativeLine(to: CGPoint(x: 0.0, y: materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
            path.relativeLine(to: CGPoint(x: 0.0, y: -materialThickness))
            path.relativeLine(to: CGPoint(x: -sectionWidth, y: 0.0))
        }
        
        path.close()
        return path
    }
}
