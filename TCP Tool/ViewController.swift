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
    var tcpService: TcpService
    
    // Initialzers
    required init(coder aDecoder: NSCoder) {
        tcpService = TcpService();
        ClientIpTextField.stringValue = "192.168.1.1"
        ClientPortTextField.stringValue = "8888"
        
        super.init(coder: aDecoder)
    }
   
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Client Connections
    @IBOutlet weak var ClientIpTextField: NSTextField!
    @IBOutlet weak var ClientPortTextField: NSTextField!
    @IBOutlet weak var ConnectionStatusLabel: NSTextField!
    @IBOutlet weak var ClientMessageTextField: NSTextField!
    @IBOutlet weak var MessageTypeSelection: NSMatrix!
    
    @IBAction func ClientConnectBtn(sender: AnyObject) {
        tcpService.initOutputStream(ClientIpTextField.stringValue, Port: ClientPortTextField.stringValue.toInt()!)
        
        while tcpService.outputStream!.streamStatus == NSStreamStatus.Opening{ }
        
        if  tcpService.outputStream!.streamStatus == NSStreamStatus.Open{
            ConnectionStatusLabel.stringValue = "Connected!"
        } else {
            ConnectionStatusLabel.stringValue = "Not Connected!"
        }
    }
    
    @IBAction func ClientSendBtn(sender: AnyObject) {
        if tcpService.outputStream != nil && tcpService.outputStream!.streamStatus == NSStreamStatus.Open {
            ConnectionStatusLabel.stringValue = "\(self.tcpService.SendMsg(ClientMessageTextField.stringValue)) bytes sent"
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
    
    // Server Connections
    @IBOutlet weak var ServerPortTextField: NSTextField!
    @IBOutlet weak var ServerStatusLabel: NSTextField!
    @IBAction func ServerListenBtn(sender: AnyObject) {
        let IPAdresses: [String] = tcpService.getIFAddresses()
        let address = IPAdresses.count == 0 ? "localhost" : IPAdresses[0]
        ServerStatusLabel.stringValue = address
    }
}


class TcpService : NSObject, NSStreamDelegate{
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    // sets up the streams and opens them.
    func initOutputStream(IP: String, Port: Int){
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, IP as NSString, UInt32(Port), nil, &writeStream)

        outputStream = writeStream?.takeUnretainedValue();
        
        self.outputStream!.delegate = self
        
        self.outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)

        self.outputStream?.open()
    }
    
    func SendMsg(msg:String) -> Int{
        return outputStream!.write(msg, maxLength: countElements(msg))
    }

    
    // sets up the streams and opens them.
    func initInputStream(Port: Int){
        var readStream: Unmanaged<CFReadStream>?
        
        let IPAdresses: [String] = getIFAddresses()
        let address = IPAdresses.count == 0 ? "localhost" : IPAdresses[0]
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, address as NSString, UInt32(Port), &readStream, nil)
        
        inputStream = readStream?.takeUnretainedValue();
        
        self.inputStream!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream?.open()
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    // Eventhandler
    func stream(aStream: NSStream!, handleEvent eventCode: NSStreamEvent){
        switch eventCode {
            
        case NSStreamEvent.None:
            println("None")
            break
        case NSStreamEvent.OpenCompleted:
            println("Opened")
            break
        case NSStreamEvent.HasSpaceAvailable:
            println("HasSpaceAvailable")
            break
        case NSStreamEvent.HasBytesAvailable:
            println("HasBytesAvailable")
            break
        case NSStreamEvent.ErrorOccurred:
            println("Can not connect to the host!")
            break
        case NSStreamEvent.EndEncountered:
            println("EndEncountered")
            break
        default:
            println("default")
        }
    }
}
