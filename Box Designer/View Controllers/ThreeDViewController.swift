//
//  ThreeDView.swift
//  Box Designer
//
//  Created by FieldSession on 6/2/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation

import SceneKit

class ThreeDViewController: NSViewController, BoxSceneMakerDelegate {

    @IBOutlet weak var boxView: SCNView!
    
    var boxSceneMaker = BoxSceneMaker()
    
    override func awakeFromNib(){
        boxView.allowsCameraControl = true
        boxSceneMaker.sceneSetup()
        boxView.scene = boxSceneMaker.scene
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    func sceneDidChange() {
        boxView.scene = boxSceneMaker.scene
    }
}
