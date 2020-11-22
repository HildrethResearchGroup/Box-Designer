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
    /// This is the extrusion depth for edge highlighting when user is in double-click "focus" mode.
    let shapeDepth: CGFloat = 0.0001
    
    var inside: Bool = false
    static var indexOfSelectedWall : Int? = nil
    /// This variable is the SCNNode's material color.
    private var nodeColor: NSColor?
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
                if(newValue != hoverNode){
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
                node.position.z -= (0.25 + shapeDepth)
            }else{
                node.position.z += (0.25 + shapeDepth)
            }
        }else if(selectedNode?.position.y != 0.0){
            if(SceneGenerator.shared.cameraOrbit.eulerAngles.x/CGFloat.pi*180 > 0){
                node.position.z += (0.25 + shapeDepth)
            }else{
                node.position.z -= (0.25 + shapeDepth)
            }
        }else if(selectedNode?.position.z != 0.0){
            if(abs(SceneGenerator.shared.cameraOrbit.eulerAngles.y/CGFloat.pi*180) > 90){
                node.position.z -= (0.25 + shapeDepth)
            }else{
                node.position.z += (0.25 + shapeDepth)
            }
        }
        
        selectedNode?.addChildNode(node)
    }
    
    init(){
        
    }
    
}
