//
//  BoxModel.swift
//  Box Designer
//
//  Created by Justin Clark on 6/1/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

//this allows us to use Point as a parameter and return type
//typealias Point = (x:Double, y: Double, z:Double)

class BoxModel {
    init(_ walls: [WallModel]) {
        self.walls = walls
    }
    
    
    var delegate: BoxModelDelegate? = nil //add in initial awake from nib
    
    //as walls are added from wakeFromNib() or other functions, add to array
    var walls: [WallModel]
    
    var boxWidth: Double = 4.50 {
        didSet {
            if boxWidth != oldValue {
                delegate?.boxModelWidthDidChange(boxWidth)
            }
        }
    }
    var boxLength: Double = 4.50 {
        didSet {
            if boxLength != oldValue {
                delegate?.boxModelLengthDidChange(boxLength)
            }
        }
    }
    var boxHeight: Double = 4.50 {
        didSet {
            if boxHeight != oldValue {
                delegate?.boxModelHeightDidChange(boxHeight)
            }
        }
    }
    
    var tabWidth: Double = 0.5 {
        didSet {
            if tabWidth != oldValue {
                delegate?.boxModelTabWidthDidChange(tabWidth)
            }
        }
    }
}

protocol BoxModelDelegate {
    //use for changes applying to WHOLE BOX - likely have to also call wallModelDidChange in implementation
    //(e.g. adding in a wall -> need to add tab holes to another wall)
    func boxModelWidthDidChange(_ boxWidth: Double)
    func boxModelLengthDidChange(_ boxLength: Double)
    func boxModelHeightDidChange(_ boxHeight: Double)
    func boxModelTabWidthDidChange(_ tabWidth: Double)
}
