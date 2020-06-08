//
//  SceneGenerator.swift
//  Box Designer
//
//  Created by Grace Clark on 6/7/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class SceneGenerator {
    
    var scene = SCNScene()
    
    func generateScene(_ boxModel: BoxModel) {
        
        let scene = SCNScene()
        for wall in boxModel.walls {
            let newShape = SCNShape(path: wall.path, extrusionDepth: CGFloat(wall.materialThickness))
            let newNode = SCNNode(geometry: newShape)
            newNode.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.75, saturation: 0.80, brightness: 0.50, alpha: 1.0)
            scene.rootNode.addChildNode(newNode)
        }
        adjustLighting(scene)
        adjustCamera(scene)
        self.scene = scene
    }
    
    func adjustLighting(_ scene: SCNScene) {
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = NSColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = NSColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(50, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
    }
    
    func adjustCamera(_ scene: SCNScene) {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(50, 50, 50)
        cameraNode.camera?.usesOrthographicProjection = true
        
        scene.rootNode.addChildNode(cameraNode)
    }

}
