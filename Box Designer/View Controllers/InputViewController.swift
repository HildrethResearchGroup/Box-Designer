//
//  InputViewController.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class InputViewController: NSViewController, NSTextDelegate { // modelUpdatingDelegate **Audrey greyed this out for now, don't think it's needed, but want to make sure before deleting
    
    var boxModel = BoxModel()
    
    var fileHandlingDelegate : FileHandlingDelegate = FileHandlingControl()
    
    @IBOutlet weak var mmMenu: NSMenuItem!
    @IBOutlet weak var inchMenu: NSMenuItem!
    
    // user-input text fields for dimensions
    @IBOutlet weak var lengthTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var materialThicknessTextField: NSTextField!
    
    @IBOutlet weak var innerOrOuterDimensionControl: NSSegmentedCell!
    @IBOutlet weak var joinTypeControl: NSSegmentedControl!
    
    @IBOutlet weak var tabWidthLabel: NSTextField!
    @IBOutlet weak var tabWidthSlider: NSSlider!
    
    @IBOutlet weak var lidOn_Off: NSButton!
    
    // labels for respective text fields
    @IBOutlet weak var lengthLabel: NSTextField!
    @IBOutlet weak var widthLabel: NSTextField!
    @IBOutlet weak var heightLabel: NSTextField!
    @IBOutlet weak var thicknessLabel: NSTextField!
    
    @IBOutlet weak var plusButtonLengthwise: NSButton!
    @IBOutlet weak var minusButtonLengthwise: NSButton!
    
    @IBOutlet weak var exportToPDF: NSButton!
    
    
    //mm is true and inch is false
    private var mmInch: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boxModel = BoxModel()
        lengthTextField.doubleValue = boxModel.boxLength
        widthTextField.doubleValue = boxModel.boxWidth
        heightTextField.doubleValue = boxModel.boxHeight
        materialThicknessTextField.doubleValue = boxModel.materialThickness
                
        innerOrOuterDimensionControl.selectSegment(withTag: 0)
        joinTypeControl.selectSegment(withTag: 0)
        
        tabWidthSlider.isEnabled = false
        changeLabels(mmInch)
        boxModel.sceneGenerator.generateScene(boxModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // function to update labels according to user selection
    func changeLabels(_ unit : Bool) {
        var unitString: String
        // false is inches, true is mm
        if unit{
            unitString = "(mm)"
        } else{
            unitString = "(in)"
        }
        // change label units for user reference
        lengthLabel.stringValue = "Length " + unitString
        widthLabel.stringValue = "Width " + unitString
        heightLabel.stringValue = "Height " + unitString
        thicknessLabel.stringValue = "Material Thickness " + unitString
    }
    
    @IBAction func mmMenuClicked(_ sender: Any) {
        if !mmInch{
            mmMenu.state = NSControl.StateValue.on
            inchMenu.state = NSControl.StateValue.off
            
            //the units are inches so adj to mm
            lengthTextField.doubleValue = boxModel.boxLength * 25.4
            widthTextField.doubleValue = boxModel.boxWidth * 25.4
            heightTextField.doubleValue = boxModel.boxHeight * 25.4
            materialThicknessTextField.doubleValue = boxModel.materialThickness * 25.4
            mmInch = true
            changeLabels(mmInch)

        }
    }
    
    @IBAction func inchMenuClicked(_ sender: Any) {
        //changing the units only changes the displayed amount not the model size
        if mmInch{
            mmMenu.state = NSControl.StateValue.off
            inchMenu.state = NSControl.StateValue.on
            
            //the units are inches so just set it back
            lengthTextField.doubleValue = boxModel.boxLength
            widthTextField.doubleValue = boxModel.boxWidth
            heightTextField.doubleValue = boxModel.boxHeight
            materialThicknessTextField.doubleValue = boxModel.materialThickness
            mmInch = false
            changeLabels(mmInch)
            //set the limits second because otherwise the adjustment is incorect
        }
    }
    
    @IBAction func lengthTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.boxLength = lengthTextField.doubleValue * (1/25.4)
        }else{
            //if the setting is in inches
           boxModel.boxLength = lengthTextField.doubleValue
        }
    }
    
    @IBAction func widthTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.boxWidth = widthTextField.doubleValue * (1/25.4)
        }else{
            //if the setting is in inches
            boxModel.boxWidth = widthTextField.doubleValue
        }
    }
    
    @IBAction func heightTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.boxHeight = heightTextField.doubleValue * (1/25.4)
        }else{
            //if the setting is in inches
            boxModel.boxHeight = heightTextField.doubleValue
        }
    }
    
    @IBAction func materialThicknessTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.materialThickness = materialThicknessTextField.doubleValue * (1/25.4)
        }else{
            //if the setting is in inches
            boxModel.materialThickness = materialThicknessTextField.doubleValue
        }
        
    }
    
    @IBAction func innerOrOuterDimensionsSelected(_ sender: Any) {
        let choice = innerOrOuterDimensionControl.selectedSegment
        if choice == 0 {
            boxModel.innerDimensions = false
        } else if choice == 1 {
            boxModel.innerDimensions = true
        }
    }
    
    @IBAction func joinTypeSelected(_ sender: Any) {
        let choice = joinTypeControl.selectedSegment
        if choice == 0 {
            boxModel.joinType = JoinType.overlap
            tabWidthSlider.isEnabled = false
        } else if choice == 1 {
            boxModel.joinType = JoinType.tab
            tabWidthSlider.isEnabled = true
        }
    }
    
    @IBAction func tabWidthChanged(_ sender: Any) {
        boxModel.nTab = tabWidthSlider.doubleValue
    }
    
    @IBAction func setLid_On_Off(_ sender: Any) {

        boxModel.lidOn = !boxModel.lidOn

    }
    
    @IBAction func menuFileOpenItemSelected(_ sender: Any) {
        let newBoxModel = fileHandlingDelegate.openModel(boxModel, self.view.window)
        self.boxModel = newBoxModel
        //reset all displays to be correct
        boxModel.sceneGenerator.generateScene(self.boxModel)
    }
    
    @IBAction func menuFileSaveItemSelected(_ sender: Any) {
        fileHandlingDelegate.saveModel(boxModel, self.view.window)
    }
    
    // right now, the button just does the same as the menu option
    // the functionality in this will be changed for one of the requirements (swift archiving capabilities)
    @IBAction func exportToPDFClicked(_ sender: Any) {
        fileHandlingDelegate.saveModel(boxModel, self.view.window)
    }
    
    func updateModel(_ boxModel: BoxModel) {
        self.boxModel = boxModel
        boxModel.sceneGenerator.generateScene(boxModel)
    }

    @IBAction func plusButtonLengthwise(_ sender: Any) {
        // for now, only allow two separators
        // this conditional accounts for the fact that the user may click the '+' button multiple times, even if it's not doing anything
        // if there are already max separators, don't need to increment counterLength
        if boxModel.counterLength <  2 {
            boxModel.counterLength += 1
            boxModel.lengthWall = true
        }
    }
    
    @IBAction func minusButtonLengthwise(_ sender: Any) {
        boxModel.removeInnerWall = true
    }
}

protocol FileHandlingDelegate {
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?)
    func openModel(_ boxModel: BoxModel, _ window: NSWindow?) -> BoxModel
}
