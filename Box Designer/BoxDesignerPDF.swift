import Foundation
import PDFKit
import Cocoa
import CoreFoundation
/**
 This class is the main driver for creating and drawing a completed PDF document of the current box model.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxDesignerPDF.swift was created on 9/13/2020.
 
 */
class BoxDesignerPDF {
    /// This variable instantiates a PDF document to be drawn on.
    let document = PDFDocument()
    /// This variable will be the box model that needs to be drawn.
    let boxModel : BoxModel
    /// This variable is an array of custom PDF pages that will be added to the document.
    var pages = [BoxDesignPDFPage]()
    /// This variable is the drawing environment.
    var context : CGContext!
    /// This variable is also the higher-level drawing environment.
    var nsContext : NSGraphicsContext
    /// This variable is the size of the PDF.
    var mediaBox: CGRect
    /// This variable is the singleton file handling control object.
    var fileHandlingControl = FileHandlingControl.shared
    /// This variable essentially converts inches to pixels.
    let inchScale = 100.0
    
    /**
     The initalizer for this class ensures that all variables need to draw to a PDFPage are instantiated.
     - Parameters:
        - targetURL: this is the path to where the user wants to save their PDF
        - boxModel: this is the box model that needs to be exported to PDF
     */
    init(targetURL: URL, _ boxModel: BoxModel) {
        
        // set variables from input parameters
        self.boxModel = boxModel
        // instantiate variables needed to draw to PDFPage
        mediaBox = CGRect(x: 0.0, y: 0.0, width: CGFloat(fileHandlingControl.pdfWidth*inchScale), height: CGFloat(fileHandlingControl.pdfHeight*inchScale))
        context = CGContext(targetURL as CFURL, mediaBox: &mediaBox, nil)
        nsContext = NSGraphicsContext(cgContext: context, flipped: true)

    }
    
    /**
     This function adds a custom PDF page to the PDF document. It uses the CG and NS Graphics Contexts to draw on the page.
    - Parameters:
        - walls: this input array are the walls the needs to be drawn on the page
    - Returns:
        - [WallModel]: this function returns an array that contains walls that would not fit on the PDF page (could be empty)
     */
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
    /**
     This function ensures only one wall is drawn on a single PDF page. Therefore, the number of PDF pages = the number of walls in the box model.
     */
    func oneComponentPerPageLayout() {

        for wall in boxModel.walls.values {
            // don't need to save walls that weren't drawn for this function because the for loop will ensure all walls are drawn
            var _ = addPage([wall])
        }
    }
    
    /**
     This function creates a PDF document with a default layout; the default layout is simply putting however many walls can fit onto a PDF page, and adding more pages as needed.
     - TODO: error handling if the wall components are all too big for the user-inputted size of the PDF
     */
    func defaultPDFDisplay() {
        var wallsToDraw = [WallModel]()
        for wall in boxModel.walls.values {
            wallsToDraw.append(wall)
        }
        // keep adding a new page until all walls are drawn
        while !wallsToDraw.isEmpty {
            wallsToDraw = addPage(wallsToDraw)
        }
    }
    /**
     This function is the main driver for saving the desired PDF. It decides which layout to initiate and then saves the finished PDF document to the user's chosen location.
     - Note: the saving location is known by the CG context variable, as it was initialized with the targetURL.
     */
    func saveAsPDF() {
        
        // call function for whatever layout type was given
        fileHandlingControl.oneComponent ? oneComponentPerPageLayout() : defaultPDFDisplay()
        
        //add all pages to document
        for (index,pdfpage) in pages.enumerated() {
            document.insert(pdfpage, at: index)
            
        }
        // close context PDF and write to URL that "context" is instantiated with (see init() for this class)
        context?.closePDF()

    }
}
