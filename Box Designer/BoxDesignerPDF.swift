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
import CoreFoundation

class BoxDesignerPDF {
    
    let document = PDFDocument()
    let boxModel : BoxModel
    let targetURL : URL
    var pages = [BoxDesignPDFPage]()
    var context : CGContext!
    var nsContext : NSGraphicsContext
    var mediaBox: CGRect
    var fileHandlingControl = FileHandlingControl.shared
    let startTime : CFAbsoluteTime
    
    let inchScale = 100.0
    
    init(targetURL: URL, _ boxModel: BoxModel) {
        
        // set variables
        self.boxModel = boxModel
        self.targetURL = targetURL
        startTime = CFAbsoluteTimeGetCurrent()
        // instantiate variables needed to draw to PDFPage
        mediaBox = CGRect(x: 0.0, y: 0.0, width: CGFloat(fileHandlingControl.pdfWidth*inchScale), height: CGFloat(fileHandlingControl.pdfHeight*inchScale))
        context = CGContext(targetURL as CFURL, mediaBox: &mediaBox, nil)
        nsContext = NSGraphicsContext(cgContext: context, flipped: true)

    }
    
    func addPage(_ walls: [WallModel]) -> [WallModel]{
        // initialize custom PDF page
        let page = BoxDesignPDFPage(walls)!
        var leftoverWalls = [WallModel]()
        // set current context (NS not CG)
        NSGraphicsContext.current = nsContext
        
        // begin, draw, and end the PDF page on cg context
        context?.beginPDFPage(nil); do {
            
                page.draw(with: .mediaBox, to: context!)
            
            context?.saveGState(); do {
                leftoverWalls = page.drawPaths(for: .mediaBox)
            }; context?.restoreGState()
            
        }; context?.endPDFPage()
        // revert ns context setting to nil
        NSGraphicsContext.current = nil
        // add page to list of pages in doc
        pages.append(page)
        return leftoverWalls
    }
    
    // function to put each wall on its own PDF page in document
    func oneComponentPerPageLayout() {

        for wall in boxModel.walls {
            // don't need to save walls that weren't drawn for this function
            var _ = addPage([wall])
        }
    }
    
    // default PDF layout for user
    func defaultPDFDisplay() {
        
        var wallsToDraw = boxModel.walls
        // keep adding a new page until all walls are drawn
        while !wallsToDraw.isEmpty {
            wallsToDraw = addPage(wallsToDraw)
        }
    }
    
    func saveAsPDF() {
        
        // call function for whatever layout type was given
        fileHandlingControl.oneComponent ? oneComponentPerPageLayout() : defaultPDFDisplay()
        
        //add all pages to document
        for (index,pdfpage) in pages.enumerated() {
            document.insert(pdfpage, at: index)
            
        }
        // close context PDF and write to URL in context (targetURL)
        context?.closePDF()
        let endTime = CFAbsoluteTimeGetCurrent()
        print(endTime - startTime)
    }
}
