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

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    

}

