import Foundation
import Cocoa
import SceneKit
/**
 This class handles the continual scene generation that is viewed in the application.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: SceneGenerator.swift was created on 6/7/2020.
 
 */
class SceneGenerator {
    
    /**
     SceneGenerator is a singleton; it needs access points in various unrelated
     and unconnected classes, but there must only be ONE instance of the class,
     so that BoxViewController is receiving the correct scene upon any changes.
     */
    static let shared = SceneGenerator()
    /// This variable provides the coordinate space for the box template.
    let cameraOrbit = SCNNode()
    /// This variable is from the custom delegate that's sole purpose is to properly update the scene if the user changes it.
    var delegate: SceneGeneratorDelegate?
    /// This variable indicates how the user is viewing their design.
    var camera: SCNNode?
    /// This variable allows the specifications from cameraOrbit and camera to be displayed in the app window.
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
    /**
     This class initializer instanstiates a nil delegate and a scene (which is the only scene, since this class is a Singleton).
     */
    private init() {
        delegate = nil
        scene = SCNScene()
    }
    
    /**
     This function renders the display in the view, ensuring that all components are drawn, the camera view is correct, and colors are as desired.
     - Parameters:
        - boxModel: The scene generation needs to be on the current box model desired by the user so that it can render accurately.
     */
    func generateScene(_ boxModel: BoxModel) {
        
        self.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        //ensure that the camera stays on the center on the box
        cameraOrbit.position = SCNVector3Make(CGFloat(boxModel.boxWidth/2), CGFloat(boxModel.boxHeight/2), CGFloat(boxModel.boxLength/2))
        var wallNumber = 0
        for wall in boxModel.walls.values {
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
                // adjust inner wall rotation, as they are always smallCorner types
                if wall.innerWall && wall.innerPlane == WallType.largeCorner {
                    newNode.rotation = SCNVector4Make(1, 0, 0, CGFloat.pi/2)
                } else if wall.innerWall && wall.innerPlane == WallType.longCorner {
                    newNode.rotation = SCNVector4Make(0, 1, 0, -CGFloat.pi/2)
                }
                // non-inner small corners and inner small corners are correctly rotated to begin with
                break
            case WallType.longCorner:
                //rotate -90 degrees around +y axis
                newNode.rotation = SCNVector4Make(0, 1, 0, -CGFloat.pi/2)
            }
            
            //adjust colors for ease in differentiating walls
            let brightness = CGFloat(1.0 - Double(wallNumber) / Double(boxModel.walls.count))
            newNode.geometry?.firstMaterial?.diffuse.contents = NSColor(calibratedHue: 0.59, saturation: 0.90, brightness: brightness, alpha: 1.0)
            // name the node to be able to delete selected component from BoxModel.walls array
            newNode.name = String(wall.getWallNumber())
            //add to the rootNode
            scene.rootNode.addChildNode(newNode)
            wallNumber += 1
        }
        adjustLighting()
        adjustCamera(boxModel)
    }
    
    /**
     This function ensures the lighting in the scene is as desired; it deals with the background lighting, as well as the lighting on the box to make it more cube-like.
     */
    func adjustLighting() {
        
        // this section denotes the color for the background (more white would be 1.0) behind the cube
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = NSColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        // this section ensures the box rendering looks like a cube instead of a 2d shape
        // basically, the shading on the different components
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = NSColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
    }
    
    /**
     This function will either set up a camera if it hasn't been initialized, or it adjusts the scene according to the updated camera from the user.
     - Parameter boxModel: This input ensures the camera is initialized according to the default box model.
     - Note: The camera is not initialized until the first call to this function.
     */
    func adjustCamera(_ boxModel: BoxModel) {
        // if camera hasn't been set up, initialize it and set up its specifications
        // else, adjust it according to the changes
        if camera == nil {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            // Starting position of camera is dependent on largest box dimension
            cameraNode.position = SCNVector3Make(0, 0, pow(CGFloat(max(boxModel.boxWidth, boxModel.boxHeight, boxModel.boxLength)), 4))
            cameraNode.camera?.usesOrthographicProjection = true
            cameraNode.camera?.automaticallyAdjustsZRange = true
            // Orthographic scale is dependent on largest box dimension
            cameraNode.camera?.orthographicScale = max(boxModel.boxWidth, boxModel.boxHeight, boxModel.boxLength)
            cameraOrbit.addChildNode(cameraNode)
            cameraOrbit.eulerAngles.x -= CGFloat.pi/8
            cameraOrbit.eulerAngles.y -= CGFloat.pi/4
            self.scene.rootNode.addChildNode(cameraOrbit)
            camera = cameraNode
        }else{
            cameraOrbit.addChildNode(camera!)
            self.scene.rootNode.addChildNode(cameraOrbit)
        }

    }
}

/**
 This is a custom protocol whose sole purpose is to update the scene whenever the user adjusts the inputs in the app.
 */
protocol SceneGeneratorDelegate {
    /**
     This function updates the singleton scene object that is viewed in the app.
     */
    func updateScene()
}
