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

//    boxInput = BoxSceneMaker.init()
    
    // height, width,length buttons
    @IBAction func okHeightButton(_ sender: Any) {
        if  let heightValue = Double(heightTextField.stringValue) {
            BoxSceneMaker.boxInput.setUserHeight(height: heightValue)
            print(BoxSceneMaker.boxInput.height)
        }
    }
    @IBAction func okWidthButton(_ sender: Any) {
        if  let widthValue = Double(widthTextField.stringValue) {
            BoxSceneMaker.boxInput.setUserWidth(width: widthValue)
            print(BoxSceneMaker.boxInput.width)
        }
    }
    @IBAction func okLengthButton(_ sender: Any) {
        if  let lengthValue = Double(lengthTextField.stringValue) {
            BoxSceneMaker.boxInput.setUserLength(length: lengthValue)
            print(BoxSceneMaker.boxInput.length)
        }
    }
}
