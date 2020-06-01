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
typealias Point = (x:Double, y: Double, z:Double)

enum TabStyle {
    //if these names don't make sense we can change them!
    //or if you find theres a better way to keep track of this we can get rid of it!
    case smallCorner
    case largeCorner
    case longCorner
}

struct wallModel {
    var delegate: wallModelDelegate? = nil //set when you create the wall, either on awakeFromNib() or in addWall()
    
    //this may or may not be helpful
    var path: NSBezierPath
    
    var tabStyle: TabStyle {
        didSet {
            if tabStyle != oldValue {
                delegate?.wallModelTabStyleDidChange(tabStyle)
            }
        }
    }
    
    var materialThickness: Double = 0.25 {
        didSet {
            if materialThickness != oldValue {
                delegate?.wallModelMaterialThicknessDidChange(materialThickness)
            }
        }
    }
    //these may need to be renamed to be more descriptive
    var wallWidth: Double = 4.0 {
        didSet {
            if wallWidth != oldValue {
                delegate?.wallModelWidthDidChange(wallWidth)
            }
        }
    }
    
    var wallLength: Double = 4.0 {
        didSet {
            if wallLength != oldValue {
                delegate?.wallModelLengthDidChange(wallLength)
            }
        }
    }
    
    //three-variable tuple for x, y, z position
    var location: Point = (0.0, 0.0, 0.0) {
        didSet {
            if location != oldValue {
                delegate?.wallModelLocationDidChange(location)
            }
        }
    }
}

struct boxModel {
    var delegate: boxModelDelegate? = nil //add in initial awake from nib
    
    //as walls are added from wakeFromNib() or other functions, add to array
    var array: [wallModel]
    
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

protocol wallModelDelegate {
    //use for changes in individual WALL
    func wallModelTabStyleDidChange(_ tabStyle: TabStyle)
    func wallModelMaterialThicknessDidChange(_ materialThickness: Double)
    func wallModelWidthDidChange(_ wallWidth: Double)
    func wallModelLengthDidChange(_ wallLength: Double)
    func wallModelLocationDidChange(_ location: Point)
}

protocol boxModelDelegate {
    //use for changes applying to WHOLE BOX - likely have to also call wallModelDidChange in implementation
    //(e.g. adding in a wall -> need to add tab holes to another wall)
    func boxModelWidthDidChange(_ boxWidth: Double)
    func boxModelLengthDidChange(_ boxLength: Double)
    func boxModelHeightDidChange(_ boxHeight: Double)
    func boxModelTabWidthDidChange(_ tabWidth: Double)
}
