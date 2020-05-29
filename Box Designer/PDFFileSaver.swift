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
        //TODO: fill in as more details received
        
        //any scene parsing necessary
        
        //print to file with .pdf ending
        var textToWrite: String
        let beginText = "%PDF-1.6\n1 0 obj <</Type /Catalog /Pages 2 0 R>>\nendobj\n2 0 obj <</Type /Pages /Kids [3 0 R] /Count 1 /MediaBox [0 0 500 800]>>\nendobj\n3 0 obj <</Type /Page /Parent 2 0 R /Contents 4 0 R>>\nendobj\n4 0 obj\n"
        let beginStream = "<</Length /(stream.count + 2)>>\nstream\n"
        var stream: String = parseScene(sceneToParse: boxView.scene)//this will get filled in by some kind of parseModel() function
        let endTextandXRef = "\nendstream\nendobj\nxref\n0 5\n0000000000 65535 f\n0000000010 00000 n\n0000000059 00000 n\n0000000140 00000 n\n0000000202 00000 n\ntrailer <</Size 5 /Root 1 0 R>> \n"
        var bytesToStartRef: Int = beginText.count + beginStream.count
        bytesToStartRef += stream.count
        bytesToStartRef += endTextandXRef.count + 1
            //+ stream.size + endTextandXREF.size + 1
        let endText = "startxref\n" + String(bytesToStartRef) + "\n%%EOF"
        textToWrite = beginText + beginStream + stream + endTextandXRef + endText
        
    }
    
    func parseScene(sceneToParse scene: SCNScene!) ->String {
        //fill in with actual stuff when wall modelling is more concrete!
        var toReturn: String = "175 720 m 175 500 l h S"
        return toReturn
    }
    
}
