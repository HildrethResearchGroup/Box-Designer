//
//  SelectionHandeling.swift
//  Box Designer
//
//  Created by CSCI370 on 9/14/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa

class SelectionHandeling{
    
    static let shared = SelectionHandeling()
    let shapeDepth: CGFloat = 0.0001
    var inside: Bool = false
    
    private var nodeColor: NSColor?
    var selectedNode: SCNNode?{
        willSet{
            //reset the color
            if(nodeColor != nil){
                selectedNode!.geometry?.firstMaterial?.diffuse.contents = nodeColor
                nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
            }else{
                nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
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
