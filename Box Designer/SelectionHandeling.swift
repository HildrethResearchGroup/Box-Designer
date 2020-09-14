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
    
    private var nodeColor: NSColor?
    var selectedNode: SCNNode?{
        willSet{
            if(nodeColor != nil){
                selectedNode!.geometry?.firstMaterial?.diffuse.contents = nodeColor
                nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
            }else{
                nodeColor = newValue!.geometry?.firstMaterial?.diffuse.contents as? NSColor
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
    
    func highlightSide(){
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.line(to: CGPoint(x: 0.0, y: 2))
        path.line(to: CGPoint(x: 2, y: 2))
        path.line(to: CGPoint(x: 2, y: 0.0))
        path.move(to: CGPoint(x: 0.5, y: 0.5))
        path.relativeLine(to: CGPoint(x: 1.0, y: 0))
        path.relativeLine(to: CGPoint(x: 0, y: 1.0))
        path.relativeLine(to: CGPoint(x: -1.0, y: 0))
        path.relativeLine(to: CGPoint(x: 0.0, y: -1.0))
        
        let newShape = SCNShape(path: (selectedNode?.geometry as! SCNShape).path, extrusionDepth: shapeDepth)
        hightlightFace = SCNNode(geometry: newShape)
        hightlightFace!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.8, saturation: 0.40, brightness: 1, alpha: 1.0)
        hightlightFace!.position.z += (0.25 + shapeDepth)
        selectedNode?.addChildNode(hightlightFace!)
        
    }
    
    init(){
        
    }
    
}
