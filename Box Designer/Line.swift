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
    case far
    case close
    case center
}

class Line: CustomStringConvertible{
    init(_ pointA: NSPoint, _ pointB: NSPoint){
        self.topPoint = pointA
        self.bottomPoint = pointB
    }
    
    //top is the larger point
    private let topPoint: NSPoint
    private let bottomPoint: NSPoint
    
    var thickness: CGFloat = 0.1
    
    func perfect()->Bool{
        //can't be a point
        if(self.topPoint.x - self.bottomPoint.x == 0 && self.topPoint.y - self.bottomPoint.y == 0){
            return false
        }
        //only one can be non zero
        return(self.topPoint.x - self.bottomPoint.x != 0 && self.topPoint.y - self.bottomPoint.y != 0)
    }
    
    func horizontal()->Bool{
        //ensure its not a point then check
        if(!self.perfect()){ return false }
        return(self.topPoint.y - self.bottomPoint.y == 0)
    }
    
    func vertical()->Bool{
        //ensure its not a point then check
        if(!self.perfect()){ return false }
        return(self.topPoint.x - self.bottomPoint.x == 0)
    }
    
    func point()->Bool{
        return(self.topPoint.x - self.bottomPoint.x == 0 && self.topPoint.y - self.bottomPoint.y == 0)
    }
    
    func returnTestPoints(_ region: linePos, left:Bool)->[NSPoint]{
        var returnValue: [NSPoint] = []
        switch (region) {
            case linePos.far:
                
                break
            case linePos.center:
                
                break
            case linePos.close:
                
                break
                
        }
        return returnValue
    }
    
    public var description: String {return "\(bottomPoint) -> \(topPoint)"}
    
}
