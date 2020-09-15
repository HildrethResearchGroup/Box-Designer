//
//  Line.swift
//  Box Designer
//
//  Created by Michael Berg on 9/15/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import SceneKit
import Cocoa


enum linePos {
    case top
    case bottom
    case center
}

class Line{
    init(_ pointA: NSPoint, _ pointB: NSPoint){
        self.topPoint = pointA
        self.bottomPoint = pointB
        //abitrarily assign the points if not valid
        
        if(self.valid()){
            
        }
    }
    
    //top is the larger point
    private var topPoint: NSPoint
    private var bottomPoint: NSPoint
    
    func valid()->Bool{
        //can't be a point
        if(self.topPoint.x - self.bottomPoint.x == 0 && self.topPoint.y - self.bottomPoint.y == 0){
            return false
        }
        //only one can be non zero
        return(self.topPoint.x - self.bottomPoint.x != 0 && self.topPoint.y - self.bottomPoint.y != 0)
    }
    
    func horizontal()->Bool{
        //ensure its not a point then check
        if(!self.valid()){ return false }
        return(self.topPoint.y - self.bottomPoint.y == 0)
    }
    
    func vertical()->Bool{
        //ensure its not a point then check
        if(!self.valid()){ return false }
        return(self.topPoint.x - self.bottomPoint.x == 0)
    }
    
    func returnTestPoints()->[NSPoint]{
        var returnValue: [NSPoint]
    }
}
