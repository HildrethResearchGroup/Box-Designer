import Foundation
import Cocoa
import SceneKit
/**
 This class handles all user interactions with the application.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: InputViewController.swift was created on 6/6/2020. Additonally, we could potentially refactor to multiple ViewController classes, as this one is very meaty..
 
 */
class InputViewController: NSViewController, NSTextDelegate {
    /// This variable instantiates a new box model that will be updated by the user. It is instantiated with the default values found in BoxModel init().
    var boxModel = BoxModel()
    /// This variable is the conversion factor from inches to millimeters, used for unit conversion.
    static let unitConversionFactor = 25.4
    /// This variable determines the minimum number of tabs that can be made, as the path generation can only handle more than this number of tabs due to how path generation works.
    let minTabs = 3.0
    /// Records the previous amount of tabs entered by the user.
    var previousTabEntry = 0.0
    /// This variable is the selection handling singleton.
    let selectionHandling = SelectionHandling.shared
    /// This variable is the file handling control singleton.
    var fileHandlingControl = FileHandlingControl.shared
    /// This variable is the view object that's displayed in the app.
    @IBOutlet weak var boxView: SCNView!
    /// This variable is the accessory view object displayed in the save panel.
    @IBOutlet weak var pdfOptionsView: PDFOptionsView!
    /// This variable is the millimeter option in the Taskbar -> Format -> Units.
    @IBOutlet weak var mmMenu: NSMenuItem!
    /// This variable is the inches option in the Taskbar -> Format -> Units.
    @IBOutlet weak var inchMenu: NSMenuItem!
    /// This variable is the textbox for box length that users can change in the main GUI.
    @IBOutlet weak var lengthTextField: NSTextField!
    /// This variable is the textbox for box width that users can change in the main GUI.
    @IBOutlet weak var widthTextField: NSTextField!
    /// This variable is the textbox for box height that users can change in the main GUI.
    @IBOutlet weak var heightTextField: NSTextField!
    /// This variable is the textbox for box material thickness that users can change in the main GUI.
    @IBOutlet weak var materialThicknessTextField: NSTextField!
    /// This variable allows selection for the displayed dimensions to include (or not include) the walls themselves.
    @IBOutlet weak var innerOrOuterDimensionControl: NSSegmentedCell!
    /// This variable allows for selection of user's desired join type (tab, overlap, slotted).
    @IBOutlet weak var joinTypeControl: NSSegmentedControl!
    /// This variable allows for selection of dimension units (inches or millimeters).
    @IBOutlet weak var unitChoiceControl: NSSegmentedCell!
    /// This variable is the textbox for number of tabs (if "Tab" join type is selected) that users can change in main GUI.
    @IBOutlet weak var numberTabTextField: NSTextField!
    /// This is the label for the box length textbox. It must be a variable for the units to be displayed (and the units can change).
    @IBOutlet weak var lengthLabel: NSTextField!
    /// This is the label for the box width textbox. It must be a variable for the units to be displayed (and the units can change).
    @IBOutlet weak var widthLabel: NSTextField!
    /// This is the label for the box height textbox. It must be a variable for the units to be displayed (and the units can change).
    @IBOutlet weak var heightLabel: NSTextField!
    /// This is the label for the box material thickness textbox. It must be a variable for the units to be displayed (and the units can change).
    @IBOutlet weak var thicknessLabel: NSTextField!
    /// This variable allows users to export their box template directly from the main GUI (they can also do this from the taskbar).
    @IBOutlet weak var exportButton: NSButton!
    /// This variable indicates whether the added component should be an external wall or internal separator.
    @IBOutlet weak var addWallType: NSPopUpButton!
    /// This variable outputs the plane that the selected wall is on and its placement.
    @IBOutlet weak var selectedWallPlane: NSTextField!
    /// This variable indicates the plane that the added wall component should align with. It changes when you select a wall, to indicate the plane the wall is oriented on.
    @IBOutlet weak var addWallPlane: NSPopUpButton!
    /// This variable indicates the placement of the internal separator along the axis.
    @IBOutlet weak var addPlacement: NSTextField!
    /// This variable allows users to add a wall according to their selected specifications.
    @IBOutlet weak var addWallButton: NSButton!
    /// This variable forces users to select only 0 or 1 for external wall placement, as fractions don't make sense for external walls.
    @IBOutlet weak var externalWallPlacement: NSSegmentedControl!
    /// This variable allows users to delete the component that is selected in the view.
    @IBOutlet weak var deleteSelected: NSButton!
    /// This variable allows users to add a handle cutout on the selected wall.
    @IBOutlet weak var handleCheckMark: NSButton!
    /// This variable indicates which unit the user wants.
    /// - Note: True indicates millimeters, false indicates inches.
    private var mmInch: Bool = false
    /// This variable maps the mmInch boolean to their conversion factor. Inches don't need to be changed converted, but millimeters need to be converted from inches.
    private var mmInchDict : Dictionary<Bool, Double> = [false : 1.0, true : unitConversionFactor]
    
