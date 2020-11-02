import Foundation
import SceneKit
import Cocoa
/**
 This class handles the selection and highlighting of components that the user wants to interact with.
 - TODO: documenting this class
 - Authors: CSM Field Session Fall 2020 and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: SelectionHandling.swift was created on 9/14/2020.
 
 */
class SelectionHandling{
    
    static let shared = SelectionHandling()
    let shapeDepth: CGFloat = 0.0001
    var inside: Bool = false
    
    private var nodeColor: NSColor?
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
    
    func higlight(){
        selectedNode!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.59, saturation: 0.20, brightness: 1, alpha: 1.0)
    }
    
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
