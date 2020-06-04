//
//  WallModel.swift
//  Box Designer
//
//  Created by Grace Clark on 6/4/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

//this allows us to use Point as a parameter and return type
typealias Point = (x:Double, y: Double, z:Double)


class WallModel {
    
    init(_ path: NSBezierPath, tabs tabStyle: TabStyle) {
        self.path = path
        self.tabStyle = tabStyle
    }
    
    var delegate: WallModelDelegate? = nil //set when you create the wall, either on awakeFromNib() or in addWall()
    
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

protocol WallModelDelegate {
    //use for changes in individual WALL
    func wallModelTabStyleDidChange(_ tabStyle: TabStyle)
    func wallModelMaterialThicknessDidChange(_ materialThickness: Double)
    func wallModelWidthDidChange(_ wallWidth: Double)
    func wallModelLengthDidChange(_ wallLength: Double)
    func wallModelLocationDidChange(_ location: Point)
}
