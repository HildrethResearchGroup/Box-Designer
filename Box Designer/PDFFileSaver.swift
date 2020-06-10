//
//  PDFFileSaver.swift
//  Box Designer
//
//  Created by Grace Clark on 5/27/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit


class PDFFileSaver {
    
    func saveAsPDF(to targetURL: URL, _ boxModel: BoxModel) throws {
        print("saving as PDF")
        do {
            //print to file with .pdf ending
            //url is received from NSSavePanel above
            var textToWrite: String //this will hold the eventual finished string
        
            /* beginText holds all the beginning info; pdf type, object1: dict of what's in the pdf, obj2: list of pages in the pdf (here 1) and size of page, obj3: page and reference to its contents, obj4: list of cotents of page (which is a stream - the rest is supplied by beginStream and stream strings)
            */
            let beginText = "%PDF-1.6\n1 0 obj <</Type /Catalog /Pages 2 0 R>>\nendobj\n2 0 obj <</Type /Pages /Kids [3 0 R] /Count 1 /MediaBox [0 0 1900 1100]>>\nendobj\n3 0 obj <</Type /Page /Parent 2 0 R /Contents 4 0 R>>\nendobj\n4 0 obj\n"
        
            //stream holds the drawing directions for the box layouts
            //var stream: String = mainViewController.parseScene()
            let stream: String = convertModelToStream(boxModel)
            
            //beginStream needs to know the length of the stream; this is determined after stream is assigned above
            let beginStream = "<</Length \(stream.count + 2)>>\nstream\n"
        
            //this info finishes of the stream and the file
            let endTextandXRef = "endstream\nendobj\nxref\n0 5\n0000000000 65535 f\n0000000010 00000 n\n0000000059 00000 n\n0000000142 00000 n\n0000000204 00000 n\ntrailer <</Size 5 /Root 1 0 R>> \n"
        
            //need to know the number of bytes until startxref is called which is below
            var bytesToStartRef: Int = beginText.count + beginStream.count
            bytesToStartRef += stream.count
            bytesToStartRef += endTextandXRef.count + 1
        
            //add in last info: startxref call, number of bytes, and %%EOF line
            let endText = "startxref\n" + String(bytesToStartRef) + "\n%%EOF"
        
            //voila, your PDF is done; put it all together into one string...
            textToWrite = beginText + beginStream + stream + endTextandXRef + endText
        
            //then write to the file specified in the url given by the function
            try textToWrite.write(to: targetURL, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("failed to save as a pdf")
        }
    }
    
    func convertModelToStream(_ boxModel: BoxModel) ->String {
        
        var toReturn = String()
        
        let inchScale: Double = 100.0
        let margin: Double = 50.0 //half an inch margin from the edge
        let padding: Double = 50.0 //half an inch padding between
        
        var maxXSoFar: Double = 0
        var maxYSoFar: Double = 0
        
        var counter: Int = 0
        
        for wall in boxModel.walls {

            let path = wall.path
            var startPoint = NSPoint()
            
            var xOffset: Double = 0
            var yOffset: Double = 0
            
            if counter % 2 == 0 {
                maxYSoFar = 0 //reset maxYSoFar after moving horizontally
                xOffset = maxXSoFar + margin
                yOffset = margin
            } else if counter % 2 == 1 {
                xOffset = maxXSoFar + margin
                yOffset = maxYSoFar + margin
            }
            
            for element in 0..<path.elementCount {
                
                var point = NSPoint()
                let elementType = path.element(at: element, associatedPoints: &point)
                
                if element == 0 {
                    startPoint = point
                }
                /*
                 last element in every path seems to be a repeat of first element
                 this obviously does not need to be drawn, and doing so
                 actually prevents the pdf from displaying.
                 */
                if (element > 0 && elementType == NSBezierPath.ElementType.moveTo && point == startPoint) {
                    break
                }
                
                /*
                 Points in the path are stored as CGFloat.
                 However, CGFloat does not conform to "LosslessStringConvertible".
                 Doubles, on the other hand, do; so, convert
                 the x and y values to type Double, then
                 to type String.
                 
                 At this time, margin and padding are also taken into account
                 */
                let x: Double = Double(point.x) * inchScale + xOffset
                let y: Double = Double(point.y) * inchScale + yOffset
                
                if (x > maxXSoFar && counter % 2 == 1) {
                    maxXSoFar = x
                }
                if (y > maxYSoFar) {
                    maxYSoFar = y
                }
                
                switch (elementType) {
                case NSBezierPath.ElementType.moveTo:
                    toReturn += String(x) + " " + String(y) + " m "
                case NSBezierPath.ElementType.lineTo:
                    toReturn += String(x) + " " + String(y) + " l "
                case NSBezierPath.ElementType.closePath:
                    toReturn += "h S\n"
                case NSBezierPath.ElementType.curveTo:
                    break
                @unknown default:
                    break
                }
            }
            counter += 1
        }
        return toReturn
    }
    
}
