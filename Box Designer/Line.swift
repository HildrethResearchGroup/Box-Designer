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
        if(self.perfect()){
            //swap the points as necessary
            if(horizontal()){
                if(self.topPoint.x < self.bottomPoint.x){
                    let tempPoint = self.topPoint
                    self.topPoint = self.bottomPoint
                    self.bottomPoint = tempPoint
                }
            }else{
                if(self.topPoint.y < self.bottomPoint.y){
                    let tempPoint = self.topPoint
                    self.topPoint = self.bottomPoint
                    self.bottomPoint = tempPoint
                }
            }
        }else{
            //non perfect lines
            let sizeA = pointA.x + pointA.y
            let sizeB = pointB.x + pointB.y
            if(sizeB > sizeA){
                let tempPoint = self.topPoint
                self.topPoint = self.bottomPoint
                self.bottomPoint = tempPoint
            }
        }
    }
    
    //top is the larger point
    private var topPoint: NSPoint
    private var bottomPoint: NSPoint
    
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
    
    func returnTestPoints(_ region: linePos)->[NSPoint]{
        var returnValue: [NSPoint] = []
        
        switch (region) {
            case linePos.top:
                break
            case linePos.center:
                break
            case linePos.bottom:
                break
        }
        return returnValue
    }
    
}
