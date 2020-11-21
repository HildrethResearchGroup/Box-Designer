import Foundation
import Cocoa
import SceneKit
/**
 This class handles all user interactions with the application. We could potentially refactor to multiple ViewController classes.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: InputViewController.swift was created on 6/6/2020.
 
 */
class InputViewController: NSViewController, NSTextDelegate {
    /// This variable instantiates a new box model that will be updated by the user. It is instantiated with the default values found in the BoxModel class init().
    var boxModel = BoxModel()
    /// This variable is the conversion factor from inches to millimeters, used for unit conversion.
    static let unitConversionFactor = 25.4
    /// This variable determines the minimum number of tabs that can be made, as the path generation can only handle more than this number of tabs.
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
    /// This is the label for the number of tabs textbox. It must be a variable for the units to be displayed (and the units can change).
    @IBOutlet weak var numberTabLabel: NSTextField!
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
    /// This variable outputs the plane that the selected wall is on.
    @IBOutlet weak var selectedWallPlane: NSTextField!
    /// This variable indicates the plane that the added wall component should align with. It changes when you select a wall, to indicate the plane the wall is oriented on.
    @IBOutlet weak var addWallPlane: NSPopUpButton!
    /// This variable indicates the placement of the internal separator along the axis.
    @IBOutlet weak var addPlacement: NSTextField!
    /// This variable allows use to add a wall according to their selected specifications.
    @IBOutlet weak var addWallButton: NSButton!
    /// This variable allows users to delete the component that is selected in the view.
    @IBOutlet weak var deleteSelected: NSButton!
    /// This variable indicates which unit the user wants.
    /// - Note: true indicates millimeters, false indicates inches.
    private var mmInch: Bool = false
    /// This variable maps the unit to their conversion factor. Inches don't need to be changed, but millimeters need to be converted from inches.
    private var mmInchDict : Dictionary<Bool, Double> = [false : 1.0, true : unitConversionFactor]
    
    //====================Camera Controls=========================
    // var mouseDown: Bool = false
    
    var cameraLocked: Bool = false
    /// This variable gives wiggle room to the mouse event when clicking and dragging with right-click.
    let moveSensitivity:CGFloat = 0.01
    /// This variable gives wiggle room to the mouse event when clicking and dragging with non-left and non-right clicks (like a side button).
    let rotateSensitivity:CGFloat = 0.01
    /// This variable gives wiggle room to the mouse event when using the scroll bar.
    let zoomSensitivity:CGFloat = 0.1
    
    /**
     This function returns a boolean about whether the click event is within the view (true) or not (false).
     - Parameters:
        - event: an event that occured on the screen while the application is open
     - Returns:
        - Bool: this function returns a boolean on whether the event happened in the application view or not.
     */
    func inView(_ event: NSEvent)->Bool {
        return (boxView.hitTest(event.locationInWindow) == boxView)
    }
    
