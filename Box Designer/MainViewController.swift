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
    func createBox() {
        // create bezier path
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0)) // point A
        path.line(to: CGPoint(x: 0.0, y: 0.5)) // point B
        path.line(to: CGPoint(x: 0.5, y: 0.5)) // point C
        path.line(to: CGPoint(x: 0.5, y: 0.0)) // point D
        path.close()
        
        // create a geometry : SCNShape
        let shape = SCNShape(path: path, extrusionDepth: 0.2)
        let color = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        shape.firstMaterial?.diffuse.contents = color
        
    }
    
    
    
    
    
    // MARK: Scene
    func sceneSetup() {
        let scene = SCNScene()
        let boxGeometry = SCNBox(width:4.0, height: 4.0, length: 4.0, chamferRadius: 0.01)
        let boxNode = SCNNode(geometry: boxGeometry)
        scene.rootNode.addChildNode(boxNode)
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
    
