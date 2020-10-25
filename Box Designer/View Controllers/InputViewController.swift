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
    let unitConversionFactor = 25.4
    let selectionHandling = SelectionHandeling.shared
    
    
    var fileHandlingControl = FileHandlingControl.shared
    
    @IBOutlet weak var boxView: SCNView!
    @IBOutlet weak var pdfOptionsView: PDFOptionsView!
    @IBOutlet weak var mmMenu: NSMenuItem!
    @IBOutlet weak var inchMenu: NSMenuItem!
    
    // user-input text fields for dimensions
    @IBOutlet weak var lengthTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var materialThicknessTextField: NSTextField!
    
    @IBOutlet weak var innerOrOuterDimensionControl: NSSegmentedCell!
    @IBOutlet weak var joinTypeControl: NSSegmentedControl!
    @IBOutlet weak var unitChoiceControl: NSSegmentedCell!
    
    @IBOutlet weak var tabWidthLabel: NSTextField!
    @IBOutlet weak var tabWidthTextField: NSTextField!
    
    @IBOutlet weak var lidOn_Off: NSButton!
    
    // labels for respective text fields
    @IBOutlet weak var lengthLabel: NSTextField!
    @IBOutlet weak var widthLabel: NSTextField!
    @IBOutlet weak var heightLabel: NSTextField!
    @IBOutlet weak var thicknessLabel: NSTextField!
    
    @IBOutlet weak var plusButtonLengthwise: NSButton!
    @IBOutlet weak var minusButtonLengthwise: NSButton!
    
    @IBOutlet weak var exportButton: NSButton!
    
    //mm is true and inch is false
    private var mmInch: Bool = false
    private var mmInchDict : Dictionary<Bool, Double> = [false : 1.0, true : 25.4]
    
    //====================Camera Controls=========================
    // Sensitivity of camera movements in response to mouse
    let moveSensitivity:CGFloat = 0.01
    let rotateSensitivity:CGFloat = 0.01
    let zoomSensitivity:CGFloat = 0.1
    
    func inView(_ event: NSEvent)->Bool {
        if(boxView.hitTest(event.locationInWindow) == boxView){
            return true
        }
        return false
    }
    
    // Handles mouse movement when dragging the camera view around
    override func otherMouseDragged(with event: NSEvent) {
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.y -= event.deltaX * rotateSensitivity
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.x -= event.deltaY * rotateSensitivity
        
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
    }
    
    // Handling right click events with the mouse or trackpad
    override func rightMouseDragged(with event: NSEvent) {
        // If using a mouse, translate the camera relative to the box
        if (event.subtype == .mouseEvent) {
            var currentPos:SCNVector3 = boxView.pointOfView!.position
            currentPos.x += event.deltaX * -moveSensitivity
            currentPos.y += event.deltaY * moveSensitivity
            boxView.pointOfView!.position = currentPos
        }
        // Otherwise, when using a trackpad, rotate the camera's perspective, just like with the middle mouse button
        else {
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.y -= event.deltaX * rotateSensitivity
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.x -= event.deltaY * rotateSensitivity
            
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
        }
    }
    
    // When the mouse button is released, update the camera view of the box
    override func mouseUp(with event: NSEvent) {
        let clickCord = boxView.convert(event.locationInWindow, from: boxView.window?.contentView)
        let result: SCNHitTestResult = boxView.hitTest(clickCord, options: [ : ])[0]
        
        selectionHandling.selectedNode = result.node
        selectionHandling.highlightEdges(thickness: 0.1, idvLines: false)
    }
    
    // Handling scroll wheel events with the mouse/trackpad
    override func scrollWheel(with event: NSEvent) {
        // If the scrolling event is from a mouse, zoom in/out
        if (event.subtype == .mouseEvent) {
            boxView.pointOfView!.camera?.orthographicScale += Double(event.scrollingDeltaY * zoomSensitivity)
            if (boxView.pointOfView!.camera!.orthographicScale < 0.1){
                boxView.pointOfView!.camera?.orthographicScale = 0.1
            }
        }
        // Otherwise, If the scrolling event is from a trackpad, make it translate the camera relative to the box
        else {
            var currentPos:SCNVector3 = boxView.pointOfView!.position
            currentPos.x -= event.deltaX * (moveSensitivity*10)
            currentPos.y += event.deltaY * (moveSensitivity*10)
            boxView.pointOfView!.position = currentPos
        }
    }
    
    // Handling trackpad events
    // Allows users to zoom in and out with the trackpad
    override func magnify (with event: NSEvent) {
        boxView.pointOfView!.camera?.orthographicScale -= Double(event.magnification/zoomSensitivity)
        if(boxView.pointOfView!.camera!.orthographicScale < 0.1){
            boxView.pointOfView!.camera?.orthographicScale = 0.1
        }
    }
    
    // Allows users to rotate the view of the box with the trackpad
    override func rotate (with event: NSEvent) {
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.x += CGFloat(event.rotation) * (rotateSensitivity*4)
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.y += CGFloat(event.rotation) * (rotateSensitivity*4)
        
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
    }
    
    
    //============================================================
    
    
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
        
        tabWidthTextField.isEnabled = false
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
        
        // change text field according to units, with convFactor
        lengthTextField.doubleValue = boxModel.boxLength * mmInchDict[mmInch]!
        widthTextField.doubleValue = boxModel.boxWidth * mmInchDict[mmInch]!
        heightTextField.doubleValue = boxModel.boxHeight * mmInchDict[mmInch]!
        materialThicknessTextField.doubleValue = boxModel.materialThickness * mmInchDict[mmInch]!
    }
    
    @IBAction func mmMenuClicked(_ sender: Any) {
        if !mmInch{
            mmMenu.state = NSControl.StateValue.on
            inchMenu.state = NSControl.StateValue.off
            unitChoiceControl.selectedSegment = 1
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
            //set the limits second because otherwise the adjustment is incorrect
        }
    }
    
    // Changing the dimensions of the box
    // Changing the dimensions of the box pushes the camera closer or farther away from the box
    @IBAction func lengthTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            //if the setting is in mm
            boxModel.boxLength = lengthTextField.doubleValue * (1/unitConversionFactor)
        }else{
            //if the setting is in inches
           boxModel.boxLength = lengthTextField.doubleValue
        }
    }
    
    @IBAction func widthTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            //if the setting is in mm
            boxModel.boxWidth = widthTextField.doubleValue * (1/unitConversionFactor)
        }else{
            //if the setting is in inches
            boxModel.boxWidth = widthTextField.doubleValue
        }
    }
    
    @IBAction func heightTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            //if the setting is in mm
            boxModel.boxHeight = heightTextField.doubleValue * (1/unitConversionFactor)
        }else{
            //if the setting is in inches
            boxModel.boxHeight = heightTextField.doubleValue
        }
    }
    
    @IBAction func materialThicknessTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.materialThickness = materialThicknessTextField.doubleValue * (1/unitConversionFactor)
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
            tabWidthTextField.isEnabled = false
        } else if choice == 1 {
            boxModel.joinType = JoinType.tab
            tabWidthTextField.isEnabled = true
        }
    }
    
    @IBAction func tabWidthChanged(_ sender: Any) {
        boxModel.nTab = tabWidthTextField.doubleValue
    }
    
    @IBAction func setLid_On_Off(_ sender: Any) {

        boxModel.lidOn = !boxModel.lidOn

    }
    
    @IBAction func menuFileOpenItemSelected(_ sender: Any) {
        let newBoxModel = fileHandlingControl.openModel(boxModel, self.view.window)
        self.boxModel = newBoxModel
        //reset all displays to be correct
        boxModel.sceneGenerator.generateScene(self.boxModel)
    }
    
    @IBAction func menuFileSaveItemSelected(_ sender: Any) {
        fileHandlingControl.saveModel(boxModel, self.view.window)
    }
    
    // right now, the button just does the same as the menu option
    // the functionality in this will be changed for one of the requirements (swift archiving capabilities)
    @IBAction func exportButtonClicked(_ sender: Any) {
        fileHandlingControl.saveModel(boxModel, self.view.window)
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
    
    // Manages camera angles as the mouse drags the box around
    func manageMouseDrag(_ direction: inout CGFloat) {
        let deg: CGFloat = 180
        //this needs to be refactored
        if(direction/CGFloat.pi * deg > deg){
            direction = (((direction/CGFloat.pi * deg) - deg * 2)/deg) * CGFloat.pi
        }
        if(direction/CGFloat.pi * deg < -deg){
            direction = (((direction/CGFloat.pi * deg) + deg * 2)/deg) * CGFloat.pi
        }
    }
}

