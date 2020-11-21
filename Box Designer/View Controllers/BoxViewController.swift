import Foundation
import Cocoa
import SceneKit

/**
 This class handles updating the scene within the application.
 
 - Authors: CSM Field Session Summer 2020, Fall 2020, and Dr. Owen Hildreth.
 - Copyright: Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note: BoxViewController.swift was created on 6/6/2020.
 
 */
class BoxViewController: NSViewController, SceneGeneratorDelegate {
    /// This variable is the singleton SceneGenerator. It ensures all classes are handling the same scene.
    let sceneGenerator = SceneGenerator.shared
    /// This variable is the view object that is displayed in the app.
    @IBOutlet weak var boxView: SCNView!
    /**
     This is an inherited function from NSViewController.
     - See [Apple Documentation - awakeFromNib().] (https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib)
     */
    override func awakeFromNib() {
        sceneGenerator.delegate = self
        self.boxView.allowsCameraControl = false
        self.boxView.scene = sceneGenerator.scene
        self.boxView.needsDisplay = true
    }
    /**
     This is an inherited function from NSViewController.
     - See [Apple Documentation - viewDidLoad().] (https://developer.apple.com/documentation/appkit/nsviewcontroller/1434476-viewdidload)
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /**
     This function ensures the SCNView(boxView).scene is updated with the generated scene from the code.
     */
    func updateScene() {
        self.boxView.scene = sceneGenerator.scene
    }
    
}
