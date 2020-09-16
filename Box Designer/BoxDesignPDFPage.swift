//
//  PDFFileSaver.swift
//  Box Designer
//
//  Created by Grace Clark on 5/27/20.
//  Refactored by Field Session Fall 2020.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit
import PDFKit

class BoxDesignPDFPage : PDFPage {
    
    var wallsToDraw : [WallModel]
    let inchScale : Double = 100.0
    let margin : Double
    let padding : Double
    let pageHeight : Double
    let pageWidth : Double
    var firstLineDrawn = false
    
    init?(_ wallsToDraw : [WallModel], margin: Double, padding: Double, height: Double, width: Double) {
        self.wallsToDraw = wallsToDraw
        self.margin = margin
        self.padding = padding
        self.pageHeight = height
        self.pageWidth = width
        super.init()
    }
    // this method draws wall starting at the bottom left of the page and going up, it then moves to the right and starts drawing up from the bottom again
    // it returns walls that would not fit on itself (the page)
    func drawPaths(for box: PDFDisplayBox)->[WallModel] {
        var xOffset = margin
        var yOffset = margin
        var maxXSoFar = margin
        var leftoverWalls = [WallModel]()
        
        for wall in wallsToDraw {
            
            let path = wall.path
            var moveToPoint = NSPoint()
            var lineToPoint = NSPoint()
            
            // if vertical space is used up, change xOffset to be beside it, and reset y-offset so drawing starts at bottom of page again
            // only if there's still horizontal space
            if (yOffset + wall.length * inchScale > pageHeight - margin) {
                // if horizontal space is used up, add the wall to leftover walls and break so that the remaining walls (if any) can also be added
                if (maxXSoFar + wall.width * inchScale > pageWidth - margin) {
                    leftoverWalls.append(wall)
                    continue
                } else {
                    // if vertical space is used up but horizontal isn't, reset xOffset to account for wall widths already drawn and reset yOffset ot be at the bottom of the page (accounting for margin)
                    xOffset = maxXSoFar
                    yOffset = margin
                }
            }

            // draw wall by breaking each each line into its own path and drawing it (drawLine function)
            for element in 0..<path.elementCount {

                var point = NSPoint()
                let elementType = path.element(at: element, associatedPoints: &point)
                
                // if this is the beginning of a wall, reset boolean so that the moveToPoint
                // isn't reset in the switch lineTo statement
                if element == 0 {
                    firstLineDrawn = false
                }
                
                switch (elementType) {
                case NSBezierPath.ElementType.moveTo:
                    moveToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    moveToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                
                case NSBezierPath.ElementType.lineTo:
                    if (firstLineDrawn) {
                        moveToPoint.x = lineToPoint.x
                        moveToPoint.y = lineToPoint.y
                    }
                    lineToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    lineToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                    
                    drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
                
                case NSBezierPath.ElementType.closePath:
                    if (firstLineDrawn) {
                        moveToPoint.x = lineToPoint.x
                        moveToPoint.y = lineToPoint.y
                    }
                    lineToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    lineToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                    
                    drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
                case NSBezierPath.ElementType.curveTo:
                    break
                @unknown default:
                    break
                }
            }
            yOffset += wall.length * inchScale + padding
            
            // for walls that are being drawn in y direction, just set maxXSoFar as the widest wall drawn
            if (xOffset + wall.width * inchScale + padding > maxXSoFar) {
                maxXSoFar += wall.width * inchScale + padding
            }
        }
        return leftoverWalls
    }
    
    func drawLine(fromPoint: NSPoint, toPoint: NSPoint) {
        let path = NSBezierPath()
        NSColor.black.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 2.0
        path.stroke()
        firstLineDrawn = true
    }

}
