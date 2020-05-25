//
//  MainViewController.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class MainViewController: NSViewController
    /*DuckModelDelegate*/ {
    /*
    @IBOutlet weak var button_saveDucks: NSButton!
    @IBOutlet weak var duckView: DuckView!
     
    
    var duckModel = DuckModel()
    
    override func awakeFromNib() {
        duckModel.delegate = self
        self.setDuckViewState(self.duckModel.duckState)
    }
    
    func setDuckViewState(_ duckState: DuckState) {
        switch duckState {
        case .safe:
            duckView.areDucksSafe = true
        case .dead, .inDanger:
            duckView.areDucksSafe = false
        }
    }
    
    
    
    
    func duckModelStateDidChange(_ duckState: DuckState) {
        setDuckViewState(duckState)
    }
    
    @IBAction func saveDucks(_ sender: Any) {
        let duckState = duckModel.duckState
        
        switch duckState {
        case .dead:
            return
        case .inDanger:
            self.duckModel.duckState = .safe
        case .safe:
            return
        }
    }
    */
    
    @IBOutlet weak var boxView: SCNView!
        
   // MARK: Lifecycle
    
    override func awakeFromNib(){
        sceneSetup()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    // MARK: Scene
    func sceneSetup() {
        let scene = SCNScene()
        let boxGeometry = SCNBox(width:4.0, height: 4.0, length: 4.0, chamferRadius: 0.01)
        let boxNode = SCNNode(geometry: boxGeometry)
        
        scene.rootNode.addChildNode(boxNode)
        
        boxView.scene = scene
        boxView.allowsCameraControl = true
        
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
    
    // MARK: File Handling
    @IBAction func openScene(_ sender: Any) {
        
    }
    
    @IBAction func saveScene(_ sender: Any) {
        
    }
    
    
}
