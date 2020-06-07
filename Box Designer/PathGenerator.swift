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
        print("generatePath() function called")
        var path = NSBezierPath()
        switch (joinType) {
        case JoinType.overlap:
            path = generateOverlapPath(width, length, materialThickness, wallType)
        case JoinType.tab:
            if let tabWidth = internalTabWidth {
                path = generateTabPath(width, length, materialThickness, wallType, tabWidth: tabWidth)
            } else {
                //This path should NOT ever be reached.
                //However, I must provide something to do in case
                //tabWidth is somehow still nil when JoinType.tab
                //is chosen.
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
        path.move(to: CGPoint(x: materialThickness, y: 0.0))
        path.line(to: CGPoint(x: materialThickness, y: length))
        path.line(to: CGPoint(x: width - materialThickness, y: length))
        path.line(to: CGPoint(x: width - materialThickness, y: 0.0))
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
    
    static func generateTabLargeCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.append(makeOuterLeftTabPath(0.0, 0.0, length, materialThickness, tabWidth))
        path.append(makeOuterUpTabPath(0.0, length, width, materialThickness, tabWidth))
        path.append(makeOuterRightTabPath(width, length, length, materialThickness, tabWidth))
        path.append(makeOuterDownTabPath(width, 0.0, width, materialThickness, tabWidth))
        return path
    }
    
    static func generateTabLongCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.append(makeInnerLeftTabPath(materialThickness, 0.0, length, materialThickness, tabWidth))
        path.append(makeOuterUpTabPath(materialThickness, length, width - 2 * materialThickness, materialThickness, tabWidth))
        path.append(makeInnerRightTabPath(width - materialThickness, length, length, materialThickness, tabWidth))
        path.append(makeOuterDownTabPath(width - materialThickness, 0.0, width - 2 * materialThickness, materialThickness, tabWidth))
        return path
    }
    
    static func generateTabSmallCornerPath(_ width: Double, _ length: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        let path = NSBezierPath()
        path.append(makeInnerLeftTabPath(materialThickness, materialThickness, length - 2 * materialThickness, materialThickness, tabWidth))
        path.append(makeInnerUpTabPath(materialThickness, length - materialThickness, width - 2 * materialThickness, materialThickness, tabWidth))
        path.append(makeInnerRightTabPath(width - materialThickness, length - materialThickness, length - 2 * materialThickness, materialThickness, tabWidth))
        path.append(makeInnerDownTabPath(width - materialThickness, materialThickness, width - 2 * materialThickness, materialThickness, tabWidth))
        return path
    }
    
    static func makeOuterLeftTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY + outerTabWidth))
        
        //first inner tab
        path.append(makeRightLeftTab(x: startX, y: startY + outerTabWidth, materialThickness, tabWidth, upward: true))
        
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
    
    static func makeOuterUpTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX + outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeDownUpTab(x: startX + outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: true))
        
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
    
    static func makeOuterRightTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX, y: startY - outerTabWidth))
        
        //first inner tab
        path.append(makeLeftRightTab(x: startX, y: startY - outerTabWidth, materialThickness, tabWidth, upward: false))
        
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
    
    static func makeOuterDownTabPath(_ startX: Double, _ startY: Double, _ sideLength: Double, _ materialThickness: Double, _ tabWidth: Double) -> NSBezierPath {
        
        let path = NSBezierPath()
        let outerTabWidth = calcOuterTabWidth(tabWidth, sideLength: sideLength)
        
        //first outer tab
        path.move(to: CGPoint(x: startX, y: startY))
        path.line(to: CGPoint(x: startX - outerTabWidth, y: startY))
        
        //first inner tab
        path.append(makeUpDownTab(x: startX - outerTabWidth, y: startY, materialThickness, tabWidth, toTheRight: false))
        
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
    
    static func calcOuterTabWidth(_ tabWidth: Double, sideLength length: Double) -> Double {
        var left = length - tabWidth
        //we want the outer tabs to be at least the same as the inner tabWidth, if not wider
        while (left / 2 > tabWidth) {
            left -= 2 * tabWidth
        }
        //above while loop will reduce the leftover by one iteration too many
        //so add the two tabWidths worth back in
        left += 2 * tabWidth
        return left
    }
    
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
