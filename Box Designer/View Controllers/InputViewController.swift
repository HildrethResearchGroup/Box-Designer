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
    let selectionHandling = SelectionHandling.shared
    
    
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
    
    @IBOutlet weak var numberTabLabel: NSTextField!
    @IBOutlet weak var numberTabTextField: NSTextField!
    
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
    var mouseDown: Bool = false
    var cameraLocked: Bool = false
    
    let moveSensitivity:CGFloat = 0.01
    let rotateSensitivity:CGFloat = 0.01
    let zoomSensitivity:CGFloat = 0.1
    
    func inView(_ event: NSEvent)->Bool {
        return (boxView.hitTest(event.locationInWindow) == boxView)
    }
    
    // Handles mouse movement when dragging the camera view around
    override func otherMouseDragged(with event: NSEvent) {
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.y -= event.deltaX * rotateSensitivity
        boxModel.sceneGenerator.cameraOrbit.eulerAngles.x -= event.deltaY * rotateSensitivity
        if(!cameraLocked){
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.y -= event.deltaX * rotateSensitivity
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.x -= event.deltaY * rotateSensitivity
            
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let clickCord = boxView.convert(event.locationInWindow, from: boxView.window?.contentView)
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.ignoreHiddenNodes] = false
        
        let result = boxView.hitTest(clickCord, options: hitTestOptions)
        
        if (result.count == 0){
            selectionHandling.hoverNode = nil
            selectionHandling.hoverNode?.isHidden = true
            return
        }
        
        if(result[0].node.parent != boxView.scene?.rootNode){
            selectionHandling.hoverNode = result[0].node
        }else{
            selectionHandling.hoverNode = nil
            selectionHandling.hoverNode?.isHidden = true
        }
        
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
        else if(!cameraLocked){
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
        if(event.clickCount == 1 && !cameraLocked){
            selectionHandling.selectedNode = result.node
            selectionHandling.higlight()
        }else if(event.clickCount == 2){
            selectionHandling.selectedNode = result.node
            
            //make sure that it is part of the cube
            if(result.node.parent != boxView.scene?.rootNode){return}
            selectionHandling.highlightEdges(thickness: 0.01, insideSelection: false, idvLines: true)
            let yAngle = SceneGenerator.shared.cameraOrbit.eulerAngles.y/CGFloat.pi*180
            let xAngle = SceneGenerator.shared.cameraOrbit.eulerAngles.x/CGFloat.pi*180
            
            cameraLocked = true
            //we may want to refactor this into a function
            //the math can be simplified but isn't for readability
            if(result.node.position.x != 0.0){
                //left and right
                if(yAngle > 0){
                    //right
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (0)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (90)/180 * CGFloat.pi
                }else{
                    //left
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (0)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (-90)/180 * CGFloat.pi
                }
            }else if(result.node.position.y != 0.0){
                //top and bottom
                if(xAngle > 0){
                    //bottom
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (90)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (0)/180 * CGFloat.pi
                    
                }else{
                    //top
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (-90)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (0)/180 * CGFloat.pi
                }
            }else if(result.node.position.z != 0.0){
                //front and back
                if(abs(yAngle) > 90){
                    //back
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (0)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (180)/180 * CGFloat.pi
                }else{
                    //front
                    SceneGenerator.shared.cameraOrbit.eulerAngles.x = (0)/180 * CGFloat.pi
                    SceneGenerator.shared.cameraOrbit.eulerAngles.y = (0)/180 * CGFloat.pi
                }
            }
            print(result.node.position)
        }
        
    }
    
    override func keyUp(with event: NSEvent) {
        if(event.keyCode == 53){
            cameraLocked = false
            selectionHandling.selectedNode = nil
        }
        
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
        if(!cameraLocked){
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.x += CGFloat(event.rotation) * (rotateSensitivity*4)
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.y += CGFloat(event.rotation) * (rotateSensitivity*4)
            
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
        }
    }
    
    
    //============================================================
    

    override func awakeFromNib() {
        super.awakeFromNib()
        boxModel = BoxModel()
        
        numberTabTextField.isEnabled = false
        numberTabTextField.doubleValue = 3
        innerOrOuterDimensionControl.selectSegment(withTag: 0)
        joinTypeControl.selectSegment(withTag: 0)
        
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
            unitChoiceControl.selectedSegment = 0
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
    @IBAction func unitSegmentedControl(_ sender: Any) {
        let choice = unitChoiceControl.selectedSegment
        if choice == 0 {
            mmInch = false
            changeLabels(mmInch)
            mmMenu.state = NSControl.StateValue.off
            inchMenu.state = NSControl.StateValue.on
        } else if choice == 1 {
            mmInch = true
            changeLabels(mmInch)
            mmMenu.state = NSControl.StateValue.on
            inchMenu.state = NSControl.StateValue.off
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
            numberTabTextField.isEnabled = false
        } else if choice == 1 {
            boxModel.joinType = JoinType.tab
            numberTabTextField.isEnabled = true
            boxModel.numberTabs = numberTabTextField.doubleValue
        }
    }
    
    @IBAction func numberTabChanged(_ sender: Any) {
        boxModel.numberTabs = numberTabTextField.doubleValue
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
            boxModel.addInternalSeparator = true
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

