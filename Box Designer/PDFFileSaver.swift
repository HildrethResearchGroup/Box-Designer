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
    
    var pathsToDraw : [NSBezierPath]
    let inchScale : Double = 100.0
    let margin : Double = 50.0
    let padding : Double = 25.0
    var firstLineDrawn = false
    
    init?(image nsimage: NSImage, _ pathsToDraw : [NSBezierPath]) {
        self.pathsToDraw = pathsToDraw
        super.init(image: nsimage)
    }
    
    func drawPaths() {
        let xOffset = margin
        let yOffset = margin
        for path in pathsToDraw {
            var moveToPoint = NSPoint(x:100.0,y:100.0)
            //moveToPoint.convert(to: self)
            var lineToPoint = NSPoint(x: 200.0, y:200.0)
            drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
            var startPoint = NSPoint()
//            for element in 0..<path.elementCount {
//
//                var point = NSPoint()
//                let elementType = path.element(at: element, associatedPoints: &point)
//
//                if element == 0 {
//                    startPoint = point
//                    firstLineDrawn = false
//                }
//                if (element > 0 && elementType == NSBezierPath.ElementType.moveTo && point == startPoint) {
//                    break
//                }
//                print(elementType)
//                // TO-DO: need to refactor this block to account for the path being move,line,line,line,line,close NOT move,line,move,line,..,close
//                switch (elementType) {
//                case NSBezierPath.ElementType.moveTo:
//                    moveToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
//                    moveToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
//                    print("moveTo")
//                //toReturn += String(x) + " " + String(y) + " m "
//                case NSBezierPath.ElementType.lineTo:
//                    if (firstLineDrawn) {
//                        moveToPoint.x = lineToPoint.x * CGFloat(inchScale) + CGFloat(xOffset)
//                        moveToPoint.y = lineToPoint.y * CGFloat(inchScale) + CGFloat(yOffset)
//                    }
//                    lineToPoint.x = point.x * CGFloat(inchScale) + CGFloat(xOffset)
//                    lineToPoint.y = point.y * CGFloat(inchScale) + CGFloat(yOffset)
//                    print("LineTo")
//                    drawLine(fromPoint: moveToPoint, toPoint: lineToPoint)
//                //toReturn += String(x) + " " + String(y) + " l "
//                case NSBezierPath.ElementType.closePath:
//                    break
//                case NSBezierPath.ElementType.curveTo:
//                    break
//                @unknown default:
//                    break
//                }
//            }
            //yOffset += wall.length * inchScale + padding
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
        var graphicsContext = NSGraphicsContext(cgContext: context, flipped: true)
        graphicsContext.saveGraphicsState()
        NSGraphicsContext.restoreGraphicsState()
        
        
        self.drawPaths()
    }
}





//    func saveAsPDF(to targetURL: URL, _ boxModel: BoxModel) throws {
//
//        //print to file with .pdf ending
//        //url is received from NSSavePanel above
//
//        let pdfDoc = PDFDocument()
//        let testPage = PDFPage()
//        let inchScale: Double = 100.0
//        let margin: Double = 50.0
//        let padding: Double = 25.0
//        var yOffset = margin
//        var xOffset = margin
//        var startPoint = NSPoint()
//        testPage.draw(with: <#T##PDFDisplayBox#>, to: <#T##CGContext#>)
//        let path = boxModel.walls[0].path
//
//        for element in 0..<path.elementCount {
//            var x : CGFloat
//            var y : CGFloat
//            var point = NSPoint()
//
//            let elementType = path.element(at: element, associatedPoints: &point)
//
//            if element == 0 {
//                startPoint = point
//            }
//            if (element > 0 && elementType == NSBezierPath.ElementType.moveTo && point == startPoint) {
//                break
//            }
//
//            /*
//             Points in the path are stored as CGFloat.
//             However, CGFloat does not conform to "LosslessStringConvertible".
//             Doubles, on the other hand, do; so, convert
//             the x and y values to type Double, then
//             to type String.
//
//             At this time, margin and padding are also taken into account
//             */
//
//
//            switch (elementType) {
//            case NSBezierPath.ElementType.moveTo:
//                var movePoint = NSPoint(x: point.x * CGFloat(inchScale) + CGFloat(xOffset),y: point.y * CGFloat(inchScale) + CGFloat(yOffset))
//                //toReturn += String(x) + " " + String(y) + " m "
//            case NSBezierPath.ElementType.lineTo:
//
//                //toReturn += String(x) + " " + String(y) + " l "
//            case NSBezierPath.ElementType.closePath:
//                toReturn += "h S\n"
//            case NSBezierPath.ElementType.curveTo:
//                break
//            @unknown default:
//                break
//            }
//        }
//        // yOffset += wall.length * inchScale + padding
//    }







//            var textToWrite: String //this will hold the eventual finished string

