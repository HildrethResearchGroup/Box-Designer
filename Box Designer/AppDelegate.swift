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
    - Both functions in this class (applicationDidFinishLaunching and applicationWillTerminate) are accompanied by the Apple Developer Documentation in Quick Help and links to their documentation are provided.
    
 */
/// - Tag: AppDelegate
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// This is the viewing window for the application.
    @IBOutlet weak var window: NSWindow!
    /// This is the View Controller for the macOS menu bar.
    @IBOutlet weak var boxViewController: BoxViewController!
    /// This is the View Controller for the main app interface.
    @IBOutlet weak var inputViewController: InputViewController!
    
    /**
     
    - Note:
        - The only start-up customization this app uses is to set a minimum window size.
    - See [Apple Documentation - applicationDidFinishLaunching.] (https://developer.apple.com/documentation/appkit/nsapplicationdelegate/1428385-applicationdidfinishlaunching?language=objc/)
     
     */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.window.minSize = self.window.frame.size
    }
    /**
            
     - Note:
        - If user settings need to be saved at the end of a session, for the next session, this is where you would do that.
    - See [Apple Documentation - applicationWillTerminate.] (https://developer.apple.com/documentation/appkit/nsapplicationdelegate/1428522-applicationwillterminate?language=objc/)
     
     */
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

