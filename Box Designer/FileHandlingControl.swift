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
    
    // var modelUpdatingDelegate: modelUpdatingDelegate? = nil **Audrey greyed this out for now, don't think it's needed, but want to make sure before deleting
    
    // this is the function that talks with the app menu for saving
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?) {
 
        guard let displayWindow = window else { return }
        let panel = NSSavePanel()
        
        // settings that allow user to save as only .json or .pdf
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowedFileTypes = ["json", "pdf"]
        panel.allowsOtherFileTypes = false
        
        // file saves according to user input (.json or .pdf)
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
                        print("Failed to save as a JSON file.")
                    }
                case "pdf":
                    let fileSaver = PDFFileSaver()
                    do {
                        try fileSaver.saveAsPDF(to: url, boxModel)
                    } catch {
                        print("Failed to save as a PDF.")
                    }
                default:
                    break
                }
            }
        }
    }
    
    // this function allows users to upload a box model into the app
    func openModel(_ boxModel: BoxModel, _ window: NSWindow?) -> BoxModel {
        
        guard let displayWindow = window else { return boxModel }
        let panel = NSOpenPanel()
        var boxModel = BoxModel()
        
        // set so use can only choose a file of type .json to upload a box
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
                    print("Could not open as a json file.")
                }
            }
        }
        
        return boxModel
    }
}

// Audrey is commenting out this for now to make sure it's not doing anything -- will get rid of it after ensuring there won't be repercussions
//protocol modelUpdatingDelegate {
//    func updateModel(_ boxModel: BoxModel)
//}
