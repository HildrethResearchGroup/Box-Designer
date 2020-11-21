import Foundation
import Cocoa
import SceneKit

/**
 This is the controlling class for exporting the custom box template to PDF or JSON, or opening a saved box template into the application via JSON file (JSON capabilities are implemented via native Swift Encoding/Decoding functionality).
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: FileHandlingControl.swift was created on 6/9/2020.
 
 */
class FileHandlingControl {
    
    /// This allows the FileHandlingControl to be a Singleton.
    static let shared = FileHandlingControl()
    /// This variable tells the PDF to print each component on its own page or not.
    var oneComponent = false
    /// This is the default PDF document height (in inches) for the option menu when saving.
    var pdfHeight = 11.0
    /// This is the default PDF document width (in inches) for the option menu when saving.
    var pdfWidth = 8.5
    /// This is the default PDF document margin (in inches) for the option menu when saving. It's the minimum distance between the side of the PDF document and the closest drawn component.
    var margin = 0.5
    /// This is the default PDF document padding (in inches) for the option menu when saving. It's the minimum distance between the components being drawn.
    var padding = 0.25
    /// This is the default PDF document stroke for the option menu when saving. It is the line thickness.
    var stroke = 3.0
    
    /**
     This is the function that instantiates a save panel in the desired window so that the user can save to their desired directory.
     - Parameters:
        - boxModel: This parameter ensures the user's current box model will be exported.
        - window: This parameter ensures the save panel is viewable in the application's window.
     */
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?) {
        /// Ensure the window is available and instantiate save panel.
        guard let displayWindow = window else { return }
        let panel = NSSavePanel()
        
        /// Set up panel attributes
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.allowedFileTypes = ["pdf", "json"]
        panel.allowsOtherFileTypes = false
        
        /// This instantiates an accessory view for the NSSavePanel -- it is a custom view outlined in this project (PDFOptionsView). It has hard-coded restraints (this could be changed to create the CGRect with constraints from the view).
        let accView = PDFOptionsView(frame: CGRect(x: 0, y: 0, width: 310, height: 267))
        panel.accessoryView = accView
        
        /// Open the view for the user to interact with
        panel.beginSheetModal(for: displayWindow) { (response) in
            if response == NSApplication.ModalResponse.OK {
                /// This gets the the user's desired location from the save panel in URL form.
                guard let url = panel.url else { return }
                let pathExtension = url.pathExtension
                switch (pathExtension) {
                case "json":
                    /// If user chooses to save as JSON, instantiate JSONEncoder().
                    let encoder = JSONEncoder()
                    var data = Data()
                    do {
                        data = try encoder.encode(boxModel)
                        let string = String(data: data, encoding: .utf8)
                        try string!.write(to: url, atomically: false, encoding: String.Encoding.utf8)
                    } catch {
                        print("Failed to save as a JSON file.")
                    }
                case "pdf":
                    /// If user chooses to save as PDF, instantiate BoxDesignerPDF() with the current box model and user's desired location, and then call its saveAsPDF() method.
                    BoxDesignerPDF(targetURL: url, boxModel).saveAsPDF()
                default:
                    break
                }
            }
        }
    }
    
    /**
     This is the function that opens a previously-saved box model (JSON format) into the application. It utilizes the JSONDecoder().
     - Returns:
        - BoxModel: This function, if successfully completed, returns a BoxModel object that can be displayed in the application.
     */
    func openModel() -> BoxModel {
        
        let panel = NSOpenPanel()
        /// Instantiate a BoxModel that will be adjusted according to the loading file's data.
        var newBoxModel = BoxModel()
        /// Set up panel attributes
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["json"]
        panel.allowsOtherFileTypes = false
        let response = panel.runModal()
        /// Open a file if the user clicks "OK" in the open panel.
        if response == NSApplication.ModalResponse.OK {
            /// Get the URL to the user's chosen file.
            guard let url = panel.url else {return newBoxModel}
            var data = Data()
            /// try to get data from json file
            do {
                data = try Data(String(contentsOf: url).utf8)
            } catch {
                print("Could not decode JSON.")
            }
            /// Instantiate the JSONDecoder and try to decode the data from the json file
            let decoder = JSONDecoder()
            do {
                newBoxModel = try decoder.decode(BoxModel.self, from: data)
            } catch {
                print("Could not open the desired Box Model.")
            }
        }
       // }
        /// Return the loaded box model  (or default) for user viewing in the application.
        return newBoxModel
    }
}

