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
    
    /*
     SceneGenerator is a singleton; it needs access points in various unrelated
     and unconnected classes, but there must only be ONE instance of the class,
     so that BoxViewController is receiving the correct scene upon any changes.
     */
    static let shared = SceneGenerator()
    
    private init() {
        delegate = nil
        scene = SCNScene()
    }
    
    var delegate: SceneGeneratorDelegate?
    var camera: SCNNode?
    var scene: SCNScene {
        didSet {
            delegate?.updateScene()
        }
        willSet{
            if scene.rootNode.childNodes.count > 0 {
                camera = scene.rootNode.childNodes.last
            }
        }
    }
    
    func generateScene(_ boxModel: BoxModel) {
        var wallNumber = 0
        for wall in boxModel.walls {
        
            
            //create node from wall data
            let newShape = SCNShape(path: wall.path, extrusionDepth: CGFloat(wall.materialThickness))
            let newNode = SCNNode(geometry: newShape)
            
            //adjust position and rotation
            newNode.position = wall.position
            switch (wall.wallType) {
            case WallType.largeCorner:
                //rotate 90 degrees around +x axis
                newNode.rotation = SCNVector4Make(1, 0, 0, CGFloat.pi/2)
            case WallType.smallCorner:
                //is correctly rotated to begin with
                break
            case WallType.longCorner:
                //rotate -90 degrees around +y axis
                newNode.rotation = SCNVector4Make(0, 1, 0, -CGFloat.pi/2)
            }
            
            //adjust colors for ease in differentiating walls
            let brightness = CGFloat(1.0 - Double(wallNumber) / Double(boxModel.walls.count))
            newNode.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.59, saturation: 0.90, brightness: brightness, alpha: 1.0)
            
            //add to the rootNode
            scene.rootNode.addChildNode(newNode)
            wallNumber += 1
        }
        adjustLighting(scene)
        adjustCamera(scene)
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
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
    }
    
    func adjustCamera(_ scene: SCNScene) {
        
        if camera == nil {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        cameraNode.camera?.usesOrthographicProjection = true
        
        scene.rootNode.addChildNode(cameraNode)
        }else{
            scene.rootNode.addChildNode(camera!)
        }

    }
}

protocol SceneGeneratorDelegate {
    func updateScene()
}