//            /* beginText holds all the beginning info; pdf type, object1: dict of what's in the pdf, obj2: list of pages in the pdf (here 1) and size of page, obj3: page and reference to its contents, obj4: list of cotents of page (which is a stream - the rest is supplied by beginStream and stream strings)
//             */
//            let beginText = "%PDF-1.6\n1 0 obj <</Type /Catalog /Pages 2 0 R>>\nendobj\n2 0 obj <</Type /Pages /Kids [3 0 R] /Count 1 /MediaBox [0 0 1900 1100]>>\nendobj\n3 0 obj <</Type /Page /Parent 2 0 R /Contents 4 0 R>>\nendobj\n4 0 obj\n"
//
//            //stream holds the drawing directions for the box layouts
//            //var stream: String = mainViewController.parseScene()
//            //let stream: String = convertModelToStream(boxModel)
//
//            //beginStream needs to know the length of the stream; this is determined after stream is assigned above
//            let beginStream = "<</Length \(stream.count + 2)>>\nstream\n"
//
//            //this info finishes of the stream and the file
//            let endTextandXRef = "endstream\nendobj\nxref\n0 5\n0000000000 65535 f\n0000000010 00000 n\n0000000059 00000 n\n0000000142 00000 n\n0000000204 00000 n\ntrailer <</Size 5 /Root 1 0 R>> \n"
//
//            //need to know the number of bytes until startxref is called which is below
//            var bytesToStartRef: Int = beginText.count + beginStream.count
//            bytesToStartRef += stream.count
//            bytesToStartRef += endTextandXRef.count + 1
//
//            //add in last info: startxref call, number of bytes, and %%EOF line
//            let endText = "startxref\n" + String(bytesToStartRef) + "\n%%EOF"
//
//            //voila, your PDF is done; put it all together into one string...
//            textToWrite = beginText + beginStream + stream + endTextandXRef + endText
//
//            //then write to the file specified in the url given by the function
//            try textToWrite.write(to: targetURL, atomically: false, encoding: String.Encoding.utf8)
//        } catch {
//            print("failed to save as a pdf")
//        }



//func convertModelToStream(_ boxModel: BoxModel) ->Data {
//
//    var toReturn = String()
//
//    let inchScale: Double = 100.0
//    let margin: Double = 50.0 //half an inch margin from the edge
//    let padding: Double = 25.0 //quarter of an inch padding between
//
//    var maxXSoFar: Double = 0
//    var xOffset: Double = margin
//
//    var allWalls = [[WallModel]]()
//    var smallCornerWalls: [WallModel] = Array()
//    var longCornerWalls: [WallModel] = Array()
//    var largeCornerWalls: [WallModel] = Array()
//
//    var leftoverWalls: [WallModel] = Array()
//
//    for wall in boxModel.walls {
//        switch (wall.wallType) {
//        case WallType.smallCorner:
//            smallCornerWalls.append(wall)
//        case WallType.longCorner:
//            longCornerWalls.append(wall)
//        case WallType.largeCorner:
//            largeCornerWalls.append(wall)
//        }
//    }
//
//    // add the arrays of different types of walls to a main array that we can loop through
//    allWalls.append(largeCornerWalls)
//    allWalls.append(longCornerWalls)
//    allWalls.append(smallCornerWalls)
//    allWalls.append(leftoverWalls)
//
//
//    // loop through the different wall types
//    // must use 0..<count method so that the actual allWalls array is updated, not just the copy (this is important for assessing the emptiness of leftoverWalls
//    // this has been refactored by Audrey from the original code
//    for index in 0..<allWalls.count {
//
//        if !allWalls[index].isEmpty {
//
//            maxXSoFar = 0
//            var yOffset: Double = margin
//
//            for wall in allWalls[index] {
//
//                let tabWidth = wall.nTab ?? 0
//
//                // this statement should catch whether string will be drawn off side of page
//                // if it will be, it adds the wall to leftoverWalls and is dealt with afterward
//                // NOTE: walls still get cutoff with this method, needs to be refactored!
//                if (yOffset + (wall.length + tabWidth) * inchScale) > 1100 {
//                    leftoverWalls.append(wall)
//                    let leftoverOffset: Int = 3 - index
//                    // if this isn't the leftoverWalls array, add the wall to that array and break this loop
//                    if index != 3 {
//                        allWalls[index+leftoverOffset] = leftoverWalls
//                        break
//                    }
//                }
//
//
//                if wall.width > maxXSoFar {
//                    maxXSoFar = wall.width * inchScale
//                }
//
//                let path = wall.path
//                var startPoint = NSPoint()
//
//                // this for loop converts each element of the path to a string and adds it to the main string that will be written
//                // NOTE: when we add extra pages, we will need separate strings for each PDF page
//                for element in 0..<path.elementCount {
//
//                    var point = NSPoint()
//                    let elementType = path.element(at: element, associatedPoints: &point)
//
//                    if element == 0 {
//                        startPoint = point
//                    }
//                    /*
//                     last element in every path seems to be a repeat of first element
//                     this obviously does not need to be drawn, and doing so
//                     actually prevents the pdf from displaying.
//                     */
//                    if (element > 0 && elementType == NSBezierPath.ElementType.moveTo && point == startPoint) {
//                        break
//                    }
//
//                    /*
//                     Points in the path are stored as CGFloat.
//                     However, CGFloat does not conform to "LosslessStringConvertible".
//                     Doubles, on the other hand, do; so, convert
//                     the x and y values to type Double, then
//                     to type String.
//
//                     At this time, margin and padding are also taken into account
//                     */
//                    let x: Double = Double(point.x) * inchScale + xOffset
//                    let y: Double = Double(point.y) * inchScale + yOffset
//
//                    switch (elementType) {
//                    case NSBezierPath.ElementType.moveTo:
//                        toReturn += String(x) + " " + String(y) + " m "
//                    case NSBezierPath.ElementType.lineTo:
//                        toReturn += String(x) + " " + String(y) + " l "
//                    case NSBezierPath.ElementType.closePath:
//                        toReturn += "h S\n"
//                    case NSBezierPath.ElementType.curveTo:
//                        break
//                    @unknown default:
//                        break
//                    }
//                }
//                yOffset += wall.length * inchScale + padding
//            }
//        }
//        xOffset += maxXSoFar + padding
//
//    }
//
//    if let data = toReturn.data(using: .utf8) {
//        print("hi")
//        return data
//    }
//    let nullData = Data()
//    return nullData
//}


