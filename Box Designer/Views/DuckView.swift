//
//  DuckView.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

class DuckView: NSView {
    
    // MARK: - Button State
    var areDucksSafe = false {
        didSet {
            if areDucksSafe != oldValue {
                self.needsDisplay = true
            }
        }
    }
    
    // MARK: -  Colors
    let color_ducksInDanger = NSColor.orange
    let color_ducksSafe: NSColor = .green
    
    // MARK: - Drawing Functions
    override func draw(_ dirtyRect: NSRect) {
        // Fill the background with white
        //NSColor.white.setFill()
        //dirtyRect.fill()
        
        let sframe = self.bounds
        
        let ovalRect = NSMakeRect(sframe.minX + 2, sframe.minY + 2, sframe.width - 4, sframe.height - 4)
        
        let ovalPath = NSBezierPath(ovalIn: ovalRect)
        let fillColor = self.getFillColor()
        let strokeColor = self.getStrokeColor()
        fillColor.setFill()
        ovalPath.fill()
        strokeColor.setStroke()
        ovalPath.lineWidth = 1.5
        ovalPath.stroke()
    }
    
    
    func getFillColor() -> NSColor {
        if areDucksSafe {
            return color_ducksSafe
        } else { return color_ducksInDanger}
    }
    
    private func getStrokeColor() -> NSColor {
        let fillColor = self.getFillColor()
        let percentage:CGFloat = 30/100
        var red = fillColor.redComponent
        var green = fillColor.greenComponent
        var blue = fillColor.blueComponent
        let alpha = fillColor.alphaComponent

        red = min(red - percentage, 1.0)
        green = min(green - percentage, 1.0)
        blue = min(blue - percentage, 1.0)
        
        let strokeColor = NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        
        return strokeColor
    }
    
}
