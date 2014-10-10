//
//  AppDelegate.swift
//  TCP Tool
//
//  Created by Mads Gadeberg Jensen on 20/08/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var tcpService = TcpService()
    
    @IBOutlet var statusMenu: NSMenu?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        let bar = NSStatusBar.systemStatusBar()
//        let sm = bar.statusItemWithLength( CGFloat(NSVariableStatusItemLength) )
        
        statusItem = bar.statusItemWithLength(-1)
        statusItem!.title = "TCPLogo"
        statusItem!.menu = statusMenu
        statusItem!.highlightMode = true
        NSOperationQueue().addOperationWithBlock({ self.updateLogo() })
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    func updateLogo(){
        statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteGray", ofType: "png"))
        while (tcpService.Status() == NSStreamStatus.Opening){}
        
        if (tcpService.Status() == NSStreamStatus.Open){
            statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteOnline", ofType: "png"))
        } else {
            statusItem!.image = NSImage(byReferencingFile: NSBundle.mainBundle().pathForResource("RaspRemoteOffline", ofType: "png"))
        }
    }
}

