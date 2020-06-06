//
//  BoxSceneMaker.swift
//  Box Designer
//
//  Created by Justin Clark on 6/4/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit

enum EdgeType: String {
    case finger = "finger"
    case overlapping = "overlapping"
}

class BoxSceneMaker {
    
    var scene = SCNScene() {
        didSet {
            if oldValue != scene {
                delegate?.sceneDidChange()
            }
        }
    }
    
    var delegate: BoxSceneMakerDelegate? = nil
    
    func getRandomColor() -> NSColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return NSColor(red:red, green: green, blue: blue, alpha: 1.0)
    }

    func generateWallPath(cornerType tabStyle:TabStyle, joinType edgeType:EdgeType, _ height: Double, _ width: Double, _ length: Double) -> NSBezierPath {
        switch(tabStyle) {
        case TabStyle.smallCorner:
            return generateSmallCornerPath(joinType: edgeType, 1, 1, 1)
        case TabStyle.largeCorner:
            return generateLargeCornerPath(joinType: edgeType, 1, 1, 1)
        case TabStyle.longCorner:
            return generateLongCornerPath(joinType: edgeType, 1, 1, 1)
        }
    }
    
    func generateSmallCornerPath(joinType edgeType: EdgeType, _ height: Double, _ width: Double, _ length: Double) -> NSBezierPath {
        switch(edgeType) {
        case EdgeType.finger:
            var path = NSBezierPath()
            var extrusionDepth = 0.05
            path.move(to: CGPoint(x: 0.00, y: extrusionDepth)) // point
            path.line(to: CGPoint(x: 0.00, y: height/5)) // point A to first corner in tab
            path.line(to: CGPoint(x: -0.05, y: height/5)) // First corner in tab to second corner
            path.line(to: CGPoint(x: -0.05, y: (height/5) * 2)) // Second corner to third corner
            path.line(to: CGPoint(x: 0.00, y: (height/5) * 2)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.00, y: (height/5) * 3)) // point A to first corner in tab
                path.line(to: CGPoint(x: -0.05, y: (height/5) * 3)) // First corner in tab to second corner
                path.line(to: CGPoint(x: -0.05, y: (height/5) * 4)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.00, y: (height/5) * 4)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.00, y: height-extrusionDepth)) // point B
            
                path.line(to: CGPoint(x: (length/5), y: height-extrusionDepth)) // point C
                path.line(to: CGPoint(x: (length/5), y: height+0.05-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y: height+0.05-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y:height-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y: height-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y: height + 0.05-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 4, y:height+0.05-extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 4, y: height-extrusionDepth)) // point C to first corner in tab
                
                path.line(to: CGPoint(x: length, y: height-extrusionDepth)) // point C
                path.line(to: CGPoint(x: length, y: (height/5) * 4)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 4)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 3)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 3)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 2)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 2)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 1)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 1)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: extrusionDepth)) // point C to first corner in tab
                    
                path.line(to: CGPoint(x: (length/5) * 4, y: extrusionDepth)) // point C
                path.line(to: CGPoint(x: (length/5) * 4, y: -0.05+extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y: -0.05+extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y: extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y: extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y: -0.05+extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5), y: -0.05+extrusionDepth)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5), y: extrusionDepth)) // point C to first corner in tab
            return path
        case EdgeType.overlapping:
            //TODO: Check that this is the correct wall here
            var path = NSBezierPath()
            var extrusionDepth = 0.05
            path.move(to: CGPoint(x: 0, y: extrusionDepth)) // point A
            path.line(to: CGPoint(x: 0, y: height)) // point B
            path.line(to: CGPoint(x: length, y: height)) // point C
            path.line(to: CGPoint(x: length, y: extrusionDepth)) // point D
            return path
        }
    }
    
    func makeSmallCornerWall(position point: Point) -> SCNNode {
        var extrusionDepth: CGFloat = 0.05
        var path = generateSmallCornerPath(joinType: EdgeType.finger, 1, 1, 1)
        var wall = SCNShape(path: path, extrusionDepth: extrusionDepth)
        wall.firstMaterial?.diffuse.contents = getRandomColor()
        var node = SCNNode(geometry: wall)
        node.position = SCNVector3(0 + point.x , Double(extrusionDepth)/2 + point.y ,-Double(extrusionDepth)/2 + point.z)
        node.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
        return node
    }
 
    func generateLargeCornerPath(joinType edgeType: EdgeType, _ width: Double, _ length: Double, _ height: Double) -> NSBezierPath {
        switch(edgeType) {
        case EdgeType.finger:
            var path = NSBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
            path.line(to: CGPoint(x: 0.0, y: height/5)) // point A to first corner in tab
            path.line(to: CGPoint(x: 0.05, y: height/5)) // First corner in tab to second corner
            path.line(to: CGPoint(x: 0.05, y: (height/5) * 2)) // Second corner to third corner
            path.line(to: CGPoint(x: 0.0, y: (height/5) * 2)) // Second corner to third corner
            path.line(to: CGPoint(x: 0.0, y: (height/5) * 3)) // point A to first corner in tab
            path.line(to: CGPoint(x: 0.05, y: (height/5) * 3)) // First corner in tab to second corner
            path.line(to: CGPoint(x: 0.05, y: (height/5) * 4)) // Second corner to third corner
            path.line(to: CGPoint(x: 0.0, y: (height/5) * 4)) // Second corner to third corner
            path.line(to: CGPoint(x: 0.0, y: height)) // point B
            
            path.line(to: CGPoint(x: width, y: height)) // point C
            path.line(to: CGPoint(x: width, y: (height/5) * 4)) // point C to first corner in tab
            path.line(to: CGPoint(x: width - 0.05, y: (height/5) * 4)) // point C to first corner in tab
            path.line(to: CGPoint(x: width - 0.05, y:(height/5) * 3)) // point C to first corner in tab
            path.line(to: CGPoint(x: width, y: (height/5) * 3)) // point C to first corner in tab
            path.line(to: CGPoint(x: width, y: (height/5) * 2)) // point C to first corner in tab
            path.line(to: CGPoint(x: width - 0.05, y: (height/5) * 2)) // point C to first corner in tab
            path.line(to: CGPoint(x: width - 0.05, y:(height/5) * 1)) // point C to first corner in tab
            path.line(to: CGPoint(x: width, y: (height/5) * 1)) // point C to first corner in tab
            path.line(to: CGPoint(x: width, y: 0)) // point C to first corner in tab
              
            path.line(to: CGPoint(x: (length/5) * 4, y: 0.00)) // point C
            path.line(to: CGPoint(x: (length/5) * 4, y: 0.05)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5) * 3, y: 0.05)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5) * 3, y:0.00)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5) * 2, y: 0.00)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5) * 2, y: 0.05)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5), y: 0.05)) // point C to first corner in tab
            path.line(to: CGPoint(x: (length/5), y: 0.0)) // point C to first corner in tab
            return path
        case EdgeType.overlapping:
            
            //TODO: check that this is the correct wall
            var path = NSBezierPath()
            var extrusionDepth = 0.05
            path.move(to: CGPoint(x: extrusionDepth, y: extrusionDepth)) // point A
            path.line(to: CGPoint(x: extrusionDepth, y: height)) // point B
            path.line(to: CGPoint(x: width-extrusionDepth, y: height)) // point C
            path.line(to: CGPoint(x: width-extrusionDepth, y: extrusionDepth)) // point D
            return path
        }
    }
    
    func makeLargeCornerWall(position point: Point) -> SCNNode {
        var extrusionDepth: CGFloat = 0.05
        var path = generateLargeCornerPath(joinType: EdgeType.finger, 1, 1, 1)
        var wall = SCNShape(path: path, extrusionDepth: extrusionDepth)
        wall.firstMaterial?.diffuse.contents = getRandomColor()
        var node = SCNNode(geometry: wall)
        node.position = SCNVector3Make(CGFloat(-Double(extrusionDepth)/2 + point.x), CGFloat(0 + point.y), CGFloat(-Double(extrusionDepth)/2 + point.z))
        node.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
        return node
    }
    
    func generateLongCornerPath(joinType edgeType: EdgeType, _ width:Double, _ length: Double, _ height: Double) -> NSBezierPath {
        switch(edgeType) {
        case EdgeType.finger:
            var path = NSBezierPath()
            var extrustionDepth: CGFloat = 0.05
              path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
                path.line(to: CGPoint(x: 0.0, y: height/5)) // point A to first corner in tab
                path.line(to: CGPoint(x: -0.05, y: height/5)) // First corner in tab to second corner
                path.line(to: CGPoint(x: -0.05, y: (height/5) * 2)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.0, y: (height/5) * 2)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.0, y: (height/5) * 3)) // point A to first corner in tab
                path.line(to: CGPoint(x: -0.05, y: (height/5) * 3)) // First corner in tab to second corner
                path.line(to: CGPoint(x: -0.05, y: (height/5) * 4)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.0, y: (height/5) * 4)) // Second corner to third corner
                path.line(to: CGPoint(x: 0.0, y: height)) // point B
            
                path.line(to: CGPoint(x: length, y: height)) // point C
                path.line(to: CGPoint(x: length, y: (height/5) * 4)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 4)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 3)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 3)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 2)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 2)) // point C to first corner in tab
                path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 1)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: (height/5) * 1)) // point C to first corner in tab
                path.line(to: CGPoint(x: length, y: 0)) // point C to first corner in tab
                
                path.line(to: CGPoint(x: (length/5) * 4, y: 0)) // point C
                path.line(to: CGPoint(x: (length/5) * 4, y: 0.05)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y: 0.05)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 3, y:0.00)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y: 0.00)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5) * 2, y: 0.05)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5), y: 0.05)) // point C to first corner in tab
                path.line(to: CGPoint(x: (length/5), y: 0.0)) // point C to first corner in tab
            return path
        case EdgeType.overlapping:
            //TODO: Check that this is the corrct wall
            var path = NSBezierPath()
            var extrusionDepth = 0.05
            path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
            path.line(to: CGPoint(x: 0.0, y: width)) // point B
            path.line(to: CGPoint(x: length, y: width)) // point C
            path.line(to: CGPoint(x: length, y: 0.0)) // point D
            return path
        }
    }
    
    func makeLongCornerWall(position point: Point) -> SCNNode {
        var extrusionDepth: CGFloat = 0.05
        var path = generateLongCornerPath(joinType: EdgeType.finger, 1, 1, 1)
        var wall = SCNShape(path: path, extrusionDepth: extrusionDepth)
        wall.firstMaterial?.diffuse.contents = getRandomColor()
        var node = SCNNode(geometry: wall)
        node.position = SCNVector3Make(CGFloat(point.x + 0), CGFloat(point.y + 0), CGFloat(point.z + 0))
        print("x \(point.x), y \(point.y), z \(point.z)")
        return node
    }
    
    func sceneSetup() {
        var nodeBottom = makeSmallCornerWall(position: (0,0,0))
        scene.rootNode.addChildNode(nodeBottom)
        var nodeSide = makeLargeCornerWall(position: (0,0,0))
        scene.rootNode.addChildNode(nodeSide)
        var nodeOtherSide = makeLongCornerWall(position: (0,0,0))
        scene.rootNode.addChildNode(nodeOtherSide)
        var nodeOtherSide2 = makeLongCornerWall(position: (0,0,0.95))
        scene.rootNode.addChildNode(nodeOtherSide2)
        var nodeSide2 = makeLargeCornerWall(position: (1.05,0,0))
        scene.rootNode.addChildNode(nodeSide2)
        
        
        lightingSetup(scene)
    }
    
    func addWall() {
        print("adding wall")
        var newNode = makeLongCornerWall(position: (0, 0, 0.50))
        scene.rootNode.addChildNode(newNode)
        delegate?.sceneDidChange()
    }

    
    
    /*
    func sceneSetup() {
        //var boxShape = [SCNShape]()
        var extrusionDepth:CGFloat = 0.05
        let scene = SCNScene()
        /*let boxGeometry = SCNBox(width:4.0, height: 4.0, length: 4.0, chamferRadius: 0.01)
        let boxNode = SCNNode(geometry: boxGeometry)*/

        var length:CGFloat = 1.0
        var width:CGFloat = 1.0
        var height:CGFloat = 1.0
        let input = edgeType
        
        var boxShape = [SCNShape()]
        
        if input == EdgeType.finger {
            boxShape = createBoxFingers(length: Double(length), width: Double(width), height: Double(height))
        } else {
            boxShape = createBox(length: Double(length), width: Double(width), height: Double(height))
        }
        
        print("Are you using finger or overlapping joints?")

        let boxNode1 = SCNNode(geometry: boxShape[0])
        let boxNode3 = SCNNode(geometry: boxShape[1])
        let boxNode2 = SCNNode(geometry: boxShape[2])
        let boxNode4 = SCNNode(geometry: boxShape[3])
        let boxNode5 = SCNNode(geometry: boxShape[4])
        
        if(input == EdgeType.overlapping) {
        //let boxNode = SCNNode(geometry: boxShape)
        

            boxNode1.position = SCNVector3Make(0, 0, 0)
            boxNode2.position = SCNVector3Make(extrusionDepth/2,0,-1*extrusionDepth/2)
            boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
            boxNode3.position = SCNVector3Make(0, 0, width - extrusionDepth)
            boxNode4.position = SCNVector3Make(length-extrusionDepth/2, 0, -1*extrusionDepth/2)
            boxNode4.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
            boxNode5.position = SCNVector3(0,extrusionDepth/2,-extrusionDepth/2)
            boxNode5.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
            
        }
        
        else {
            boxNode1.position = SCNVector3Make(0, 0, 0)
            boxNode2.position = SCNVector3Make(-extrusionDepth/2,0,-extrusionDepth/2)
            boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
            boxNode3.position = SCNVector3Make(0, 0, width-extrusionDepth)
            boxNode4.position = SCNVector3Make(length+extrusionDepth/2, 0, -1*extrusionDepth/2)
            boxNode4.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
            boxNode5.position = SCNVector3(0,extrusionDepth/2,-extrusionDepth/2)
            boxNode5.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
        }

        scene.rootNode.addChildNode(boxNode1)
        scene.rootNode.addChildNode(boxNode2)
        scene.rootNode.addChildNode(boxNode3)
        scene.rootNode.addChildNode(boxNode4)
        scene.rootNode.addChildNode(boxNode5)
        boxView.scene = scene
        lightingSetup(scene)
    }
     
    */
    
    
    
    func createBoxFingers(length: Double, width: Double, height: Double) -> [SCNShape] {
        // create bezier path
            
        var boxWalls = [SCNShape]()
            
        var extrusionDepth:Double = 0.05
        var extrusionDepth1:CGFloat = 0.05
 
        for numbers in [1,2,3,4,5]{
            let path = NSBezierPath()
            switch(numbers){
                case 1,2:
                    path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
                    path.line(to: CGPoint(x: 0.0, y: height/5)) // point A to first corner in tab
                    path.line(to: CGPoint(x: -0.05, y: height/5)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 3)) // point A to first corner in tab
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 3)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: height)) // point B
                
                    path.line(to: CGPoint(x: length, y: height)) // point C
                    path.line(to: CGPoint(x: length, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: 0)) // point C to first corner in tab
                    
                    path.line(to: CGPoint(x: (length/5) * 4, y: 0)) // point C
                    path.line(to: CGPoint(x: (length/5) * 4, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y:0.00)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: 0.00)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: 0.0)) // point C to first corner in tab

                case 3,4:
                    path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
                    path.line(to: CGPoint(x: 0.0, y: height/5)) // point A to first corner in tab
                    path.line(to: CGPoint(x: 0.05, y: height/5)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: 0.05, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 3)) // point A to first corner in tab
                    path.line(to: CGPoint(x: 0.05, y: (height/5) * 3)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: 0.05, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.0, y: height)) // point B
                    
                    path.line(to: CGPoint(x: width, y: height)) // point C
                    path.line(to: CGPoint(x: width, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width - 0.05, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width - 0.05, y:(height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width, y: (height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width - 0.05, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width - 0.05, y:(height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width, y: (height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: width, y: 0)) // point C to first corner in tab
                    
                    path.line(to: CGPoint(x: (length/5) * 4, y: 0)) // point C
                    path.line(to: CGPoint(x: (length/5) * 4, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y:0.00)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: 0.00)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: 0.05)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: 0.0)) // point C to first corner in tab

                case 5:
                    path.move(to: CGPoint(x: 0.00, y: extrusionDepth)) // point A
                    path.line(to: CGPoint(x: 0.00, y: height/5)) // point A to first corner in tab
                    path.line(to: CGPoint(x: -0.05, y: height/5)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.00, y: (height/5) * 2)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.00, y: (height/5) * 3)) // point A to first corner in tab
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 3)) // First corner in tab to second corner
                    path.line(to: CGPoint(x: -0.05, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.00, y: (height/5) * 4)) // Second corner to third corner
                    path.line(to: CGPoint(x: 0.00, y: height-extrusionDepth)) // point B
                
                    path.line(to: CGPoint(x: (length/5), y: height-extrusionDepth)) // point C
                    path.line(to: CGPoint(x: (length/5), y: height+0.05-extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: height+0.05-extrusionDepth)) // point C to first corner in tab
                        path.line(to: CGPoint(x: (length/5) * 2, y:height-extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: height-extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: height + 0.05-extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 4, y:height+0.05-extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 4, y: height-extrusionDepth)) // point C to first corner in tab
                    
                    path.line(to: CGPoint(x: length, y: height-extrusionDepth)) // point C
                    path.line(to: CGPoint(x: length, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 4)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 3)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y: (height/5) * 2)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length + 0.05, y:(height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: (height/5) * 1)) // point C to first corner in tab
                    path.line(to: CGPoint(x: length, y: extrusionDepth)) // point C to first corner in tab
                        
                    path.line(to: CGPoint(x: (length/5) * 4, y: extrusionDepth)) // point C
                    path.line(to: CGPoint(x: (length/5) * 4, y: -0.05+extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: -0.05+extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 3, y: extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5) * 2, y: -0.05+extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: -0.05+extrusionDepth)) // point C to first corner in tab
                    path.line(to: CGPoint(x: (length/5), y: extrusionDepth)) // point C to first corner in tab
                default :
                    print( "createBox switch statement defaulted")
            }
                
            let shape = SCNShape(path: path, extrusionDepth: extrusionDepth1)
                
            let color = getRandomColor()
                
            shape.firstMaterial?.diffuse.contents = color
                
            boxWalls.append(shape)
        }
            
        return boxWalls
            
    }
        

    func createBox(length: Double, width: Double, height: Double) -> [SCNShape] {
            // create bezier path

        var boxWalls = [SCNShape]()
            
        var extrusionDepth = 0.05
            
        var extrusionDepth1:CGFloat = 0.05
        for count in [1,2,3]{
            let path = NSBezierPath()
            switch count {
                case 1:
                    path.move(to: CGPoint(x: 0, y: extrusionDepth)) // point A
                    path.line(to: CGPoint(x: 0, y: height)) // point B
                    path.line(to: CGPoint(x: length, y: height)) // point C
                    path.line(to: CGPoint(x: length, y: extrusionDepth)) // point D
                case 2:
                    path.move(to: CGPoint(x: extrusionDepth, y: extrusionDepth)) // point A
                    path.line(to: CGPoint(x: extrusionDepth, y: height)) // point B
                    path.line(to: CGPoint(x: width-extrusionDepth, y: height)) // point C
                    path.line(to: CGPoint(x: width-extrusionDepth, y: extrusionDepth)) // point D
                case 3:
                    path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
                    path.line(to: CGPoint(x: 0.0, y: width)) // point B
                    path.line(to: CGPoint(x: length, y: width)) // point C
                    path.line(to: CGPoint(x: length, y: 0.0)) // point D
                default:
                    print("Oopsies")
            }
            
           
            
            let shape = SCNShape(path: path, extrusionDepth: extrusionDepth1)

            let color = getRandomColor()

            shape.firstMaterial?.diffuse.contents = color
            
            boxWalls.append(shape)
            boxWalls.append(shape)
        }

        return boxWalls

    }

    // MARK: Scene
    //func sceneSetup() {
        
        /*
        //var boxShape = [SCNShape]()
        var extrusionDepth:CGFloat = 0.05
        let scene = SCNScene()
        /*let boxGeometry = SCNBox(width:4.0, height: 4.0, length: 4.0, chamferRadius: 0.01)
        let boxNode = SCNNode(geometry: boxGeometry)*/

        var length:CGFloat = 1.0
        var width:CGFloat = 1.0
        var height:CGFloat = 1.0
        let input = edgeType
        
        var boxShape = [SCNShape()]
        
        if input == EdgeType.finger {
            boxShape = createBoxFingers(length: Double(length), width: Double(width), height: Double(height))
        } else {
            boxShape = createBox(length: Double(length), width: Double(width), height: Double(height))
        }
        
            

    //        var i:Int = 0
    //
    //        for box in boxShape {
    //            let boxNode = SCNNode(geometry: box)
    //
    //            switch i {
    //            case 0:
    //                boxNode.position = SCNVector3Make(0, 0, 0)
    //                break
    //            case 1:
    //                boxNode.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
    //                scene.rootNode.addChildNode(boxNode)
    //
    //                i = i + 1
    //                break
    //            case 2:
    //                boxNode.position = SCNVector3Make(0, 0, 1)
    //                scene.rootNode.addChildNode(boxNode)
    //
    //                i = i + 1
    //                break
    //            case 3:
    //                boxNode.position = SCNVector3(1, 0, 0)
    //                boxNode.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
    //                scene.rootNode.addChildNode(boxNode)
    //
    //                i = i + 1
    //                break
    //            case 4:
    //                boxNode.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
    //                scene.rootNode.addChildNode(boxNode)
    //
    //                i = i + 1
    //                break
    //            default:
    //                print("This wasn't supposed to happen")
    //                break
    //
    //
    //            }
    //        }
            
            print("Are you using finger or overlapping joints?")
            
            
    //        while input != "finger" && input != "Finger" && input != "Overlapping" && input != "overlapping" {
    //            print("Invalid input try again")
    //            let input = readLine(strippingNewline: true)!
    //        }
            
            let boxNode1 = SCNNode(geometry: boxShape[0])
            let boxNode3 = SCNNode(geometry: boxShape[1])
            let boxNode2 = SCNNode(geometry: boxShape[2])
            let boxNode4 = SCNNode(geometry: boxShape[3])
            let boxNode5 = SCNNode(geometry: boxShape[4])
            
            if(input == EdgeType.overlapping) {
            //let boxNode = SCNNode(geometry: boxShape)
            

                boxNode1.position = SCNVector3Make(0, 0, 0)
                boxNode2.position = SCNVector3Make(extrusionDepth/2,0,-1*extrusionDepth/2)
                boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
                boxNode3.position = SCNVector3Make(0, 0, width - extrusionDepth)
                boxNode4.position = SCNVector3Make(length-extrusionDepth/2, 0, -1*extrusionDepth/2)
                boxNode4.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
                boxNode5.position = SCNVector3(0,extrusionDepth/2,-extrusionDepth/2)
                boxNode5.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
                
            }
            
            else {
                boxNode1.position = SCNVector3Make(0, 0, 0)
                boxNode2.position = SCNVector3Make(-extrusionDepth/2,0,-extrusionDepth/2)
                boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
                boxNode3.position = SCNVector3Make(0, 0, width-extrusionDepth)
                boxNode4.position = SCNVector3Make(length+extrusionDepth/2, 0, -1*extrusionDepth/2)
                boxNode4.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
                boxNode5.position = SCNVector3(0,extrusionDepth/2,-extrusionDepth/2)
                boxNode5.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)
            }

            scene.rootNode.addChildNode(boxNode1)
            scene.rootNode.addChildNode(boxNode2)
            scene.rootNode.addChildNode(boxNode3)
            scene.rootNode.addChildNode(boxNode4)
            scene.rootNode.addChildNode(boxNode5)
            //boxView.scene = scene
            lightingSetup(scene)
 
 */
  //      }
     
        func lightingSetup(_ scene:SCNScene) {
             //boxView.allowsCameraControl = true
        
             let ambientLightNode = SCNNode()
             ambientLightNode.light = SCNLight()
             ambientLightNode.light!.type = SCNLight.LightType.ambient
             ambientLightNode.light!.color = NSColor(white: 0.67, alpha: 1.0)
             scene.rootNode.addChildNode(ambientLightNode)
        
             let omniLightNode = SCNNode()
             omniLightNode.light = SCNLight()
             omniLightNode.light!.type = SCNLight.LightType.omni
             omniLightNode.light!.color = NSColor(white: 0.75, alpha: 1.0)
             omniLightNode.position = SCNVector3Make(50, 50, 50)
             scene.rootNode.addChildNode(omniLightNode)
        }
    
    
    
}

protocol BoxSceneMakerDelegate {
    func sceneDidChange()
}
