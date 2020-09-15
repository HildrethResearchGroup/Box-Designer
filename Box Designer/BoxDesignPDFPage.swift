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
    let margin : Double = 50.0
    let padding : Double = 25.0
    var firstLineDrawn = false
    
    init?(_ wallsToDraw : [WallModel]) {
        self.wallsToDraw = wallsToDraw
        super.init()
    }
    
    func drawPaths() {
        var xOffset = margin
        var yOffset = margin
        for wall in wallsToDraw {
            
            let path = wall.path
        
            var moveToPoint = NSPoint()
            
            var lineToPoint = NSPoint()
            //drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
            var startPoint = NSPoint()
            for element in 0..<path.elementCount {

                var point = NSPoint()
                let elementType = path.element(at: element, associatedPoints: &point)

                if element == 0 {
                    startPoint = point
                    firstLineDrawn = false
                }
                if (element > 0 && elementType == NSBezierPath.ElementType.moveTo && point == startPoint) {
                    break
                }
                
                switch (elementType) {
                case NSBezierPath.ElementType.moveTo:
                    moveToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    moveToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                    print("moveTo", moveToPoint)
                //toReturn += String(x) + " " + String(y) + " m "
                case NSBezierPath.ElementType.lineTo:
                    if (firstLineDrawn) {
                        moveToPoint.x = lineToPoint.x
                        moveToPoint.y = lineToPoint.y
                    }
                    lineToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    lineToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                    print("LineTo", moveToPoint, lineToPoint)
                    drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
                //toReturn += String(x) + " " + String(y) + " l "
                case NSBezierPath.ElementType.closePath:
                    if (firstLineDrawn) {
                        moveToPoint.x = lineToPoint.x
                        moveToPoint.y = lineToPoint.y
                    }
                    lineToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
                    lineToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
                    print("LineTo", moveToPoint, lineToPoint)
                    drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
                case NSBezierPath.ElementType.curveTo:
                    break
                @unknown default:
                    break
                }
            }
            yOffset += wall.length * inchScale + padding
        
        }
    }
    
    func drawLine(fromPoint: NSPoint, toPoint: NSPoint) {
        let path = NSBezierPath()
        NSColor.black.set()
        path.move(to: fromPoint)
        path.line(to: toPoint)
        path.lineWidth = 1.0
        path.stroke()
        firstLineDrawn = true
    }
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        super.draw(with: box, to: context)
        
        self.drawPaths()
        
    }
}


