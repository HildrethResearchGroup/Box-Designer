//
//  PDFOptionsView.swift
//  Box Designer
//
//  Created by Audrey Horne on 9/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

//@IBDesignable
class PDFOptionsView: NSView {
    
    
    var fileHandlingControl = FileHandlingControl.shared
    @IBOutlet weak var pdfWidthTextField: NSTextField!
    @IBOutlet weak var pdfHeightTextField: NSTextField!
    @IBOutlet weak var margin: NSTextField!
    @IBOutlet weak var padding: NSTextField!
    
    @IBOutlet weak var oneComponentButton: NSButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
        
        if oneComponentButton.state == NSButton.StateValue.on {
            fileHandlingControl.oneComponent = true
        } else {
            fileHandlingControl.oneComponent = false
        }
    }
}