    /// This function is inherited from NSViewController. It changes any settings that you want when the view initially loads, or a box model is loaded into the session from a JSON.
    override func awakeFromNib() {
        super.awakeFromNib()
        /// get values from current box model -- when user opens a box model from a JSON file, the values need to change in the GUI to the loaded box model's values
        lengthTextField.doubleValue = boxModel.boxLength
        widthTextField.doubleValue = boxModel.boxWidth
        heightTextField.doubleValue = boxModel.boxHeight
        materialThicknessTextField.doubleValue = boxModel.materialThickness
        boxModel.joinType == JoinType.tab ? (numberTabTextField.isEnabled = true) : (numberTabTextField.isEnabled = false)
        numberTabTextField.doubleValue = boxModel.numberTabs!
        previousTabEntry = minTabs
        boxModel.innerDimensions ? (innerOrOuterDimensionControl.selectedSegment = 1) : (innerOrOuterDimensionControl.selectedSegment = 0)
        /// - TODO: need to update for slot
        boxModel.joinType == JoinType.overlap ? (joinTypeControl.selectedSegment = 0) : (joinTypeControl.selectedSegment = 1)
        /// Make sure adding components panel is at its default state (especially when loading a box model into session).
        addWallType.selectItem(at: 0)
        addWallPlane.selectItem(at: 0)
        addPlacement.isHidden = true
        addPlacement.doubleValue = 0.5
        externalWallPlacement.isHidden = true
        addWallButton.isEnabled = false
        handleCheckMark.isEnabled = false
        /// begin with inch units
        unitChoiceControl.selectedSegment = 0
        mmInch = false
        changeLabels(mmInch)
        boxModel.sceneGenerator.generateScene(boxModel)
    }
    /// This function is inherited from NSViewController.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //====================Camera Controls===========================//
    /// This variable indicates when the camera is locked onto a wall.
    var cameraLocked: Bool = false
    /// This variable gives wiggle room to the mouse event when clicking and dragging with right-click.
    let moveSensitivity:CGFloat = 0.01
    /// This variable gives wiggle room to the mouse event when clicking and dragging with non-left and non-right clicks (like a side button).
    let rotateSensitivity:CGFloat = 0.01
    /// This variable gives wiggle room to the mouse event when using the scroll bar.
    let zoomSensitivity:CGFloat = 0.1
    
