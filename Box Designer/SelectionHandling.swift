import Foundation
import SceneKit
import Cocoa
/**
 This class handles the selection and highlighting of components that the user wants to interact with, as well as snap point and edge highlighting when user is in "focus" mode.
 - TODO: documenting this class
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: SelectionHandling.swift was created on 9/14/2020.
 
 */
class SelectionHandling{
    /// This variable enables SelectionHandling to be a singleton.
    static let shared = SelectionHandling()
    var boxModel:BoxModel?
    let shapeDepth: CGFloat = 0.0001
    
    var inside: Bool = false
    var roundedRadius: CGFloat = 0.1{
        didSet{
            if(roundedRadius < 0 ){
                roundedRadius = 0
            }
        }
    }
    var shapeSelection = 0{
        didSet{
            if(shapeSelection > 2){
                shapeSelection = 0
            }else if(shapeSelection < 0){
                shapeSelection = 2
            }
        }
    }
    private var drawingclicks = 0
    static var indexOfSelectedWall : Int? = nil
    /// This variable is the SCNNode's material color.
    private var nodeColor: NSColor?
    private var lastDrawn: SCNNode?
    private var lastClick: SCNHitTestResult?
    /// This variable is the associated node of the selected wall from the user.
    var selectedNode: SCNNode?{
        willSet{
            
            //reset the color
            if(nodeColor != nil && selectedNode != nil){
                selectedNode!.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
                selectedNode!.geometry?.firstMaterial?.diffuse.contents = nodeColor
                if(newValue != nil){
                    nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
                }
            }else{
                if(newValue != nil){
                    nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
                }
            }
        }
    }
    /// This variable is the snap point when the user is in double-click focus mode. Right now, there are snap points at endpoints and midway points.
    var hoverNode: SCNNode?{
        willSet{
            if(hoverNode == nil){
                newValue?.isHidden = false
            }else{
                if(newValue != hoverNode && hoverNode!.name != "click"){
                    newValue?.isHidden = false
                    hoverNode?.isHidden = true
                }
            }
        }
    }
    /// This variable is the highlighted wall.
    /// - TODO: change spelling
    var hightlightFace : SCNNode?{
        willSet{
            if(nodeColor != nil){
                hightlightFace?.removeFromParentNode()
            }
        }
    }
    
