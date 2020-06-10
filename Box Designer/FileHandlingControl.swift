//
//  FileHandlingControl.swift
//  Box Designer
//
//  Created by Grace Clark on 6/9/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

class FileHandlingControl: FileHandlingDelegate {
    
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?) {
 
        guard let displayWindow = window else { return }
        let panel = NSSavePanel()
        
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowedFileTypes = ["xml", "pdf"]
        panel.allowsOtherFileTypes = false
        
        panel.beginSheetModal(for: displayWindow) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else { return }
                let pathExtension = url.pathExtension
                switch (pathExtension) {
                case "xml":
                    print("saving as an xml doc")
                    let fileSaver = XMLFileSaver()
                    fileSaver.saveAsXML(to: url, boxModel)
                case "pdf":
                    print("saving as a pdf doc")
                    let fileSaver = PDFFileSaver()
                    do {
                        try fileSaver.saveAsPDF(to: url, boxModel)
                    } catch {
                        print("failed to save as a pdf")
                    }
                default:
                    break
                }
            }
        }
    }
    
    func openModel(_ boxModel: BoxModel, _ window: NSWindow?) {
        
        guard let displayWindow = window else { return }
        let panel = NSOpenPanel()
        
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["xml"]
        panel.allowsOtherFileTypes = false
        
        panel.beginSheetModal(for: displayWindow) { (response) in
            if response == NSApplication.ModalResponse.OK {
                //need to parse MODEL information saved however
                
            }
        }
    }
}


