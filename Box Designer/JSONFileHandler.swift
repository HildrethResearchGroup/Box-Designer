//
//  JSONFileSaver.swift
//  Box Designer
//
//  Created by Grace Clark on 6/9/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa

class JSONFileHandler {
    
    /*
     As the BoxModel's state contains more variables, these functions also need to ensure that they are
     a) saving all state and b) reading in proper variables from the JSON file for the incoming model.
     */
    
    
    func saveAsJSON(to targetURL: URL, _ model: BoxModel) throws {
        do {
            var textToWrite = String() //this will hold the eventual finished string
            
            //start the boxModel object
            textToWrite += "\"boxModel\" {\n"
            
            //iterate through the boxModel's array of walls:
            for wall in 0..<model.walls.count {
                
                //object; each thing that follows is on a separate line with extra indentation
                textToWrite += "\t\"wall\(wall)\" {\n"
                
                //path
                textToWrite += "\t\t\"path\": {\n"
                for element in 0 ..< model.walls[wall].path.elementCount {
                    
                    var point = NSPoint()
                    let elementType = model.walls[wall].path.element(at: element, associatedPoints: &point)
                    
                    /*
                     Points in the path are stored as CGFloat.
                     However, CGFloat does not conform to "LosslessStringConvertible".
                     Doubles, on the other hand, do; so, convert
                     the x and y values to type Double, then
                     to type String.
                     */
                    let x: Double = Double(point.x)
                    let y: Double = Double(point.y)
                    
                    switch (elementType) {
                    case NSBezierPath.ElementType.moveTo:
                        textToWrite += "\t\t\t\"\(point.x) \(point.y) m\",\n"
                    case NSBezierPath.ElementType.lineTo:
                        textToWrite += "\t\t\t\"\(point.x) \(point.y) l\",\n"
                    case NSBezierPath.ElementType.closePath:
                        textToWrite += "\t\t\t\"\(point.x) \(point.y) s H\",\n"
                    case NSBezierPath.ElementType.curveTo:
                        break
                    @unknown default:
                        break
                    }
                }
                textToWrite += "\t\t}\n"
                
                //materialThickness
                textToWrite += "\t\t\"materialThickness\": \(model.walls[wall].materialThickness),\n"
                
                //position, stored as an array
                textToWrite += "\t\t\"position\": [\(model.walls[wall].position.x), \(model.walls[wall].position.y), \(model.walls[wall].position.z)],\n"
                
                //width
                textToWrite += "\t\t\"width\": \(model.walls[wall].width),\n"
                
                //length
                textToWrite += "\t\t\"length\": \(model.walls[wall].length),\n"
                
                //wallType
                textToWrite += "\t\t\"wallType\": \"\(model.walls[wall].wallType)\",\n"
                
                //joinType
                textToWrite += "\t\t\"joinType\": \"\(model.walls[wall].joinType)\",\n"
                
                //tabWidth, which may be nil (null for JSON)
                if let tabWidth = model.walls[wall].tabWidth {
                    textToWrite += "\t\t\"tabWidth\": \(tabWidth)\n"
                } else {
                    textToWrite += "\t\t\"tabWidth\": null\n"
                }
                
                //end the object on same indentation
                textToWrite += "\t}\n"
            }
            
            //boxWidth
            textToWrite += "\t\"boxWidth\": \(model.boxWidth),\n"
            
            //boxLength
            textToWrite += "\t\"boxLength\": \(model.boxLength),\n"
            
            //boxHeight
            textToWrite += "\t\"boxHeight\": \(model.boxHeight),\n"
            
            //materialThickness
            textToWrite += "\t\"materialThickness\": \(model.materialThickness),\n"
            
            //innerDimensions as true or false
            textToWrite += "\t\"innerDimensions\": \"\(model.innerDimensions)\",\n"
            
            //joinType
            textToWrite += "\t\"joinType\": \"\(model.joinType)\",\n"
            
            //tabWidth, which may be null
            if let tabWidth = model.tabWidth {
                textToWrite += "\t\"tabWidth\": \(tabWidth),\n"
            } else {
                textToWrite += "\t\"tabWidth\": null,\n"
            }
            
            //lidOn as true or false
            textToWrite += "\t\"lidOn\": \"\(model.lidOn)\",\n"
            
            //has InnerWall as true or false
            textToWrite += "\t\"hasInnerWall\": \"\(model.hasInnerWall)\"\n"
            
            //end the boxModel object on same indentation
            textToWrite += "}"
            
            try textToWrite.write(to: targetURL, atomically: false, encoding: String.Encoding.utf8)
            
        } catch {
            print("could not save as JSON file")
        }
    }
    
    func convertJSONToBoxModel(_ targetURL: URL) throws -> BoxModel {
        
        var textToRead = String()
        
        let boxModel = BoxModel()
        
        do {
            textToRead =  try String(contentsOf: targetURL, encoding: String.Encoding.utf8)
        } catch {
            print("could not read model to be opened.")
        }
        
        var walls: [WallModel]
        
        while (!textToRead.isEmpty) {
            
            //get the current line
            guard let index = textToRead.firstIndex(of: "\n") else {
                print("missing newline")
                break
            }
            var newLine = textToRead.prefix(upTo: index)
            textToRead = String(textToRead.suffix(from: index))
            
            //sort through the info being read
            if newLine.starts(with: "\t\"wall") {
                
                guard let index = textToRead.firstIndex(of: "\n") else {
                    print("missing newline")
                    break
                }
                newLine = textToRead.prefix(upTo: index)
                
                if newLine.starts(with: "\t\t\"path\": {") {
                    //parse the path
                }
                
                if newLine.starts(with: "\t\t\"materialThickness\":") {
                    //get the material thickness
                }
                
                if newLine.starts(with: "\t\t\"position\":") {
                    //get the position
                    
                }
                
                if newLine.starts(with: "\t\t\"width\":") {
                    //get the width
                }
                
                if newLine.starts(with: "\t\t\"length\":") {
                    //get the length
                }
                
                if newLine.starts(with: "\t\t\"wallType\":") {
                    //get the wallType
                }
                
                if newLine.starts(with: "\t\t\"joinType\":") {
                    //get the joinType
                }
                
                if newLine.starts(with: "\t\t\"tabWidth\":") {
                    //get the tabWidth
                    //may be null
                }
            }
            
            //use all the above information to create a new wall
            //then add it to the array of walls
            
            //boxwidth
            
            //boxlength
        }
    
        
        
        
        
        
        return boxModel
    }
    
}
