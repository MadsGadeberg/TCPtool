//
//  AppDelegate.swift
//  TCP Tool
//
//  Created by Mads Gadeberg Jensen on 20/08/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var statusMenu: NSMenu?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        let bar = NSStatusBar.systemStatusBar()
//        let sm = bar.statusItemWithLength( CGFloat(NSVariableStatusItemLength) )
        
        statusItem = bar.statusItemWithLength(-1)
        statusItem!.title = "RaspRemote"
        statusItem!.menu = statusMenu
//        statusItem!.image = NSImage(named: "whatever")
        statusItem!.highlightMode = true
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
}

