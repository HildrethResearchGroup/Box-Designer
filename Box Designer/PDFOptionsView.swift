//
//  PDFOptionsView.swift
//  Box Designer
//
//  Created by CSM Field Session Fall 2020 on 9/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

/**
This class is the accessory view that's included in the save panel when exporting the box template to PDF or JSON.
 
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: PDFOptionsView.swift was created on 9/22/2020.
 
 */
class PDFOptionsView: NSView {
    /// This variable is the view object that is displayed in the NSSavePanel instantiated in FileHandlingControl.
    @IBOutlet var view: NSView!
    /// This variable is the singleton file handling control.
    let fileHandlingControl = FileHandlingControl.shared
    /// This variable is the PDF width textbox that the user can change.
    @IBOutlet weak var pdfWidthTextField: NSTextField!
    /// This variable is the PDF height textbox that the user can change.
    @IBOutlet weak var pdfHeightTextField: NSTextField!
    /// This variable is the PDF margin textbox that the user can change.
    @IBOutlet weak var margin: NSTextField!
    /// This variable is the padding between drawn components on the PDF that the user can change.
    @IBOutlet weak var padding: NSTextField!
    /// This variable is the line thickness for the components drawn on the PDF, which the user can change.
    @IBOutlet weak var stroke: NSTextField!
    /// This variable is the check box that indicates whether the user wants each component on a separate page, or the default layout (checked = one component on each page).
    @IBOutlet weak var oneComponentButton: NSButton!
    /**
     This is an inherited initializer. See [Apple Documentation - NSView.init()] (https://developer.apple.com/documentation/appkit/nsview/1483458-init) for more information.
     - Parameters:
        - frame: this is the area the view will be constrained to.
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    /**
     This function allows the .xib file associated with this view (PDFOptionsView.xib) to be translated from interface builder to actual code.
     - Parameters:
        - aDecoder: See [Apple Documentation - NSCoder.] (https://developer.apple.com/documentation/foundation/nscoder)
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    /**
     This function is the main (custom) initializer for the view. It ensures the .xib file is what's being shown in the this view.
     */
    func commonInit() {
        
        Bundle.main.loadNibNamed("PDFOptionsView", owner: self, topLevelObjects: nil)
        self.view.frame = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(self.view)
        
        awakeFromNib()
    }
    /**
     This function provides the default values for the textboxes and checkbox. For more information on this inherited function, see [Apple Documentation - awakeFromNib().] (https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib)
     */
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
    /**
     This function updates the singleton file handling control object with the PDF width value from this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func widthTextFieldChanged(_ sender: Any) {
        fileHandlingControl.pdfWidth = pdfWidthTextField.doubleValue
    }
    /**
     This function updates the singleton file handling control object with the PDF height value from this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func heightTextFieldChanged(_ sender: Any) {
        fileHandlingControl.pdfHeight = pdfHeightTextField.doubleValue
    }
    /**
     This function updates the singleton file handling control object with the PDF margin value from this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func marginTextFieldChanged(_ sender: Any) {
        fileHandlingControl.margin = margin.doubleValue
    }
    /**
     This function updates the singleton file handling control object with the PDF padding value from this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func paddingTextFieldChanged(_ sender: Any) {
        fileHandlingControl.padding = padding.doubleValue
    }
    /**
     This function updates the singleton file handling control object with the decision from the One Component checkbox in this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func oneComponentClicked(_ sender: Any) {
        
        fileHandlingControl.oneComponent = oneComponentButton.state == NSButton.StateValue.on
    }
    /**
     This function updates the singleton file handling control object with the PDF stroke value from this view.
     - Parameters:
        - sender: we don't care who the sender is (this function is only associated with one IBOutlet)
     */
    @IBAction func strokeTextFieldChanged(_ sender: Any) {
        fileHandlingControl.stroke = stroke.doubleValue
    }
}
