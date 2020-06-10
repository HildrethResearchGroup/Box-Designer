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
                textToWrite += "\t\tpath will go here. figure that out,\n"
                
                //materialThickness
                textToWrite += "\t\t\"materialThickness\": \(model.walls[wall].materialThickness),\n"
                
                //position, stored as an array
                textToWrite += "\t\t\"position\": [\(model.walls[wall].position.x), \(model.walls[wall].position.y), \(model.walls[wall].position.z)],\n"
                
                //width
                textToWrite += "\t\t\"width\": \(model.walls[wall].width),\n"
                
                //length
                textToWrite += "\t\t\"length\": \(model.walls[wall].length),\n"
                
                //wallType
                textToWrite += "\t\t\"wallType\": \(model.walls[wall].wallType),\n"
                
                //joinType
                textToWrite += "\t\t\"joinType\": \(model.walls[wall].joinType),\n"
                
                //tabWidth, which may be nil (null for JSON)
                if let tabWidth = model.walls[wall].tabWidth {
                    textToWrite += "\t\t\"tabWidth\": \(tabWidth)"
                } else {
                    textToWrite += "\t\t\"tabWidth\": null"
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
            textToWrite += "\t\"innerDimensions\": \(model.innerDimensions)"
            
            //joinType
            textToWrite += "\t\"joinType\": \(model.joinType),\n"
            
            //tabWidth, which may be null
            if let tabWidth = model.tabWidth {
                textToWrite += "\t\"tabWidth\": \(tabWidth)"
            } else {
                textToWrite += "\t\"tabWidth\": null,\n"
            }
            
            //lidOn as true or false
            textToWrite += "\t\"lidOn\": \(model.lidOn),\n"
            
            //has InnerWall as true or false
            textToWrite += "\t\"hasInnerWall\": \(model.hasInnerWall)"
            
            //end the boxModel object on same indentation
            textToWrite += "}"
            
            try textToWrite.write(to: targetURL, atomically: false, encoding: String.Encoding.utf8)
            
        } catch {
            print("could not save as JSON file")
        }
    }
    
    func convertJSONToBoxModel(_ targetURL: URL) -> BoxModel {
        let boxModel = BoxModel()
        
        return boxModel
    }
    
}
