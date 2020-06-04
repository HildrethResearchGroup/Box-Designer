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
import AppKit




class MainViewController: NSViewController {
    
    let threeDView = ThreeDViewController()
    
    //@IBOutlet weak var boxView: SCNView!
    
    //@IBOutlet weak var button_edgeType: NSButton!
    
    
    var edgeType = EdgeType.finger {
        didSet {
            if edgeType != oldValue {
                //self.sceneSetup()
            }
        }
        
    }
    
    
    
    @IBAction func changeEdgeType(_ sender: Any) {
        let currentEdgeType = edgeType
        
        if currentEdgeType == .finger {
            edgeType = .overlapping
        } else if currentEdgeType == .overlapping {
            edgeType = .finger
        }
        
    }
    
        
   // MARK: Lifecycle
    
    override func awakeFromNib(){
        //sceneSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    func addThreeDView() {
        addChild(threeDView)
        view.addSubview(threeDView.view)
    }
}
    
