//
//  BoxDesignPDF.swift
//  Box Designer
//
//  Created by Audrey Horne on 9/13/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import PDFKit
import Cocoa


class BoxDesignerPDF {
    
    let document = PDFDocument()
    let boxModel : BoxModel
    let targetURL : URL
    var pages = [BoxDesignPDFPage]()
    var nsimage : NSImage
    let pdfHeight: CGFloat = 1100.0
    let pdfWidth: CGFloat = 800.0
    
    init(targetURL: URL, _ boxModel: BoxModel) {
        
        self.boxModel = boxModel
        self.targetURL = targetURL
        // just for testing purposes
        nsimage = NSImage.init(size: NSMakeSize(pdfWidth, pdfHeight))
        let paths = wallPathsToArray()
        addPage(paths)
    }
    
    func wallPathsToArray() -> [NSBezierPath] {
        
        var paths = [NSBezierPath]()
        // for now, just put all paths in this array
        // later, this can be specified to which paths to draw on a specific page
//        for wall in boxModel.walls {
//            paths.append(wall.path)
//        }
        paths.append(boxModel.walls[0].path) // for testing, just try to draw one of the walls
        return paths
    }
    
    func addPage(_ paths: [NSBezierPath]){
        //var rect = NSMakeRect(CGFloat(0),CGFloat(0),pdfHeight,pdfWidth)
        
        let page = BoxDesignPDFPage(image: nsimage, paths)!
        let box = PDFDisplayBox(rawValue: 0)
        var pageRect = CGRect(x: 0, y: 0, width: 1100, height: 800) // this line is where we can change the PDF page size for later
        let dataConsumer = CGDataConsumer(url: targetURL as CFURL)
        
        let context = CGContext(consumer: dataConsumer!, mediaBox: &pageRect, nil)
        page.draw(with: box!, to: context!)
        pages.append(page)
        // CGContextRelease(context) // might need this line

    }
    
    func saveAsPDF() {
        var index : Int = 0
        // add all pages to document
        for pdfpage in pages {
            document.insert(pdfpage, at: index)
            index += 1
            
        }
        // write the document
        document.write(to: targetURL)
    }
}
