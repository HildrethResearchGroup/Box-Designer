//
//  PDFOptionsViewController.swift
//  Box Designer
//
//  Created by Audrey Horne on 9/23/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class PDFOptionsViewController: NSViewController {
    
    static func viewForPanel() -> NSView {
        let accVC = PDFOptionsViewController()
        let view = accVC.view as! AccessoryView
        view.setUp()
        return view
    }
    
}

// nested class because, specifically for an accessory view in NSSavePanel, you need an NSView, not NSViewController
class AccessoryView: NSView {
    
    let fileHandlingControl = FileHandlingControl.shared
    
    // text fields and buttons in view
    @IBOutlet weak var pdfWidthTextField: NSTextField!
    @IBOutlet weak var pdfHeightTextField: NSTextField!
    @IBOutlet weak var margin: NSTextField!
    @IBOutlet weak var padding: NSTextField!
    
    @IBOutlet weak var oneComponentButton: NSButton!
    
    func setUp() {
        // set default values
        pdfWidthTextField.doubleValue = fileHandlingControl.pdfWidth
        pdfHeightTextField.doubleValue = fileHandlingControl.pdfHeight
        margin.doubleValue = fileHandlingControl.margin
        padding.doubleValue = fileHandlingControl.padding
        oneComponentButton.state = NSButton.StateValue.off
    }
    
    @IBAction func widthTextFieldChanged(_ sender: Any) {
        fileHandlingControl.pdfWidth = pdfWidthTextField.doubleValue
    }
    
    @IBAction func heightTextFieldChanged(_ sender: Any) {
        fileHandlingControl.pdfHeight = pdfHeightTextField.doubleValue
    }
    
    @IBAction func marginTextFieldChanged(_ sender: Any) {
        fileHandlingControl.margin = margin.doubleValue
    }
    
    @IBAction func paddingTextFieldChanged(_ sender: Any) {
        fileHandlingControl.padding = padding.doubleValue
    }
    
    @IBAction func oneComponentClicked(_ sender: Any) {
        fileHandlingControl.oneComponent = oneComponentButton.state == .on
    }
}
