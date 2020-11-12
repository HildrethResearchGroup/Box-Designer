//
//  BoxViewController.swift
//  Box Designer
//
//  Created by Grace Clark on 6/6/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

class BoxViewController: NSViewController, SceneGeneratorDelegate {

    let sceneGenerator = SceneGenerator.shared
    
    @IBOutlet weak var boxView: SCNView!
    
    override func awakeFromNib() {
        sceneGenerator.delegate = self
        self.boxView.allowsCameraControl = false
        self.boxView.scene = sceneGenerator.scene
        self.boxView.needsDisplay = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateScene() {
        self.boxView.scene = sceneGenerator.scene
    }
    
}
