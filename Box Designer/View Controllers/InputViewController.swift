//
//  Input.swift
//  Box Designer
//
//  Created by FieldSession on 6/2/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation

import SceneKit

class InputViewController: NSViewController {
    
    //height, width, length text fields for input
    @IBOutlet weak var heightTextField: NSTextField!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var lengthTextField: NSTextField!
    
    // height, width,length buttons
    @IBOutlet weak var okButtonHeight: NSButton!
    @IBOutlet weak var okButtonWidth: NSButton!
    @IBOutlet weak var okButtonLength: NSButton!
    
    
    // height, width,length labels
    @IBOutlet weak var heightLabel: NSTextField!
    @IBOutlet weak var widthLabel: NSTextField!
    @IBOutlet weak var lengthLabel: NSTextField!
    
    @IBOutlet weak var tabWidthSlider: NSSlider!
    
    override func awakeFromNib(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }


    
}