    /**
     This function handles mouse movement when dragging the camera view around -- it rotates the box model. See [Apple Documentation - otherMouseDragged()] for further information on the inherited function. (https://developer.apple.com/documentation/appkit/nsresponder/1529804-othermousedragged?language=objc)
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
    
    override func mouseMoved(with event: NSEvent) {
        // get the location of the cursor when clicked
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
            updateSelectedWallPlane()
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
            addWallPlane.selectItem(at: 0)
            selectedWallPlane.stringValue = "Selected wall: None Selected"
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
        //boxModel = BoxModel()
        
        numberTabTextField.isEnabled = false
        numberTabTextField.doubleValue = 3
        previousTabEntry = minTabs
        innerOrOuterDimensionControl.selectSegment(withTag: 0)
        joinTypeControl.selectSegment(withTag: 0)
        addWallType.selectItem(at: 0)
        addWallPlane.selectItem(at: 0)
        addPlacement.isEnabled = true
        addPlacement.doubleValue = 0.5
        addWallButton.isEnabled = false
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
            boxModel.boxLength = lengthTextField.doubleValue * (1/InputViewController.unitConversionFactor)
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
            boxModel.boxWidth = widthTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            //if the setting is in inches
            boxModel.boxWidth = widthTextField.doubleValue
        }
    }
    
    @IBAction func heightTextFieldDidChange(_ sender: Any) {
        SceneGenerator.shared.generateScene(boxModel)
        if mmInch{
            //if the setting is in mm
            boxModel.boxHeight = heightTextField.doubleValue * (1/InputViewController.unitConversionFactor)
        }else{
            //if the setting is in inches
            boxModel.boxHeight = heightTextField.doubleValue
        }
    }
    
    @IBAction func materialThicknessTextFieldDidChange(_ sender: Any) {
        if mmInch{
            //if the setting is in mm
            boxModel.materialThickness = materialThicknessTextField.doubleValue * (1/InputViewController.unitConversionFactor)
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
        } else if choice == 2 {
            boxModel.joinType = JoinType.slot
            numberTabTextField.isEnabled = false
        }
    }
    
    @IBAction func numberTabChanged(_ sender: Any) {
        // If the number of tabs is too low, display a warning dialog
        // Warning dialog gives the user the choice to either:
        if numberTabTextField.doubleValue < minTabs {
            // Default to the minimum number of tabs
            if tabDialog() {
                boxModel.numberTabs = minTabs
                numberTabTextField.doubleValue = minTabs
            }
            // Cancel the tab operation, reseting the tab count to its previous number
            else {
                numberTabTextField.doubleValue = previousTabEntry
            }
        }
        else {
            boxModel.numberTabs = numberTabTextField.doubleValue
            previousTabEntry = numberTabTextField.doubleValue
        }
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
    
    @IBAction func disableAddWall(_ sender: Any) {
        
        /// only let users add wall if external or internal is selected
        if addWallType.indexOfSelectedItem == 0 {
            addWallButton.isEnabled = false
        } else {
            addWallButton.isEnabled = true
        }
        
    }
    
    @IBAction func addWall(_ sender: Any) {
        var inner = false
        var type : WallType
        let placement = addPlacement.doubleValue
        
        // get inner or outer wall, disable "Add Wall" button if user hasn't decided
        if addWallType.indexOfSelectedItem == 1 {
            inner = false
        }else if addWallType.indexOfSelectedItem == 2 {
            inner = true
        }
        
        // get wall plane, convert to wall type
        if addWallPlane.indexOfSelectedItem == 0 {
            type = WallType.longCorner
        } else if addWallPlane.indexOfSelectedItem == 1 {
            type = WallType.smallCorner
        } else {
            /*
             THIS IM NOT SURE ABOUT!!!!!!!!!!!!!!!!!!!!!!!!
             */
            type = WallType.topSide
        }
        
        boxModel.addWall(inner: inner, type: type, innerPlacement: placement)
        updateModel(boxModel)
    }
    func updateSelectedWallPlane() {
        /// Select the plane of the selected component in Add Components menu and in display in the label
        if selectionHandling.selectedNode != nil {
            let selectedWall = boxModel.walls[Int(selectionHandling.selectedNode!.name!)!]
            if (selectedWall?.wallType == WallType.topSide || selectedWall?.wallType == WallType.bottomSide || (selectedWall!.innerWall && selectedWall?.innerPlane == WallType.topSide || selectedWall?.innerPlane == WallType.bottomSide)) {
                addWallPlane.selectItem(at: 2)
                selectedWallPlane.stringValue = "Selected wall: X-Z Plane"
            } else if (selectedWall?.wallType == WallType.longCorner || (selectedWall!.innerWall && selectedWall?.innerPlane == WallType.longCorner)) {
                addWallPlane.selectItem(at: 0)
                selectedWallPlane.stringValue = "Selected wall: X-Y Plane"
            } else if selectedWall?.wallType == WallType.smallCorner {
                addWallPlane.selectItem(at: 1)
                selectedWallPlane.stringValue = "Selected wall: Y-Z Plane"
            }
        }
    }
    @IBAction func deleteSelectedComponent(_ sender: Any) {
        if let node = selectionHandling.selectedNode {
            boxModel.walls.removeValue(forKey: Int(node.name!)!)
            boxModel.updateIntersectingWalls()
        }        
        updateModel(boxModel)
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
    
    // Prevents the user from implementing fewer tabs than is allowed
    func tabDialog() -> Bool {
        let tabAlert = NSAlert()
        tabAlert.messageText = "Invalid tab selection."
        tabAlert.informativeText = "Press 'OK' to default to the minimum number of tabs \(Int(minTabs)), or press 'Cancel' to abort the operation."
        tabAlert.alertStyle = .warning
        tabAlert.addButton(withTitle: "OK")
        tabAlert.addButton(withTitle: "Cancel")
        return tabAlert.runModal() == .alertFirstButtonReturn
    }
}

