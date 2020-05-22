//
//  MainViewController.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

class MainViewController: NSViewController, DuckModelDelegate {
       
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
    
    
}
