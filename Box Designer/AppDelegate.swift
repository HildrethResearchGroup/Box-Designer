//
//  AppDelegate.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Cocoa

/**
 AppDelegate for BoxDesigner application -- initializes application views.
 - Authors:
    - CSM Field Session Summer 2020 and Fall 2020.
 
 - Copyright:
    - Copyright © 2020 Hildreth Research Group. All rights reserved.
 - Note:
    - Both functions in this class (applicationDidFinishLaunching and applicationWillTerminate) are accompanied by the Apple Developer Documentation in Quick Help.
 */
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var boxViewController: BoxViewController!
    @IBOutlet weak var inputViewController: InputViewController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.window.minSize = self.window.frame.size
        self.window.acceptsMouseMovedEvents = true
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

