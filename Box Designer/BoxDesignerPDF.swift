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
    var wallsOnPage = [[WallModel]]()
    
    let pdfMargin: Double = 50.0
    let pdfPadding: Double = 25.0
    let pdfHeight: CGFloat = 1100.0
    let pdfWidth: CGFloat = 900.0
    
    init(targetURL: URL, _ boxModel: BoxModel) {
        
        self.boxModel = boxModel
        self.targetURL = targetURL
        
        // instantiate variables needed to draw to PDFPage
        mediaBox = CGRect(x: 0.0, y: 0.0, width: pdfWidth, height: pdfHeight)
        context = CGContext(targetURL as CFURL, mediaBox: &mediaBox, nil)
        nsContext = NSGraphicsContext(cgContext: context, flipped: true)
        //wallPathsToArrays()

    }
    
 //    this function allows you to specify which walls to draw on which pages
    func wallPathsToArrays() {
        var test = [WallModel]()
//        for now, just put all paths in this array
//            later, this can be specified to which paths to draw on a specific page
        for wall in boxModel.walls {
            test.append(wall)
        }
        addPage(test)

    }
    
    func addPage(_ walls: [WallModel]){
        // initialize custom PDF page
        let page = BoxDesignPDFPage(walls)!
        
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
    
    func defaultPDFDisplay() {
        // the number of walls you can fit on a page depends on the margin on both sides (2*margin), the padding between walls, and the wall length/width
        var wallPDFWidth: Double = pdfMargin*2
        var wallPDFHeight: Double = pdfMargin*2
        var test = [WallModel]()
        // iterate through walls and add new page if a wall would get cutoff in y direction
        for (index,wall) in boxModel.walls.enumerated() {
            
            if CGFloat(wallPDFHeight) > pdfHeight {
                wallPDFHeight = pdfMargin*2
                addPage(test)
                test = []
                
            } else if index == (boxModel.walls.endIndex-1) {
                test.append(wall)
                addPage(test)
                
            } else {
                test.append(wall)
                wallPDFHeight += wall.length*100.0 + pdfPadding
            }
            
        }

        // split walls into different arrays depending on number of pages
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