    func deleteNode(){
        selectedNode?.removeFromParentNode()
    }
    /// This function highlights a whole selected node face.
    /// - TODO: change spelling
    func higlight(){
        selectedNode!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.59, saturation: 0.20, brightness: 1, alpha: 1.0)
    }
    
    func removeDrawing(){
        lastDrawn?.removeFromParentNode()
        lastDrawn = nil
        lastClick = nil
        drawingclicks = 0
    }
    
    func drawing() -> Bool{
        return lastDrawn == nil
    }
    
    func addClickPoint(_ result: SCNHitTestResult,_ click: Bool){
        if(lastClick == nil && click){
            lastClick = result
        }else if(lastClick == nil || lastClick!.node != result.node){
            return
        }
        
        if(click){
            drawingclicks+=1
            if(drawingclicks != 2){
                lastClick = result
            }
        }else if (lastDrawn != nil && drawingclicks != 2){
            //stops continuous drawing
            lastDrawn?.removeFromParentNode()
        }
        
        var MasterPath = NSBezierPath()
        let currentCord = result.localCoordinates
        let lastCord = lastClick?.localCoordinates
        
        if(drawingclicks == 1){
            
            if(shapeSelection == 0){
                //rectangle
                MasterPath = NSBezierPath(rect: NSMakeRect(lastClick!.localCoordinates.x, lastClick!.localCoordinates.y,currentCord.x - lastCord!.x,currentCord.y - lastCord!.y))
            }else if(shapeSelection == 1){
                //rounded rectangle
                let xOffset = abs(currentCord.x - lastCord!.x)
                let yOffset = abs(currentCord.y - lastCord!.y)
                
                
                if(currentCord.x - lastCord!.x >= 0 && currentCord.y - lastCord!.y >= 0){
                    MasterPath = NSBezierPath(roundedRect: NSMakeRect(lastCord!.x, lastCord!.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x < 0 && currentCord.y - lastCord!.y < 0){
                    MasterPath = NSBezierPath(roundedRect: NSMakeRect(currentCord.x, currentCord.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x < 0 && currentCord.y - lastCord!.y >= 0){
                    MasterPath = NSBezierPath(roundedRect: NSMakeRect(currentCord.x, lastCord!.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x >= 0 && currentCord.y - lastCord!.y < 0){
                    MasterPath = NSBezierPath(roundedRect: NSMakeRect(lastCord!.x, currentCord.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }
                
            }else if(shapeSelection == 2){
                //circle
                MasterPath = NSBezierPath(ovalIn: NSMakeRect(lastClick!.localCoordinates.x, lastClick!.localCoordinates.y,currentCord.x - lastCord!.x,currentCord.y - lastCord!.y))
            }
            MasterPath.flatness = 0.0001
            
            
            
            let shape = SCNShape(path: MasterPath, extrusionDepth: 0.0001)
            let locNode = SCNNode(geometry: shape)
            locNode.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.8, saturation: 0.40, brightness: 1, alpha: 1.0)
            locNode.name = "click"
            self._addChild(locNode)
            lastDrawn = locNode

        }else if(drawingclicks > 1){
            drawingclicks = 0
            
            let curWall = curBoxModel.walls[Int((selectedNode?.name!)!)!]!
            
            if(shapeSelection == 0){
                //rectangle
                curWall.wallShapes.append(Rectangle(NSMakeRect(lastClick!.localCoordinates.x, lastClick!.localCoordinates.y,currentCord.x - lastCord!.x,currentCord.y - lastCord!.y),ShapeType.rectangle))
            }else if(shapeSelection == 1){
                //rounded rectangle
                //rounded rectangle
                let xOffset = abs(currentCord.x - lastCord!.x)
                let yOffset = abs(currentCord.y - lastCord!.y)
                
                
                if(currentCord.x - lastCord!.x >= 0 && currentCord.y - lastCord!.y >= 0){
                    shapePath?.appendRoundedRect(NSMakeRect(lastCord!.x, lastCord!.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x < 0 && currentCord.y - lastCord!.y < 0){
                    shapePath?.appendRoundedRect(NSMakeRect(currentCord.x, currentCord.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x < 0 && currentCord.y - lastCord!.y >= 0){
                    shapePath?.appendRoundedRect(NSMakeRect(currentCord.x, lastCord!.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }else if(currentCord.x - lastCord!.x >= 0 && currentCord.y - lastCord!.y < 0){
                    shapePath?.appendRoundedRect(NSMakeRect(lastCord!.x, currentCord.y,xOffset,yOffset), xRadius: roundedRadius, yRadius: roundedRadius)
                }
                
                curWall.wallShapes.append(RoundedRectangle(NSMakeRect(lastClick!.localCoordinates.x, lastClick!.localCoordinates.y,currentCord.x - lastCord!.x,currentCord.y - lastCord!.y),ShapeType.roundedRectangle,roundedRadius,roundedRadius))
            }else if(shapeSelection == 2){
                //circle
                curWall.wallShapes.append(Circle(NSMakeRect(lastClick!.localCoordinates.x, lastClick!.localCoordinates.y,currentCord.x - lastCord!.x,currentCord.y - lastCord!.y),ShapeType.circle))
            }
            /// update wall's path after adding the shape
            curWall.updatePath()
            curBoxModel.sceneGenerator.generateScene(curBoxModel)
                
        }
 
    }
    
    /**
     This function is to thinly highlight the edge of a wall when it is in double-click focus mode.
     - Parameters:
        - thickness: this is how thick the line appears in the view
        - insideSelection: this is whether the highlighted line is on the inner or outer face of the focused wall
        - idvLines: unsure
     */
    func highlightEdges(thickness: CGFloat = 0.1, insideSelection: Bool = false, idvLines: Bool = false){
        let path = ((selectedNode?.geometry as! SCNShape).path!)
        let lineShape = LineDrawing(path, thickness, insideLine: insideSelection)
        let lines = [Line(NSMakePoint(0.0, 0.0), NSMakePoint(0.0, 1.0)), Line(NSMakePoint(0.0, 0.0), NSMakePoint(1.0, 0.0)), Line(NSMakePoint(0.0, 0.0), NSMakePoint(1.0, 1.0)), Line(NSMakePoint(1.0, 1.0), NSMakePoint(1.0, 0.0)), Line(NSMakePoint(1.0, 1.0), NSMakePoint(2.0, 2.0)), Line(NSMakePoint(0.0, 1.0), NSMakePoint(1.0, 1.0))]
        _ = lineShape.findClosedPath(lines)
        
        
        if(idvLines){
            let shapes = lineShape.generateIndv()
            for shape in shapes{
                let locNode = SCNNode(geometry: shape)
                locNode.name = shape.name
                locNode.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.8, saturation: 0.40, brightness: 1, alpha: 1.0)
                locNode.isHidden = true
                self._addChild(locNode)
            }
        }else{
            hightlightFace = SCNNode(geometry: lineShape.shape)
            hightlightFace!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.8, saturation: 0.40, brightness: 1, alpha: 1.0)
            self._addChild(hightlightFace!)
        }
    }
    
    
    func highlightSide(){
        
        let newShape = SCNShape(path: (selectedNode?.geometry as! SCNShape).path, extrusionDepth: shapeDepth)
        hightlightFace = SCNNode(geometry: newShape)
        hightlightFace!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.8, saturation: 0.40, brightness: 1, alpha: 1.0)
        
        self._addChild(hightlightFace!)
    }

    private func _addChild(_ node:SCNNode){
        //Since its isometric select the side that is being looked at
        //what side is being looked at is calculated by the camera angle ¬
        if(selectedNode?.position.x != 0.0){
            if(SceneGenerator.shared.cameraOrbit.eulerAngles.y/CGFloat.pi*180 > 0){
                node.position.z -= (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }else{
                node.position.z += (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }
        }else if(selectedNode?.position.y != 0.0){
            if(SceneGenerator.shared.cameraOrbit.eulerAngles.x/CGFloat.pi*180 > 0){
                node.position.z += (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }else{
                node.position.z -= (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }
        }else if(selectedNode?.position.z != 0.0){
            if(abs(SceneGenerator.shared.cameraOrbit.eulerAngles.y/CGFloat.pi*180) > 90){
                node.position.z -= (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }else{
                node.position.z += (CGFloat(boxModel!.materialThickness) + shapeDepth)
            }
        }
        
        selectedNode?.addChildNode(node)
    }
    
    init(){
        
    }
    
}
