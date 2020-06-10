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

class InputViewController: NSViewController, NSTextDelegate {
    
    var boxModel = BoxModel()
    
    @IBOutlet weak var lengthTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var materialThicknessTextField: NSTextField!
    
    @IBOutlet weak var innerOrOuterDimensionControl: NSSegmentedCell!
    @IBOutlet weak var joinTypeControl: NSSegmentedControl!
    
    @IBOutlet weak var tabWidthLabel: NSTextField!
    @IBOutlet weak var tabWidthSlider: NSSlider!
    
    @IBOutlet weak var addWall: NSButton!
    @IBOutlet weak var lidOn_Off: NSButton!
    
    
    @IBOutlet weak var plusButtonLengthwise: NSButton!
    @IBOutlet weak var minusButtonLengthwise: NSButton!
    
    
    
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
        
        boxModel.sceneGenerator.generateScene(boxModel)
    }
    
    @IBAction func lengthTextFieldDidChange(_ sender: Any) {
        boxModel.boxLength = lengthTextField.doubleValue
        setSliderLimits()
    }
    
    @IBAction func widthTextFieldDidChange(_ sender: Any) {
        boxModel.boxWidth = widthTextField.doubleValue
        setSliderLimits()
    }
    
    @IBAction func heightTextFieldDidChange(_ sender: Any) {
        boxModel.boxHeight = heightTextField.doubleValue
        setSliderLimits()
    }
    
    @IBAction func materialThicknessTextFieldDidChange(_ sender: Any) {
        boxModel.materialThickness = materialThicknessTextField.doubleValue
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
            setSliderLimits()
            tabWidthSlider.isEnabled = true
        }
    }
    
    @IBAction func tabWidthChanged(_ sender: Any) {
        let tabWidth = tabWidthSlider.doubleValue
        tabWidthLabel.stringValue = String(format: "Tab Width [%.2f]", tabWidth)
        boxModel.tabWidth = tabWidth
    }
    
    func setSliderLimits() {
        let smallestDimension = boxModel.smallestDimension()
        tabWidthSlider.maxValue = smallestDimension/3
    }
    
    @IBAction func setLid_On_Off(_ sender: Any) {

        boxModel.lidOn = !boxModel.lidOn

    }
    

    @IBAction func plusButtonLengthwise(_ sender: Any) {
        boxModel.counterLength += 1
        boxModel.lengthWall = true
    }
    
    @IBAction func minusButtonLengthwise(_ sender: Any) {
        boxModel.removeInnerWall = true
    }
    
    
}
