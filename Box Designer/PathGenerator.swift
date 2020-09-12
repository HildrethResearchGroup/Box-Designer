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
            path = generateTabLargeCornerPath(width, length, materialThickness, internalTabWidth)
        case WallType.longCorner:
            path = generateTabLongCornerPath(width, length, materialThickness, internalTabWidth)
        case WallType.smallCorner:
            path = generateTabSmallCornerPath(width, length, materialThickness, internalTabWidth)
        }
        return path
    }
    
    /*we may be able to compress this down since the left and right sides are the same (exceptMaterialThickness is set to 0) and top and bottom are different*/
    
    static func generateTabLargeCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
 
        let path = NSBezierPath()
        
        //left side
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.line(to: CGPoint(x: 0.0, y: length / 5))
        
        path.line(to: CGPoint(x: materialThickness, y: length / 5))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 2))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 2))
        
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 3))
        
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 3))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 4))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 4))
        
        path.line(to: CGPoint(x: 0.0, y: length))
        
        //top side
        path.line(to: CGPoint(x: width / 5, y: length))
        
        path.line(to: CGPoint(x: width / 5, y: length - materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length - materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length - materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length - materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length))
        
        path.line(to: CGPoint(x: width, y: length))
        
        //right side
        path.line(to: CGPoint(x: width, y: (length / 5) * 4))
        
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 4))
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 3))
        path.line(to: CGPoint(x: width, y: (length / 5) * 3))
        
        path.line(to: CGPoint(x: width, y: (length / 5) * 2))
        
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 2))
        path.line(to: CGPoint(x: width - materialThickness, y: length / 5))
        path.line(to: CGPoint(x: width, y: length / 5))
        
        path.line(to: CGPoint(x: width, y: 0.0))
        
        //bottom side
        path.line(to: CGPoint(x: (width / 5) * 4, y: 0.0))
        
        path.line(to: CGPoint(x: (width / 5) * 4, y: materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 3, y: materialThickness))
        path.line(to: CGPoint(x: (width / 5) * 3, y: 0.0))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: 0.0))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: materialThickness))
        path.line(to: CGPoint(x: width / 5, y: materialThickness))
        path.line(to: CGPoint(x: width / 5, y: 0.0))
            
        path.line(to: CGPoint(x: 0.0, y: 0.0))
        path.close()
        
        return path
    }
    
    static func generateTabLongCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        
        //left side
        path.move(to: CGPoint(x: 0.0, y: materialThickness))
        path.line(to: CGPoint(x: 0.0, y: length / 5))
        
        path.line(to: CGPoint(x: materialThickness, y: length / 5))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 2))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 2))
        
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 3))
        
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 3))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 4))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 4))
        
        path.line(to: CGPoint(x: 0.0, y: length - materialThickness))
        
        //top side
        path.line(to: CGPoint(x: width / 5, y: length - materialThickness))
        
        path.line(to: CGPoint(x: width / 5, y: length))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length - materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length - materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length - materialThickness))
        
        path.line(to: CGPoint(x: width, y: length - materialThickness))
        
        //right side
        path.line(to: CGPoint(x: width, y: (length / 5) * 4))
        
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 4))
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 3))
        path.line(to: CGPoint(x: width, y: (length / 5) * 3))
        
        path.line(to: CGPoint(x: width, y: (length / 5) * 2))
        
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 2))
        path.line(to: CGPoint(x: width - materialThickness, y: length / 5))
        path.line(to: CGPoint(x: width, y: length / 5))
        
        path.line(to: CGPoint(x: width, y: materialThickness))
        
        //bottom side
        path.line(to: CGPoint(x: (width / 5) * 4, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 4, y: 0.0))
        path.line(to: CGPoint(x: (width / 5) * 3, y: 0.0))
        path.line(to: CGPoint(x: (width / 5) * 3, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: 0.0))
        path.line(to: CGPoint(x: width / 5, y: 0.0))
        path.line(to: CGPoint(x: width / 5, y: materialThickness))
        
        path.line(to: CGPoint(x: 0.0, y: materialThickness))
        path.close()

        return path
    }
    
    static func generateTabSmallCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        
        //left side
        path.move(to: CGPoint(x: materialThickness, y: materialThickness))
        path.line(to: CGPoint(x: materialThickness, y: length / 5))
        
        path.line(to: CGPoint(x: 0.0, y: length / 5))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 2 ))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 2 ))
        
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 3 ))
        
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 3))
        path.line(to: CGPoint(x: 0.0, y: (length / 5) * 4 ))
        path.line(to: CGPoint(x: materialThickness, y: (length / 5) * 4 ))
        
        path.line(to: CGPoint(x: materialThickness, y: length - materialThickness))
        
        //top side
        path.line(to: CGPoint(x: width / 5, y: length - materialThickness))
        
        path.line(to: CGPoint(x: width / 5, y: length))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length))
        path.line(to: CGPoint(x: (width / 5) * 2, y: length - materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length - materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 3, y: length))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length))
        path.line(to: CGPoint(x: (width / 5) * 4, y: length - materialThickness))
        
        path.line(to: CGPoint(x: width - materialThickness, y: length - materialThickness))
        
        //right side
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 4))
        
        path.line(to: CGPoint(x: width, y: (length / 5) * 4))
        path.line(to: CGPoint(x: width, y: (length / 5) * 3 ))
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 3 ))
        
        path.line(to: CGPoint(x: width - materialThickness, y: (length / 5) * 2 ))
        
        path.line(to: CGPoint(x: width, y: (length / 5) * 2))
        path.line(to: CGPoint(x: width, y: length / 5 ))
        path.line(to: CGPoint(x: width - materialThickness, y: length / 5 ))
        
        path.line(to: CGPoint(x: width - materialThickness, y: materialThickness))
        
        //bottom side
        path.line(to: CGPoint(x: (width / 5) * 4, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 4, y: 0.0))
        path.line(to: CGPoint(x: (width / 5) * 3, y: 0.0))
        path.line(to: CGPoint(x: (width / 5) * 3, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: materialThickness))
        
        path.line(to: CGPoint(x: (width / 5) * 2, y: 0.0))
        path.line(to: CGPoint(x: width / 5, y: 0.0))
        path.line(to: CGPoint(x: width / 5, y: materialThickness))
        
        path.line(to: CGPoint(x: materialThickness, y: materialThickness))
        path.close()
        
        return path
    }
}
