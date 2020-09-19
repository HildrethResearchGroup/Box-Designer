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
    init(_ pointA: NSPoint, _ pointB: NSPoint, thickness: CGFloat = 0.01){
        //lines point from a to b
        
        //round the points to stop inaccuracy drift
        self.bottomPoint.x = (pointA.x*1000).rounded()/1000
        self.bottomPoint.y = (pointA.y*1000).rounded()/1000
        
        self.topPoint.x = (pointB.x*1000).rounded()/1000
        self.topPoint.y = (pointB.y*1000).rounded()/1000
        
        
        self.thickness = thickness
        angle = atan((pointB.y - pointA.y)/(pointB.x - pointA.x))
    }
    
    //top is the larger point
    private var topPoint: NSPoint = NSPoint()
    private var bottomPoint: NSPoint = NSPoint()
    private var angle: CGFloat
    
    var thickness: CGFloat
    
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
        //ensure its not a point then check
        return(self.topPoint == self.bottomPoint)
    }
    
    func returnTestPoints(_ region: linePos)->[NSPoint]{
        var returnValue: [NSPoint] = []
            
        switch (region) {
            case linePos.top:
                //Far Left
                var modPoint : NSPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (45*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (45*CGFloat.pi/180)))
                returnValue.append(NSMakePoint(topPoint.x + modPoint.x, topPoint.y + modPoint.y))
                //Close Left
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (135*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (135*CGFloat.pi/180)))
                returnValue.append(NSMakePoint(topPoint.x + modPoint.x, topPoint.y + modPoint.y))
                //Far Right
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle - (45*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle - (45*CGFloat.pi/180)));
                returnValue.append(NSMakePoint(topPoint.x + modPoint.x, topPoint.y + modPoint.y))
                //Close Right
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (225*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (225*CGFloat.pi/180)))
                returnValue.append(NSMakePoint(topPoint.x + modPoint.x, topPoint.y + modPoint.y))
                
                break
            case linePos.center:
                //center left
                var modPoint : NSPoint = NSMakePoint(abs(self.thickness)*cos(angle + (90*CGFloat.pi/180)), abs(self.thickness)*sin(angle + (90*CGFloat.pi/180)));
                returnValue.append(NSMakePoint((topPoint.x + bottomPoint.x)/2 + modPoint.x, (topPoint.y + bottomPoint.y)/2  + modPoint.y))
                //center right
                modPoint = NSMakePoint(abs(self.thickness)*cos(angle - (90*CGFloat.pi/180)), abs(self.thickness)*sin(angle - (90*CGFloat.pi/180)))
                returnValue.append(NSMakePoint((topPoint.x + bottomPoint.x)/2 + modPoint.x, (topPoint.y + bottomPoint.y)/2  + modPoint.y))
                break
            case linePos.bottom:
                //Far Left
                var modPoint : NSPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (135*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (135*CGFloat.pi/180)))
                returnValue.append(NSMakePoint(bottomPoint.x + modPoint.x, bottomPoint.y + modPoint.y))
                //Close Left
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (45*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (45*CGFloat.pi/180)));
                returnValue.append(NSMakePoint(bottomPoint.x + modPoint.x, bottomPoint.y + modPoint.y))
                //Far Right
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle + (225*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle + (225*CGFloat.pi/180)))
                returnValue.append(NSMakePoint(bottomPoint.x + modPoint.x, bottomPoint.y + modPoint.y))
                //Close Right
                modPoint = NSMakePoint(abs(self.thickness)*sqrt(2)*cos(angle - (45*CGFloat.pi/180)), abs(self.thickness)*sqrt(2)*sin(angle - (45*CGFloat.pi/180)));
                returnValue.append(NSMakePoint(bottomPoint.x + modPoint.x, bottomPoint.y + modPoint.y))
                
                break
        }
        for n in 0..<returnValue.count{
            returnValue[n].x = (returnValue[n].x*1000).rounded()/1000
            returnValue[n].y = (returnValue[n].y*1000).rounded()/1000
        }
        return returnValue
    }
    
}
