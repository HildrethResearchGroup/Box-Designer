//
//  SelectionHandeling.swift
//  Box Designer
//
//  Created by CSCI370 on 9/14/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit

class SelectionHandeling{
    
    static let shared = SelectionHandeling()
    
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
    
    
    
    func higlight(){
        selectedNode!.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.59, saturation: 0.20, brightness: 1, alpha: 1.0)
    }
    
    init(){
        
    }
    
}
