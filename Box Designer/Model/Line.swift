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

//technically this is a segment
class Line: CustomStringConvertible{
    init(_ pointA: NSPoint, _ pointB: NSPoint, thickness: CGFloat = 0.01){
        //lines point from a to b
        
        //round the points to stop inaccuracy drift
        self.bottomPoint.x = (pointA.x*1000).rounded()/1000
        self.bottomPoint.y = (pointA.y*1000).rounded()/1000
        
        self.topPoint.x = (pointB.x*1000).rounded()/1000
        self.topPoint.y = (pointB.y*1000).rounded()/1000
        
        
        self.thickness = thickness
        
        self.A = self.bottomPoint.y - self.topPoint.y
        self.B = self.topPoint.x - self.bottomPoint.x
        
        angle = atan((pointB.y - pointA.y)/(pointB.x - pointA.x))
        //correct the angles
        if(angle*180/CGFloat.pi < 0.0){
            angle += 2*CGFloat.pi
        }else if((angle*180/CGFloat.pi).sign == .minus && (angle*180/CGFloat.pi).isZero){
            angle += CGFloat.pi
        }
        
        if(self.A == 0 && self.B == 0){
            //this is a point so dont define the slope or intercepts
        }else if(self.A == 0){
            //no x intercept and slope is 0
            self.yIntercept = self.bottomPoint.y
            self.slope = 0
            self.C = yIntercept! * self.B
        }else if(self.B == 0){
            //no y intercept and slope is infinity
            self.xIntercept = self.bottomPoint.x
            self.slope = CGFloat.infinity
            self.C = xIntercept! * self.B
        }else{
            self.slope = -self.A/self.B
            self.yIntercept = self.bottomPoint.y - (self.bottomPoint.x * self.slope!)
            self.xIntercept = -self.yIntercept!/self.slope!
            self.C = yIntercept! * self.B
        }
    }
    
    //top is the larger point
    var topPoint: NSPoint = NSPoint()
    var bottomPoint: NSPoint = NSPoint()
    var angle: CGFloat
    //line intercept form
    var xIntercept: CGFloat?
    var yIntercept: CGFloat?
    var slope: CGFloat?
    //line standard form
    var A: CGFloat
    var B: CGFloat
    //C is always defined needs to be refactored
    var C: CGFloat?
    
    var thickness: CGFloat
    
    func intercept(_ otherLine:Line)->NSPoint?{
        let x = -((self.B * otherLine.C!) - (self.C! * otherLine.B))/((self.A * otherLine.B) - (self.B * otherLine.A))
        let y = ((self.A * otherLine.C!) - (self.C! * otherLine.A))/((self.A * otherLine.B) - (self.B * otherLine.A))
        if(x <= self.bottomPoint.x && x >= self.topPoint.x){
            return nil
        }else{
            return nil
        }
    }
    
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
     
    func opposite(_ point:NSPoint) -> NSPoint? {
        if(point == topPoint){
            return bottomPoint
        }else if(point == topPoint){
            return topPoint
        }
        return nil
    }
    
    func rectanglePath()->NSBezierPath{
        let shapePath = NSBezierPath()
        
        var modPoint : NSPoint = NSMakePoint(abs(self.thickness)*cos(angle + (90*CGFloat.pi/180)), abs(self.thickness)*sin(angle + (90*CGFloat.pi/180)));
        let bottomLeft = NSMakePoint(bottomPoint.x + modPoint.x, bottomPoint.y + modPoint.y)
        
        modPoint = NSMakePoint(abs(self.thickness)*cos(angle - (90*CGFloat.pi/180)), abs(self.thickness)*sin(angle - (90*CGFloat.pi/180)))
        let topRight = NSMakePoint(topPoint.x + modPoint.x, topPoint.y + modPoint.y)
        
        shapePath.appendRect(NSMakeRect(bottomLeft.x, bottomLeft.y, topRight.x - bottomLeft.x, topRight.y - bottomLeft.y))
        return shapePath
    }
    
    func midpoint()->NSPoint{
        return NSMakePoint((topPoint.x + bottomPoint.x) / 2, (topPoint.y + bottomPoint.y) / 2)
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
    
    public var description: String { return "\(bottomPoint) -> \(topPoint)" }
    
}
