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

class InputViewController: NSViewController, NSTextDelegate, modelUpdatingDelegate {
    
    var boxModel = BoxModel()
    var fileHandlingControl = FileHandlingControl()
    
    var fileHandlingDelegate : FileHandlingDelegate? = nil
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func addWall(_ sender: Any) {
        boxModel.hasInnerWall = !boxModel.hasInnerWall
    }
    
    @IBAction func menuFileOpenItemSelected(_ sender: Any) {
        let newBoxModel = fileHandlingDelegate?.openModel(boxModel, self.view.window)
        guard let self.boxModel = newBoxModel else {return}
        boxModel.sceneGenerator.generateScene(self.boxModel)
    }
    
    @IBAction func menuFileSaveItemSelected(_ sender: Any) {
        fileHandlingDelegate?.saveModel(boxModel, self.view.window)
    }
    
    func updateModel(_ boxModel: BoxModel) {
        self.boxModel = boxModel
        boxModel.sceneGenerator.generateScene(boxModel)
    }
}

protocol FileHandlingDelegate {
    func saveModel(_ boxModel: BoxModel, _ window: NSWindow?)
    func openModel(_ boxModel: BoxModel, _ window: NSWindow?) -> BoxModel
}
