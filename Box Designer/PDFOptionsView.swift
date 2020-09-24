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
    
    @IBOutlet var view: NSView!
    let fileHandlingControl = FileHandlingControl.shared
    @IBOutlet weak var pdfWidthTextField: NSTextField!
    @IBOutlet weak var pdfHeightTextField: NSTextField!
    @IBOutlet weak var margin: NSTextField!
    @IBOutlet weak var padding: NSTextField!
    @IBOutlet weak var stroke: NSTextField!
    
    @IBOutlet weak var oneComponentButton: NSButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("PDFOptionsView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
        
        awakeFromNib()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set default values in view
        pdfWidthTextField.doubleValue = fileHandlingControl.pdfWidth
        pdfHeightTextField.doubleValue = fileHandlingControl.pdfHeight
        margin.doubleValue = fileHandlingControl.margin
        padding.doubleValue = fileHandlingControl.padding
        stroke.doubleValue = fileHandlingControl.stroke
        
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
        
        fileHandlingControl.oneComponent = oneComponentButton.state == NSButton.StateValue.on
    }
    
    @IBAction func strokeTextFieldChanged(_ sender: Any) {
        fileHandlingControl.stroke = stroke.doubleValue
    }
}