    /**
     This function handles mouse movement when dragging the camera view around -- it rotates the box model. See [Apple Documentation - otherMouseDragged()]. (https://developer.apple.com/documentation/appkit/nsresponder/1529804-othermousedragged?language=objc)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
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
    /**
     This function handles snap points and edge highlighting appearance when user is in "focused" view and hovering their cursor above the correct spot -- camera locked on wall. See [Apple Documentation - mouseMoved()]. (https://developer.apple.com/documentation/appkit/nsresponder/1525114-mousemoved)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func mouseMoved(with event: NSEvent) {
        /// get the location of the cursor when clicked and perform hit test
        let clickCord = boxView.convert(event.locationInWindow, from: boxView.window?.contentView)
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.ignoreHiddenNodes] = false
        
        let result = boxView.hitTest(clickCord, options: hitTestOptions)
        /// if no hit test result, return
        if (result.count == 0){
            selectionHandling.hoverNode = nil
            selectionHandling.hoverNode?.isHidden = true
            return
        }
        
        selectionHandling.addClickPoint(result[0], false, boxModel)
        
        if(result[0].node.parent != boxView.scene?.rootNode){
            selectionHandling.hoverNode = result[0].node
        }else{
            selectionHandling.hoverNode = nil
            selectionHandling.hoverNode?.isHidden = true
        }
        
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
        manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
    }
    /**
     This function handles right click events with the mouse or trackpad (right-click and drag moves the box model around). See [Apple Documentation - rightMouseDragged()]. https://developer.apple.com/documentation/appkit/nsresponder/1529135-rightmousedragged)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func rightMouseDragged(with event: NSEvent) {
        // If using a mouse, translate the camera relative to the box
        if (event.subtype == .mouseEvent && !cameraLocked) {
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
    /**
     This function handles camera updates from clicks by either highlighting a wall (if one click on correct area), or focusing on a double-clicked wall for drawing. See [Apple Documentation - mouseUp()]. (https://developer.apple.com/documentation/swiftui/nshostingview/mouseup(with:))
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func mouseUp(with event: NSEvent) {
        let clickCord = boxView.convert(event.locationInWindow, from: boxView.window?.contentView)
        let result: SCNHitTestResult = boxView.hitTest(clickCord, options: [ : ])[0]
        
        /// highlight selected wall if there's a hit on one click, otherwise go into "focus" view on the double-clicked wall
        if (boxModel.boxHeight >= 5 && boxModel.boxWidth >= 4 && boxModel.boxLength >= 4) { handleCheckMark.isEnabled = true
        }
        if(event.clickCount == 1 && !cameraLocked){
            selectionHandling.selectedNode = result.node
            selectionHandling.higlight()
            updateSelectedWallPlane()
        }else if(event.clickCount == 1 && cameraLocked){
            
            selectionHandling.addClickPoint(result, true, boxModel)
            
        }else if(event.clickCount == 2){
            cameraLocked = true
            selectionHandling.selectedNode = result.node
            
            //make sure that it is part of the cube
            if(result.node.parent != boxView.scene?.rootNode){return}
            //selectionHandling.highlightEdges(thickness: 0.01, insideSelection: false, idvLines: true)
            let yAngle = SceneGenerator.shared.cameraOrbit.eulerAngles.y/CGFloat.pi*180
            let xAngle = SceneGenerator.shared.cameraOrbit.eulerAngles.x/CGFloat.pi*180
            
            
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
    /**
     This function handles key board input from user. See [Apple Documentation - keyUp()]. (https://developer.apple.com/documentation/appkit/nsgesturerecognizer/1526578-keyup)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func keyUp(with event: NSEvent) {
        let clickCord = boxView.convert(event.locationInWindow, from: boxView.window?.contentView)
        let result: [SCNHitTestResult] = boxView.hitTest(clickCord, options: [ : ])
        
        /// this is the escape keyCode
        if(event.keyCode == 53){
            if(selectionHandling.drawing()){
                cameraLocked = false
                handleCheckMark.isEnabled = false
                selectionHandling.selectedNode = nil
                addWallPlane.selectItem(at: 0)
                selectedWallPlane.stringValue = "Selected wall: None"
            }else{
                selectionHandling.removeDrawing()
            }
            
        }else if(event.keyCode == 30){
            //]
            selectionHandling.shapeSelection += 1
            if (result.count == 0){ return }
            selectionHandling.addClickPoint(result[0], false, boxModel)
        }else if(event.keyCode == 33){
            //[
            selectionHandling.shapeSelection -= 1
            if (result.count == 0){ return }
            selectionHandling.addClickPoint(result[0], false, boxModel)
        }else if(event.keyCode == 24){
            //+
            selectionHandling.roundedRadius += CGFloat(0.1)
            if (result.count == 0){ return }
            selectionHandling.addClickPoint(result[0], false, boxModel)
        }else if(event.keyCode == 27){
            //-
            selectionHandling.roundedRadius -= CGFloat(0.1)
            if (result.count == 0){ return }
            selectionHandling.addClickPoint(result[0], false, boxModel)
        }
        
        print(event.keyCode)
        
    }
    
    /**
     This function handles mouse scrolling to zoom in and out of the view. See [Apple Documentation - scrollWheel()]. (https://developer.apple.com/documentation/swiftui/nshostingview/scrollwheel(with:))
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func scrollWheel(with event: NSEvent) {
        /// If the scrolling event is from a mouse, zoom in/out
        if (event.subtype == .mouseEvent) {
            boxView.pointOfView!.camera?.orthographicScale += Double(event.scrollingDeltaY * zoomSensitivity)
            if (boxView.pointOfView!.camera!.orthographicScale < 0.1){
                boxView.pointOfView!.camera?.orthographicScale = 0.1
            }
        }
        /// Otherwise, If the scrolling event is from a trackpad, make it translate the camera relative to the box
        else if(!cameraLocked){
            var currentPos:SCNVector3 = boxView.pointOfView!.position
            currentPos.x -= event.deltaX * (moveSensitivity*10)
            currentPos.y += event.deltaY * (moveSensitivity*10)
            boxView.pointOfView!.position = currentPos
        }
    }
    
    /**
     This function handles trackpad zoom. See [Apple Documentation - magnify()]. (https://developer.apple.com/documentation/appkit/nsresponder/1525862-magnify)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func magnify (with event: NSEvent) {
        boxView.pointOfView!.camera?.orthographicScale -= Double(event.magnification/zoomSensitivity)
        if(boxView.pointOfView!.camera!.orthographicScale < 0.1){
            boxView.pointOfView!.camera?.orthographicScale = 0.1
        }
    }
    
    /**
     This function handles trackpad view rotation. See [Apple Documentation - rotate()]. (https://developer.apple.com/documentation/appkit/nsresponder/1525572-rotate)
     - Parameters:
        - event: an event that occured in the application with the mouse
     */
    override func rotate (with event: NSEvent) {
        if(!cameraLocked){
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.x += CGFloat(event.rotation) * (rotateSensitivity*4)
            boxModel.sceneGenerator.cameraOrbit.eulerAngles.y += CGFloat(event.rotation) * (rotateSensitivity*4)
            
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.x)
            manageMouseDrag(&SceneGenerator.shared.cameraOrbit.eulerAngles.y)
        }
    }
    /// This function manages camera angles as the mouse drags the box around.
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
    
    
    //=======================Panel and Menu Interaction Controls=========================//
    
    /**
     This function updates the label of any dimension in the view -- inches or millimeters.
     - Parameters:
        - unit: this is a boolean indicating whether the user's desired unit is inches or millimeters
     */
    func changeLabels(_ unit : Bool) {
        var unitString: String
        /// false is inches, true is mm
        if unit{
            unitString = "(mm)"
        } else{
            unitString = "(in)"
        }
        /// change label units for user reference
        lengthLabel.stringValue = "Length " + unitString
        widthLabel.stringValue = "Width " + unitString
        heightLabel.stringValue = "Height " + unitString
        thicknessLabel.stringValue = "Material Thickness " + unitString
        
        /// change text field according to units, with convFactor
        lengthTextField.doubleValue = boxModel.boxLength * mmInchDict[mmInch]!
        widthTextField.doubleValue = boxModel.boxWidth * mmInchDict[mmInch]!
        heightTextField.doubleValue = boxModel.boxHeight * mmInchDict[mmInch]!
        materialThicknessTextField.doubleValue = boxModel.materialThickness * mmInchDict[mmInch]!
    }
    
    /**
     This recieves input from the app's menu that the user wants millimeters as their unit.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func mmMenuClicked(_ sender: Any) {
        if !mmInch{
            mmMenu.state = NSControl.StateValue.on
            inchMenu.state = NSControl.StateValue.off
            unitChoiceControl.selectedSegment = 1
            mmInch = true
            changeLabels(mmInch)
        }
    }
    /**
     This recieves input from the app's menu that the user wants inches as their unit.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func inchMenuClicked(_ sender: Any) {
        /// changing the units only changes the displayed amount not the model size
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
        }
    }
    /**
     This recieves input from the app's dimensions panel that the user wants a different box length.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func lengthTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            /// if the setting is in mm
            boxModel.boxLength = lengthTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            /// if the setting is in inches
           boxModel.boxLength = lengthTextField.doubleValue
        }
    }
    /**
     This recieves input from the app's dimensions panel that the user wants a specific unit (inch or mm).
     - Parameters:
        - sender: typical @IBAction input
     */
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
    /**
     This recieves input from the app's dimensions panel that the user wants a different box width.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func widthTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            /// if the setting is in mm
            boxModel.boxWidth = widthTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            /// if the setting is in inches
            boxModel.boxWidth = widthTextField.doubleValue
        }
    }
    /**
     This recieves input from the app's dimensions panel that the user wants a different box height.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func heightTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            /// if the setting is in mm
            boxModel.boxHeight = heightTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            /// if the setting is in inches
            boxModel.boxHeight = heightTextField.doubleValue
        }
    }
    /**
     This recieves input from the app's dimensions panel that the user wants a different box material thickness.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func materialThicknessTextFieldDidChange(_ sender: Any) {
        if mmInch{
            /// if the setting is in mm
            boxModel.materialThickness = materialThicknessTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            /// if the setting is in inches
            boxModel.materialThickness = materialThicknessTextField.doubleValue
        }
        
    }
    /**
     This recieves input from the app's dimensions panel that the user wants the dimensions to be either inner or outer (see BoxModel.innerDimension for description).
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func innerOrOuterDimensionsSelected(_ sender: Any) {
        let choice = innerOrOuterDimensionControl.selectedSegment
        if choice == 0 {
            boxModel.innerDimensions = false
        } else if choice == 1 {
            boxModel.innerDimensions = true
        }
    }
    /**
     This recieves input from the app's join panel that the user wants a different box join type.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func joinTypeSelected(_ sender: Any) {
        let choice = joinTypeControl.selectedSegment
        if choice == 0 {
            boxModel.joinType = JoinType.overlap
            numberTabTextField.isEnabled = false
        } else if choice == 1 {
            boxModel.joinType = JoinType.tab
            numberTabTextField.isEnabled = true
            boxModel.numberTabs = numberTabTextField.doubleValue
        } else if choice == 2 {
            boxModel.joinType = JoinType.slot
            numberTabTextField.isEnabled = false
        }
    }
    /**
     This recieves input from the app's join panel that the user wants a different number of tabs.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func numberTabChanged(_ sender: Any) {
        /// If the number of tabs is too low, display a warning dialog
        if numberTabTextField.doubleValue < minTabs {
            /// Default to the minimum number of tabs
            if tabDialog() {
                boxModel.numberTabs = minTabs
                numberTabTextField.doubleValue = minTabs
            }
            /// Cancel the tab operation, reseting the tab count to its previous number
            else {
                numberTabTextField.doubleValue = previousTabEntry
            }
        }
        else {
            boxModel.numberTabs = numberTabTextField.doubleValue
            previousTabEntry = numberTabTextField.doubleValue
        }
    }
    /// This alert pops up if the user inputs fewer tabs than is allowed.
    func tabDialog() -> Bool {
        let tabAlert = NSAlert()
        tabAlert.messageText = "Invalid tab selection."
        tabAlert.informativeText = "Press 'OK' to default to the minimum number of tabs \(Int(minTabs)), or press 'Cancel' to abort the operation."
        tabAlert.alertStyle = .warning
        tabAlert.addButton(withTitle: "OK")
        tabAlert.addButton(withTitle: "Cancel")
        return tabAlert.runModal() == .alertFirstButtonReturn
    }
    /**
     This recieves input from the app's menu that the user wants to open a box model into the session from a selected JSON file.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func menuFileOpenItemSelected(_ sender: Any) {
        let newBoxModel = fileHandlingControl.openModel()
        /// reset box view and GUI values according to loaded box model
        updateModel(newBoxModel)
        self.awakeFromNib()
    }
    /**
     This recieves input from the app's menu and the export button in the view that the user wants to save their box model.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func saveModel(_ sender: Any) {
        fileHandlingControl.saveModel(boxModel, self.view.window)
    }
    /**
     This update the InputViewController's boxModel after changes were made.
     - Parameters:
        - boxModel: the updated box model
     */
    func updateModel(_ boxModel: BoxModel) {
        self.boxModel = boxModel
        boxModel.sceneGenerator.generateScene(boxModel)
    }
    /**
     This recieves input from the app's add components panel that the user updated the wall type or the wall plane. It is used to make sure the correct placement input is not hidden, and hides the correct one. It also disables the add wall button unless something other than the default "Type" is selected.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func wallTypeOrPlaneChanged(_ sender: Any) {
        /// only let users add wall if external or internal is selected; hide both placement inputs if "Type" is selected, or just un-hide one if the correct wall type is selected
        if addWallType.indexOfSelectedItem == 0 {
            addWallButton.isEnabled = false
            addPlacement.isHidden = true
            externalWallPlacement.isHidden = true
        } else if addWallType.indexOfSelectedItem == 1 {
            externalWallPlacement.isHidden = false
            addPlacement.isHidden = true
            addWallButton.isEnabled = true
            /// update externalWallPlacement selection with missing walls of that plane
            var missing = [Double]()
            if addWallPlane.indexOfSelectedItem == 0 {
                missing = findMissingExternalWalls(WallType.longCorner)
            } else if addWallPlane.indexOfSelectedItem == 1 {
                missing = findMissingExternalWalls(WallType.smallCorner)
            } else {
                /// can fo either topSide or bottomSide here, just need the correct plane
                missing = findMissingExternalWalls(WallType.topSide)
            }
            if !missing.isEmpty { externalWallPlacement.selectedSegment = Int(missing[0]) } else { externalWallPlacement.selectedSegment = 0 }
        } else {
            externalWallPlacement.isHidden = true
            addPlacement.isHidden = false
            addPlacement.doubleValue = 0.5
            addWallButton.isEnabled = true
        }
    }
    /**
     This function finds the placements of the missing external walls in the box model, for user-friendly external wall adding.
     - Parameters:
        - type: the plane on which the missing walls should be searched for
     - Returns: This function returns an array of double/s that indicate the placement of a missing wall -- it can have a max of two values, and values can only be 0.0 or 1.0
     */
    func findMissingExternalWalls(_ type: WallType) -> [Double] {
        var current = [Double]()
        var missing = [Double]()
        /// find external walls on the right plane that are there
        for wall in boxModel.walls.values {
            if !wall.innerWall {
                if wall.wallType == WallType.bottomSide && (type == WallType.topSide || type == WallType.bottomSide){
                    current.append(0.0)
                } else if wall.wallType == WallType.topSide && (type == WallType.topSide || type == WallType.bottomSide) {
                    current.append(1.0)
                } else if wall.wallType == type {
                    let length = sqrt(pow(wall.position.x,2) + pow(wall.position.y,2) + pow(wall.position.z,2))
                    Double(length) < (boxModel.materialThickness + 1.0) ? (current.append(0.0)) : (current.append(1.0))
                }
            }
        }
        if current.contains(0.0) && current.contains(1.0) {return missing}
        if current.contains(0.0) {missing.append(1.0); return missing}
        if current.contains(1.0) {missing.append(0.0); return missing}
        return missing
    }
    /**
     This function takes in user input about the orientation, placement, and type of wall they want to add, and then sends those parameters off to BoxModel for the wall to be added to the template.
     - Parameters:
        - sender: typical @IBAction input
     - Note: As of now, internal walls can only be added from the origin. This could be updated by accepting a negative number so BoxModel knows to draw from the boundary opposite the origin.
     */
    @IBAction func addWall(_ sender: Any) {
        var inner = false
        var type : WallType
        var placement = 0.0
        
        if addWallType.indexOfSelectedItem == 2 {
            inner = true
            placement = addPlacement.doubleValue
        } else if addWallType.indexOfSelectedItem == 1 {
            placement = Double(externalWallPlacement.selectedSegment)
        }
        
        /// get wall plane, convert to wall type
        if addWallPlane.indexOfSelectedItem == 0 {
            type = WallType.longCorner
        } else if addWallPlane.indexOfSelectedItem == 1 {
            type = WallType.smallCorner
        } else {
        
            placement == 0.0 ? (type = WallType.bottomSide) : (type = WallType.topSide)
        }
        
        boxModel.addWall(inner: inner, type: type, placement: placement)
        updateModel(boxModel)
    }
    /**
     This function is purely to make the Add Components more user friendly. All it does is update the label output in GUI to show the selected wall's (highlighted wall's) plane and placement, if one is selected. If adding walls is refactored, you probably won't need this. The other idea is to add a coordinate system that adjusts according to the camera.
     */
    func updateSelectedWallPlane() {
        /// Select the plane of the selected component in Add Components menu and display in the label. If external wall is selected, update externalWallPlacement to be the missing wall (if any).
        var missing = [Double]()
        if selectionHandling.selectedNode != nil {
            let selectedWall = boxModel.walls[Int(selectionHandling.selectedNode!.name!)!]
            let length = Double(sqrt(pow(selectedWall!.position.x,2) + pow(selectedWall!.position.y,2) + pow(selectedWall!.position.z,2)))
            var placement = 0.0
            var plane = ""
            if (selectedWall?.wallType == WallType.topSide || selectedWall?.wallType == WallType.bottomSide || (selectedWall!.innerWall && selectedWall?.innerPlane == WallType.topSide || selectedWall?.innerPlane == WallType.bottomSide)) {
                addWallPlane.selectItem(at: 2)
                plane = "X-Z"
                placement = (length/boxModel.boxHeight*100).rounded()/100
                missing = findMissingExternalWalls(WallType.topSide)
                
            } else if (selectedWall!.wallType == WallType.longCorner || (selectedWall!.innerWall && selectedWall!.innerPlane == WallType.longCorner)) {
                addWallPlane.selectItem(at: 0)
                plane = "X-Y"
                placement = (length/boxModel.boxWidth*100).rounded()/100
                missing = findMissingExternalWalls(WallType.longCorner)
            } else if selectedWall!.wallType == WallType.smallCorner {
                addWallPlane.selectItem(at: 1)
                plane = "Y-Z"
                placement = (length/boxModel.boxLength*100).rounded()/100
                missing = findMissingExternalWalls(WallType.smallCorner)
            }
            if !selectedWall!.innerWall {
                if !missing.isEmpty && externalWallPlacement.isHidden == false { externalWallPlacement.selectedSegment = Int(missing[0]) }
                length < boxModel.materialThickness + 1 ? (placement = Double(0.0)) : (placement = Double(1.0))
            } else {
                addPlacement.doubleValue = (length/boxModel.boxHeight*100).rounded()/100
            }
            selectedWallPlane.stringValue = "Selected wall: \(plane) Plane, \(placement) placement"
            /// Update handle checkbox depending on whether selected wall has handle or not
            selectedWall?.handle == true ? (handleCheckMark.state = NSButton.StateValue.on) : (handleCheckMark.state = NSButton.StateValue.off)
        }
    }
    /**
     This function simply tells the box model to delete the wall that is selected by the user. It also updates the intersectingWalls dictionary if one of the keys or values is the wall that is deleted.
     - Parameters:
        - sender: typical @IBAction input
     */
    @IBAction func deleteSelectedComponent(_ sender: Any) {
        if let node = selectionHandling.selectedNode {
            handleCheckMark.state = NSButton.StateValue.off
            boxModel.walls.removeValue(forKey: Int(node.name!)!)
            boxModel.updateIntersectingWalls()
        }        
        updateModel(boxModel)
    }
    /// Creates a handle cutout on the selected component
    @IBAction func createHandle(_ sender: Any) {
        // If the handle button is pressed, place a handle on the selected box component
        if (handleCheckMark.state.rawValue == 1) {
            // Enable the checkmark if/when a wall is selected
            boxModel.walls[Int(selectionHandling.selectedNode!.name!)!]?.handle = true
            updateModel(boxModel)
        }
        // If the handle button is pressed off, then remove the handle
        else if (handleCheckMark.state.rawValue == 0){
            if (selectionHandling.selectedNode != nil) {
                boxModel.walls[Int(selectionHandling.selectedNode!.name!)!]?.handle = false
                updateModel(boxModel)
            }
        }
    }

}

