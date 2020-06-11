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
    
    var modelUpdatingDelegate: modelUpdatingDelegate? = nil
    
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?) {
 
        guard let displayWindow = window else { return }
        let panel = NSSavePanel()
        
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowedFileTypes = ["json", "pdf"]
        panel.allowsOtherFileTypes = false
        
        panel.beginSheetModal(for: displayWindow) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else { return }
                let pathExtension = url.pathExtension
                switch (pathExtension) {
                case "json":
                    let fileSaver = JSONFileHandler()
                    do {
                        try fileSaver.saveAsJSON(to: url, boxModel)
                    } catch {
                        print("failed to save as a json file")
                    }
                case "pdf":
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
    
    func openModel(_ boxModel: BoxModel, _ window: NSWindow?) -> BoxModel {
        
        guard let displayWindow = window else { return boxModel }
        let panel = NSOpenPanel()
        var boxModel = BoxModel()
        
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["json"]
        panel.allowsOtherFileTypes = false
        
        panel.beginSheetModal(for: displayWindow) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {return}
                
                //need to json model
                let fileOpener = JSONFileHandler()
                do {
                    try boxModel = fileOpener.convertJSONToBoxModel(url)
                } catch {
                    print("could not save as a json file")
                }
            }
        }
        
        return boxModel
    }
}

protocol modelUpdatingDelegate {
    func updateModel(_ boxModel: BoxModel)
}
