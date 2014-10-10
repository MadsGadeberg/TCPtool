//
//  ViewController.swift
//  TCP Tool
//
//  Created by Mads Gadeberg Jensen on 20/08/14.
//  Copyright (c) 2014 Mads Gadeberg Jensen. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController, NSTextFieldDelegate {
    // Variables
    var appDelegate: AppDelegate?

    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ClientIpTextField.stringValue = "192.168.1.1"
        ClientPortTextField.stringValue = "8888"
        appDelegate = NSApplication.sharedApplication().delegate as? AppDelegate    // returns nil
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Client
    // ----------------------------------------------------------------------------------
    @IBOutlet weak var ClientIpTextField: NSTextField!
    @IBOutlet weak var ClientPortTextField: NSTextField!
    @IBOutlet weak var ConnectionStatusLabel: NSTextField!
    @IBOutlet weak var ClientMessageTextField: NSTextField!
    @IBOutlet weak var MessageTypeSelection: NSMatrix!
    
    @IBAction func ClientConnectBtn(sender: AnyObject) {
        appDelegate?.tcpService.initOutputStream(ClientIpTextField.stringValue, Port: ClientPortTextField.stringValue.toInt()!)
        
        while appDelegate?.tcpService.Status() == NSStreamStatus.Opening{ }
        
        if  appDelegate?.tcpService.Status() == NSStreamStatus.Open{
            ConnectionStatusLabel.stringValue = "Connected!"
        } else {
            ConnectionStatusLabel.stringValue = "Not Connected!"
        }
    }
    
    @IBAction func ClientSendBtn(sender: AnyObject) {
        if appDelegate?.tcpService.Status() == NSStreamStatus.Open {
            ConnectionStatusLabel.stringValue = "\(appDelegate?.tcpService.SendMsg(ClientMessageTextField.stringValue)) bytes sent"
        } else{
            ConnectionStatusLabel.stringValue = "Not Connected!"
        }
    }

    override func controlTextDidChange(obj: NSNotification!) {
        if (!(validateMessage(ClientMessageTextField.stringValue) > 0)) {
            
        }
    }

    // Validates the message
    func validateMessage(let str: String) -> Int {
        if (MessageTypeSelection.selectCellWithTag(1).boolValue){
            return validateHex(ClientMessageTextField.stringValue)
        } else if (MessageTypeSelection.selectCellWithTag(2).boolValue) {
            return validateBinary(ClientMessageTextField.stringValue)
        } else {
            return validateText(ClientMessageTextField.stringValue)
        }
    }
    
    // if "str" ia a valid string it returns the nr of bytes it contains
    func validateText(let str: String) -> Int{
        return countElements(str)
    }
    
    // if "str" ia a valid Hex value it returns its size in bytes
    func validateHex(let str: String) -> Int {
        // validate hex
        
        
        return 0
    }
    
    // if "str" ia a valid binary value it returns its size in bytes
    func validateBinary(let str: String) -> Int {
        return 0
    }
    
    
    // Server - Not implemented yet
    // ----------------------------------------------------------------------------------
    @IBOutlet weak var ServerPortTextField: NSTextField!
    @IBOutlet weak var ServerStatusLabel: NSTextField!
    @IBAction func ServerListenBtn(sender: AnyObject) {
        //let IPAdresses: [String] = appDelegate?.tcpService.getIFAddresses()
        //let address = IPAdresses.count == 0 ? "localhost" : IPAdresses[0]
        //ServerStatusLabel.stringValue = address
    }
}
