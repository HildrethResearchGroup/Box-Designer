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
        var path = NSBezierPath()
        switch (wallType) {
        case WallType.largeCorner:
            path = generateOverlapLargeCornerPath(width, length, materialThickness)
        case WallType.longCorner:
            path = generateOverlapLongCornerPath(width, length, materialThickness)
        case WallType.smallCorner:
            path = generateOverlapSmallCornerPath(width, length, materialThickness)
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
    
    static func generateOverlapLargeCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.line(to: CGPoint(x: 0.0, y: length))
        path.line(to: CGPoint(x: width, y: length))
        path.line(to: CGPoint(x: width, y: 0.0))
        path.close()
        return path
    }
    
    static func generateOverlapLongCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: materialThickness))
        path.line(to: CGPoint(x: 0.0, y: length - materialThickness))
        path.line(to: CGPoint(x: width, y: length - materialThickness))
        path.line(to: CGPoint(x:width, y: materialThickness))
        path.close()
        return path
    }
    
    static func generateOverlapSmallCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: materialThickness, y: materialThickness))
        path.line(to: CGPoint(x: materialThickness, y: length - materialThickness))
        path.line(to: CGPoint(x: width - materialThickness, y: length - materialThickness))
        path.line(to: CGPoint(x: width - materialThickness, y: materialThickness))
        path.close()
        return path
    }
    
