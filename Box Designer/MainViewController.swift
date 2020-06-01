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
    
    //Charles Gougenheim
    func createBox(length: Double, width: Double, height: Double) -> [SCNShape] {
        // create bezier path
        var boxWalls = [SCNShape]()
        let path1 = NSBezierPath()
        path1.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
        path1.line(to: CGPoint(x: 0.0, y: height)) // point B
        path1.line(to: CGPoint(x: length, y: height)) // point C
        path1.line(to: CGPoint(x: length, y: 0.0)) // point D
        path1.close()
        
        let path2 = NSBezierPath()
        path2.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
        path2.line(to: CGPoint(x: 0.0, y: height)) // point B
        path2.line(to: CGPoint(x: length, y: height)) // point C
        path2.line(to: CGPoint(x: length, y: 0.0)) // point D
        path2.close()
        
        let path3 = NSBezierPath()
        path3.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
        path3.line(to: CGPoint(x: 0.0, y: height)) // point B
        path3.line(to: CGPoint(x: length, y: height)) // point C
        path3.line(to: CGPoint(x: length, y: 0.0)) // point D
        path3.close()

        // create a geometry : SCNShape
        let shape1 = SCNShape(path: path1, extrusionDepth: 0.2)
        let shape2 = SCNShape(path: path2, extrusionDepth: 0.2)
        let shape3 = SCNShape(path: path3, extrusionDepth: 0.2)
//        let shape4 = SCNShape(path: path4, extrusionDepth: 0.2)
//        let shape5 = SCNShape(path: path5, extrusionDepth: 0.2)
        let color1 = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        let color2 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let color3 = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        shape1.firstMaterial?.diffuse.contents = color1
        shape2.firstMaterial?.diffuse.contents = color2
        shape3.firstMaterial?.diffuse.contents = color3
     
        boxWalls.append(shape1)
        boxWalls.append(shape2)
        boxWalls.append(shape3)
//        boxWalls.append(shape4)
//        boxWalls.append(shape5)

        
        
        //boxWalls.append(shape)
        return boxWalls
        
        // create a node
        //let boxNode = SCNNode(geometry: shape)
        
        // position node and add to the scene
        //boxNode.position.z = -1
        
        //sceneView.scene.rootNode.addChildNode(boxNode)
        
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
        
        //let boxNode = SCNNode(geometry: boxShape)
        let boxNode1 = SCNNode(geometry: boxShape[0])
        let boxNode2 = SCNNode(geometry: boxShape[1])
        let boxNode3 = SCNNode(geometry: boxShape[2])

        boxNode1.position = SCNVector3Make(0, 0, 0)
        boxNode2.rotation = SCNVector4(0, 1, 0, -1 * CGFloat.pi/2)
        boxNode3.position = SCNVector3Make(0, 0, 1)

        scene.rootNode.addChildNode(boxNode1)
        scene.rootNode.addChildNode(boxNode2)
        scene.rootNode.addChildNode(boxNode3)
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
    
