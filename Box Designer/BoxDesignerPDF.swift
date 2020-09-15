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
    var context : CGContext!
    var nsContext : NSGraphicsContext
    var mediaBox: CGRect
    let pdfHeight: CGFloat = 1100.0
    let pdfWidth: CGFloat = 800.0
    
    init(targetURL: URL, _ boxModel: BoxModel) {
        
        self.boxModel = boxModel
        self.targetURL = targetURL
        
        // instantiate variables needed to draw to PDFPage
        mediaBox = CGRect(x: 0.0, y: 0.0, width: pdfWidth, height: pdfHeight)
        context = CGContext(targetURL as CFURL, mediaBox: &mediaBox, nil)
        nsContext = NSGraphicsContext(cgContext: context, flipped: true)
        
        // for now, add page here until better functionality
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
        // initialize custom PDF page
        let page = BoxDesignPDFPage(paths)!
        
        // set current context (NS not CG)
        NSGraphicsContext.current = nsContext
        
        // begin, draw, and end the PDF page
        context?.beginPDFPage(nil); do {
            
            context?.saveGState(); do {
                page.draw(with: .mediaBox, to: context!)
            }; context?.restoreGState()
            
        }; context?.endPDFPage()
        NSGraphicsContext.current = nil
        // add page to list of pages in doc
        pages.append(page)

    }
    
    func saveAsPDF() {
        var index : Int = 0
        //add all pages to document
        for (pdfpage) in pages {
            document.insert(pdfpage, at: index)
            index += 1
        }
        // close PDF and write to URL in context (targetURL)
        context?.closePDF()
    }
}
