//
//  MainViewController.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit
import AppKit



class MainViewController: NSViewController {
    
    @IBOutlet weak var boxView: SCNView!
        
   // MARK: Lifecycle
    
    override func awakeFromNib(){
        sceneSetup()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    func getRandomColor() -> NSColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return NSColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    //Charles Gougenheim
    func createBox(length: Double, width: Double, height: Double) -> [SCNShape] {
        // create bezier path
        
        var boxWalls = [SCNShape]()
        
        for _ in [1,2,3,4,5]{
            let path = NSBezierPath()
            path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
            path.line(to: CGPoint(x: 0.0, y: height)) // point B
            path.line(to: CGPoint(x: length, y: height)) // point C
            path.line(to: CGPoint(x: length, y: 0.0)) // point D
            
            let shape = SCNShape(path: path, extrusionDepth: 0.2)
            
            let color = getRandomColor()
            
            shape.firstMaterial?.diffuse.contents = color
            
            boxWalls.append(shape)
        }
        
        return boxWalls
        
    }
    
    // MARK: Scene
    func sceneSetup() {
        //var boxShape = [SCNShape]()
        let scene = SCNScene()
        /*let boxGeometry = SCNBox(width:4.0, height: 4.0, length: 4.0, chamferRadius: 0.01)
        let boxNode = SCNNode(geometry: boxGeometry)*/
        
        var length = 1.0
        var width = 1.0
        var height = 1.0
        
        let boxShape = createBox(length: length, width: width, height: height)
        
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
        
        //let boxNode = SCNNode(geometry: boxShape)
        let boxNode1 = SCNNode(geometry: boxShape[0])
        let boxNode2 = SCNNode(geometry: boxShape[1])
        let boxNode3 = SCNNode(geometry: boxShape[2])
        let boxNode4 = SCNNode(geometry: boxShape[3])
        let boxNode5 = SCNNode(geometry: boxShape[4])

        boxNode1.position = SCNVector3Make(0, 0, 0)
        boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
        boxNode3.position = SCNVector3Make(0, 0, 1)
        boxNode4.position = SCNVector3(1, 0, 0)
        boxNode4.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
        boxNode5.rotation = SCNVector4(1, 0, 0, CGFloat.pi/2)

        scene.rootNode.addChildNode(boxNode1)
        scene.rootNode.addChildNode(boxNode2)
        scene.rootNode.addChildNode(boxNode3)
        scene.rootNode.addChildNode(boxNode4)
        scene.rootNode.addChildNode(boxNode5)
        boxView.scene = scene
        lightingSetup(scene)
    }
 
    func lightingSetup(_ scene:SCNScene) {
         boxView.allowsCameraControl = true
    
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
    
    // MARK: File Handling
    @IBAction func openScene(_ sender: Any) {
        guard let window = boxView.window else { return }
        guard var scene = self.boxView.scene else {return}
        let panel = NSOpenPanel()
        
        panel.allowedFileTypes = ["scn"]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        panel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                do {
                    try scene = SCNScene.init(url: panel.urls[0])
                    self.lightingSetup(scene)
                }
                catch {
                    print("Could not open selected file.")
                }
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        print("save function entered")
        
        guard let window = boxView.window else {return}
        print("window successfully gotten")
        let savePanel = NSSavePanel()
        
        savePanel.allowedFileTypes = ["scn", "pdf"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        
        savePanel.beginSheetModal(for: window) { (response) in
            if response == NSApplication.ModalResponse.OK {
                guard let targetURL = savePanel.url else { return }
                guard let targetFileType = savePanel.url?.pathExtension else {return}
                
                switch targetFileType {
                case "scn":
                    self.boxView.scene?.write(to: targetURL, delegate: nil)
                case "pdf":
                    do {
                        let pdfFileSaver = PDFFileSaver()
                        //pdfFileSaver.parseScene(boxView.scene)
                        try pdfFileSaver.saveAsPDF(to: targetURL, sceneToSave: self.boxView?.scene)
                    } catch {
                        print("Could not open PDFSaver. Scene may be missing.")
                    }
                default:
                    print("Cannot save as that file type.")
                    //TODO: convert to popup/panel style notification
                }
                self.boxView.scene?.write(to: targetURL, delegate: nil)
            }
        }
    }
}
    
