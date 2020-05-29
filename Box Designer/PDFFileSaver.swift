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
    
    func saveAsPDF(to targetURL: URL) {
        
        do {
            //print to file with .pdf ending
            //url is received from NSSavePanel above
            var textToWrite: String //this will hold the eventual finished string
        
            /* beginText holds all the beginning info; pdf type, object1: dict of what's in the pdf, obj2: list of pages in the pdf (here 1) and size of page, obj3: page and reference to its contents, obj4: list of cotents of page (which is a stream - the rest is supplied by beginStream and stream strings)
            */
            let beginText = "%PDF-1.6\n1 0 obj <</Type /Catalog /Pages 2 0 R>>\nendobj\n2 0 obj <</Type /Pages /Kids [3 0 R] /Count 1 /MediaBox [0 0 500 800]>>\nendobj\n3 0 obj <</Type /Page /Parent 2 0 R /Contents 4 0 R>>\nendobj\n4 0 obj\n"
        
            //stream holds the drawing directions for the box layouts
            var stream: String = mainViewController.parseScene()
        
            //beginStream needs to know the length of the stream; this is determined after stream is assigned above
            let beginStream = "<</Length \(stream.count + 2)>>\nstream\n"
        
            //this info finishes of the stream and the file
            let endTextandXRef = "\nendstream\nendobj\nxref\n0 5\n0000000000 65535 f\n0000000010 00000 n\n0000000059 00000 n\n0000000140 00000 n\n0000000202 00000 n\ntrailer <</Size 5 /Root 1 0 R>> \n"
        
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
            print("Could not save as a PDF")
        }
    }
    
   /* func parseScene(sceneToParse scene: SCNScene!) ->String {
        //fill in with actual stuff when wall modelling is more concrete!
        var toReturn: String = "175 720 m 175 500 l h S"
        return toReturn
    }*/
    
}