//    static func generateOverlapSmallWallPath(_ width: Double, _ length: Double, _ materialThickness: Double) -> NSBezierPath {
//        let path = NSBezierPath()
//        path.move(to: CGPoint(x: materialThickness, y: materialThickness))
//        path.line(to: CGPoint(x: materialThickness, y: length - materialThickness))
//        path.line(to: CGPoint(x: width - materialThickness, y: length - materialThickness))
//        path.line(to: CGPoint(x: width - materialThickness, y: materialThickness))
//        path.close()
//        return path
//    }
    
    static func removeLid(){
        
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
    
    /*
     The following functions are part of an attempt to allow the user to specify the tab width.  This is currently not implemented,
     but these functions have been left in case they are of any use to anyone modifying or adding functionality in the future.
     */
    
    /*
     This function makes a path that starts "outside", with tabs going "inside", moving upward.
     */
    static func makeOuterLeftTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        print("X: \(startX), Y: \(startY)")
        path.line(to: CGPoint(x: startX, y: startY + outerTabWidth))
        print("X: \(startX), Y: \(startY + outerTabWidth)")
        //first inner tab
        path.append(makeRightLeftTab(x: startX, y: startY + outerTabWidth, materialThickness, tabWidth, upward: true))
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY + sideLength / 3))
        path.append(makeRightLeftTab(x: startX, y: startY + sideLength / 3, materialThickness, sideLength / 3, upward: true))
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentY = startY + outerTabWidth + tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: startX, y: currentY + tabWidth))
            currentY = currentY + tabWidth
            path.append(makeRightLeftTab(x: startX, y: currentY, materialThickness, tabWidth, upward: true))
            currentY = currentY + tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
        
        //second outer tab
        path.line(to: CGPoint(x: startX, y: startY + sideLength))
        
        return path
    }
    
    /*
    This function makes a path that starts "inside", with tabs going "outside", moving upward.
    */
    static func makeInnerLeftTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY + outerTabWidth))
        
        //first inner tab
        path.append(makeLeftRightTab(x: startX, y: startY + outerTabWidth, materialThickness, tabWidth, upward: true))
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentY = startY + outerTabWidth + tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: startX, y: currentY + tabWidth))
            currentY = currentY + tabWidth
            path.append(makeLeftRightTab(x: startX, y: currentY, materialThickness, tabWidth, upward: true))
            currentY = currentY + tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }

        //second outer tab
        path.line(to: CGPoint(x: startX, y: startY + sideLength))
        
        return path
    }
    
    /*
    This function makes a path that starts "outside", with tabs going "inside", moving rightward.
    */
    static func makeOuterUpTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {

        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX + outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeDownUpTab(x: startX + outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: true))
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX + sideLength / 3, y: startY))
        path.append(makeDownUpTab(x: startX + sideLength, y: startY, materialThickness, sideLength / 3, toTheRight: true))

        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentX = startX + outerTabWidth + tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: currentX + tabWidth, y: startY))
            currentX = currentX + tabWidth
            path.append(makeDownUpTab(x: currentX, y: startY, materialThickness, tabWidth, toTheRight: true))
            currentX = currentX + tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
        
        //second outer tab
        path.line(to: CGPoint(x: startX + sideLength, y: startY))

        return path
    }
    
    /*
    This function makes a path that starts "inside", with tabs going "outside", moving rightward.
    */
    static func makeInnerUpTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX + outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeUpDownTab(x: startX + outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: true))
    
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentX = startX + outerTabWidth + tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: currentX + tabWidth, y: startY))
            currentX = currentX + tabWidth
            path.append(makeUpDownTab(x: currentX, y: startY, materialThickness, tabWidth, toTheRight: true))
            currentX = currentX + tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
        
        //second outer tab
        path.line(to: CGPoint(x: startX + sideLength, y: startY))
    
        return path
    }
    
    /*
    This function makes a path that starts "outside", with tabs going "inside", moving downward.
    */
    static func makeOuterRightTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {

        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY - outerTabWidth))
        
        //first inner tab
        path.append(makeLeftRightTab(x: startX, y: startY - outerTabWidth, materialThickness, tabWidth, upward: false))
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY - sideLength / 3))
        path.append(makeLeftRightTab(x: startX, y: startY - sideLength / 3, materialThickness, sideLength / 3, upward: false))
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentY = startY - outerTabWidth - tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: startX, y: currentY - tabWidth))
            currentY = currentY - tabWidth
            path.append(makeLeftRightTab(x: startX, y: currentY, materialThickness, tabWidth, upward: false))
            currentY = currentY - tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
 
        //second outer tab
        path.line(to: CGPoint(x: startX, y: startY - sideLength))

        return path
    }
    
    /*
    This function makes a path that starts "inside", with tabs going "outside", moving downward.
    */
    static func makeInnerRightTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY - outerTabWidth))
        
        //first inner tab
        path.append(makeRightLeftTab(x: startX, y: startY - outerTabWidth, materialThickness, tabWidth, upward: false))
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentY = startY - outerTabWidth - tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: startX, y: currentY - tabWidth))
            currentY = currentY - tabWidth
            path.append(makeRightLeftTab(x: startX, y: currentY, materialThickness, tabWidth, upward: false))
            currentY = currentY - tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
 
        //second outer tab
        path.line(to: CGPoint(x: startX, y: startY - sideLength))
        
        return path
    }
    
    /*
    This function makes a path that starts "outside", with tabs going "inside", moving leftward.
    */
    static func makeOuterDownTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {

        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX - outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeUpDownTab(x: startX - outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: false))
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX - sideLength / 3, y: startY))
        path.append(makeUpDownTab(x: startX - sideLength / 3, y: startY, materialThickness, sideLength / 3, toTheRight: false))
        
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentX = startX - outerTabWidth - tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: currentX - tabWidth, y: startY))
            currentX = currentX - tabWidth
            path.append(makeUpDownTab(x: currentX, y: startY, materialThickness, tabWidth, toTheRight: false))
            currentX = currentX - tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
 
        //second outer tab
        path.line(to: CGPoint(x: startX - sideLength, y: startY))

        return path
    }
    
    /*
    This function makes a path that starts "inside", with tabs going "outside", moving leftward.
    */
    static func makeInnerDownTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX - outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeDownUpTab(x: startX - outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: false))
        
        //how much of the length remains for placing the INNER tabs?
        var lengthRemaining = sideLength - outerTabWidth * 2 - tabWidth
        var currentX = startX - outerTabWidth - tabWidth
        
        //when lengthRemaining is no longer greater than 0, we have put in enough inner tabs
        while lengthRemaining > 0 {
            //accounting for possible error due to double rounding
            if (lengthRemaining - tabWidth < 0) {
                break
            }
            path.line(to: CGPoint(x: currentX - tabWidth, y: startY))
            currentX = currentX - tabWidth
            path.append(makeDownUpTab(x: currentX, y: startY, materialThickness, tabWidth, toTheRight: false))
            currentX = currentX - tabWidth
            lengthRemaining = lengthRemaining - 2 * tabWidth
        }
        
        //second outer tab
        path.line(to: CGPoint(x: startX - sideLength, y: startY))
        
        return path
    }
    
    /*
     This function attempts to calculate the width of the outer tabs on a side
     when as many tabs of width: tabWidth are placed along that side.
     */
    static func calcOuterTabWidth(_ tabWidth: Double, sideLength length: Double) -> Double {
        var left = length - tabWidth
        //we want the outer tabs to be at least the same as the inner tabWidth, if not wider
        while (left / 2 > tabWidth) {
            left -= 2 * tabWidth
        }
        //ensure that width isn't less than zero
        if (left < 0) {
            left += 2 * tabWidth
        }
        return left
    }
    
    /*
     This function returns a path that moves down, to either side, then up again.
     */
    static func makeDownUpTab(x startX: Double, y startY: Double, _ materialThickness: Double, _ tabWidth: Double, toTheRight dirRight: Bool) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        if dirRight {
            path.line(to: CGPoint(x: startX, y: startY - materialThickness))
            path.line(to: CGPoint(x: startX + tabWidth, y: startY - materialThickness))
            path.line(to: CGPoint(x: startX + tabWidth, y: startY))
        } else {
            path.line(to: CGPoint(x: startX, y: startY - materialThickness))
            path.line(to: CGPoint(x: startX - tabWidth, y: startY - materialThickness))
            path.line(to: CGPoint(x: startX - tabWidth, y: startY))
        }
        return path
    }
    
    /*
     This function returns a path that moves up, to either side, then down again.
     */
    static func makeUpDownTab(x startX: Double, y startY: Double, _ materialThickness: Double, _ tabWidth: Double, toTheRight dirRight: Bool) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        if dirRight {
            path.line(to: CGPoint(x: startX, y: startY + materialThickness))
            path.line(to: CGPoint(x: startX + tabWidth, y: startY + materialThickness))
            path.line(to: CGPoint(x: startX + tabWidth, y: startY))
        } else {
            path.line(to: CGPoint(x: startX, y: startY + materialThickness))
            path.line(to: CGPoint(x: startX - tabWidth, y: startY + materialThickness))
            path.line(to: CGPoint(x: startX - tabWidth, y: startY))
        }
        return path
    }
    
    /*
     This function returns a path that moves right, either up or down, then left again.
     */
    static func makeRightLeftTab(x startX: Double, y startY: Double, _ materialThickness: Double, _ tabWidth: Double, upward dirUp: Bool) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        if dirUp {
            path.line(to: CGPoint(x: startX + materialThickness, y: startY))
            path.line(to: CGPoint(x: startX + materialThickness, y: startY + tabWidth))
            path.line(to: CGPoint(x: startX, y: startY + tabWidth))
        } else {
            path.line(to: CGPoint(x: startX + materialThickness, y: startY))
            path.line(to: CGPoint(x: startX + materialThickness, y: startY - tabWidth))
            path.line(to: CGPoint(x: startX, y: startY - tabWidth))
        }
        return path
    }
    
    /*
     This function returns a path that moves left, either up or down, then right again.
     */
    static func makeLeftRightTab(x startX: Double, y startY: Double, _ materialThickness: Double, _ tabWidth: Double, upward dirUp: Bool) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        if dirUp {
            path.line(to: CGPoint(x: startX - materialThickness, y: startY))
            path.line(to: CGPoint(x: startX - materialThickness, y: startY + tabWidth))
            path.line(to: CGPoint(x: startX, y: startY + tabWidth))
        } else {
            path.line(to: CGPoint(x: startX - materialThickness, y: startY))
            path.line(to: CGPoint(x: startX - materialThickness, y: startY - tabWidth))
            path.line(to: CGPoint(x: startX, y: startY - tabWidth))
        }
        return path
    }
    

}
