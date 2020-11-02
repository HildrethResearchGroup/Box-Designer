import Foundation
import Cocoa
import SceneKit
import PDFKit
/**
 This class is the main driver for creating and drawing a single PDF page of the box model walls.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxDesignPDFPage.swift was created on 5/27/2020.
 
 */
class BoxDesignPDFPage : PDFPage {
    /// This variable is the singleton file handling control object.
    var fileHandlingControl = FileHandlingControl.shared
    /// This variable is the array of walls that need to be drawn on the PDF page.
    var wallsToDraw : [WallModel]
    /// This variable is the conversion from inches to pixels.
    let inchScale : Double = 100.0
    /// This variable indicates whether the first line of the wall being drawn has been drawn (drawn is true, not drawn is false).
    var firstLineDrawn = false
    /**
     This initializer sets up the walls that need to be drawn on the PDF page.
     - Parameters:
        - wallsToDraw: this input is an array of walls that should be drawn on the PDF page.
     */
    init?(_ wallsToDraw : [WallModel]) {
        self.wallsToDraw = wallsToDraw
        super.init()
    }
    /**
     This function draws wall starting at the bottom left of the PDF page and going up, it then moves to the right and starts drawing up from the bottom again.
     - Parameters:
        - box: this is the display area the paths are drawn in
     - Returns:
        - [WallModel]: this functions returns any walls that would not fit on itself (the page) without getting cut off
     */
    func drawPaths(for box: PDFDisplayBox)->[WallModel] {
        // offsets from the edges of the PDF page
        var xOffset = fileHandlingControl.margin*inchScale
        var yOffset = fileHandlingControl.margin*inchScale
        var maxXSoFar = fileHandlingControl.margin*inchScale
        var leftoverWalls = [WallModel]()
        
        for wall in wallsToDraw {
            
            let path = wall.path
            var moveToPoint = NSPoint()
            var lineToPoint = NSPoint()
            
            // if vertical space is used up, change xOffset to be beside it, and reset y-offset so drawing starts at bottom of page again
            // only if there's still horizontal space though
            if (yOffset + wall.length * inchScale > fileHandlingControl.pdfHeight*inchScale - fileHandlingControl.margin*inchScale) {
                // if horizontal space is used up, add the wall to leftover walls and break so that the remaining walls (if any) can also be added
                if (maxXSoFar + wall.width * inchScale > fileHandlingControl.pdfWidth*inchScale - fileHandlingControl.margin*inchScale) {
                    leftoverWalls.append(wall)
                    continue
                } else {
                    // if vertical space is used up but horizontal isn't, reset xOffset to account for wall widths already drawn and reset yOffset ot be at the bottom of the page (accounting for margin)
                    xOffset = maxXSoFar
                    yOffset = fileHandlingControl.margin*inchScale
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
            yOffset += wall.length * inchScale + fileHandlingControl.padding*inchScale
            
            // for walls that are being drawn in y direction, just set maxXSoFar as the widest wall drawn
            if (xOffset + wall.width * inchScale + fileHandlingControl.padding*inchScale > maxXSoFar) {
                maxXSoFar += wall.width * inchScale + fileHandlingControl.padding*inchScale
            }
        }
        return leftoverWalls
    }
    /**
     This function does the actual drawing on the PDF page using the NSBezierPath.stroke() function.
    - Parameters:
        - fromPoint: the starting point for the line being drawn
        - toPoint: the end point for the line being drawn
     */
    func drawLine(fromPoint: NSPoint, toPoint: NSPoint) {
        let path = NSBezierPath()
        NSColor.black.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = CGFloat(fileHandlingControl.stroke)
        path.stroke()
        firstLineDrawn = true
    }

}
