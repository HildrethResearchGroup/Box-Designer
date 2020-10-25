//
//  FileHandlingControl.swift
//  Box Designer
//
//  Created by Grace Clark on 6/9/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit


class FileHandlingControl {
    
    static let shared = FileHandlingControl()
    var oneComponent = false
    var pdfHeight = 11.0 // default value in inches
    var pdfWidth = 8.5 // default value in inches
    var margin = 0.5
    var padding = 0.25
    var stroke = 3.0
    
    
    // this is the function that talks with the app menu for saving
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?) {
        
        guard let displayWindow = window else { return }
        let panel = NSSavePanel()
        
        // settings that allow user to save as only .json or .pdf
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowedFileTypes = ["pdf", "json"]
        panel.allowsOtherFileTypes = false
        
        
        // add accessory view for PDF options
        let accView = PDFOptionsView(frame: CGRect(x: 0, y: 0, width: 310, height: 267))
        panel.accessoryView = accView
        
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
                    BoxDesignerPDF(targetURL: url, boxModel).saveAsPDF()
                    //unowned let fileSaver = BoxDesignerPDF(targetURL: url, boxModel)
                    //fileSaver.saveAsPDF()
                    
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

