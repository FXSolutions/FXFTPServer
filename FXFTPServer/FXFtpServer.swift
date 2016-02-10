//
//  FXFtpServer.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/3/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation

class FXFtpServer:NSObject, GCDAsyncSocketDelegate {
    
    var listenSocket        : GCDAsyncSocket!
    var connectedSockets    : Array<AnyObject>!
    var server              : AnyObject!
    var notificationObject  : AnyObject!
    
    var portNumber          : Int!
    weak var delegate       : AnyObject!
    
    var connections         : Array<AnyObject>!
    
    var commands            : NSDictionary!
    var baseDir             : NSString!
    var changeRoot          : Bool!
    
    var clientEncoding      : UInt!
    
    
    init(serverPort:Int, dir:NSString, notifyObject:AnyObject) {
        super.init()
        
        // notify object
        self.notificationObject = notifyObject
        
        // Load up commands
        let plistPath = NSBundle.mainBundle().pathForResource("ftp_commands", ofType: "plist")
        
        if (NSFileManager.defaultManager().fileExistsAtPath(plistPath!)) {
            print("ftp_commands.plist ok")
        }
        
        self.commands = NSDictionary.init(contentsOfFile: plistPath!)
        
        // Clear out connections list
        self.connections = Array<AnyObject>()
        
        // Create a socket
        self.portNumber = serverPort
        
        let mainQueue = dispatch_get_main_queue()
        let myListenSocket = GCDAsyncSocket(delegate: self, delegateQueue: mainQueue)
        self.listenSocket = myListenSocket
        
        // start lisetning on this port.
        print("Listening on port: \(self.portNumber)")
        
        self.connectedSockets = Array<AnyObject>()
        
        let fileManager = NSFileManager.defaultManager()
        let expandedPath = dir.stringByStandardizingPath
        
        if (fileManager.changeCurrentDirectoryPath(expandedPath)) {
            
            self.baseDir = fileManager.currentDirectoryPath
            
            
        } else {
            
            self.baseDir = dir
            
        }
        
        self.changeRoot = false
        
        self.clientEncoding = NSUTF8StringEncoding
        
        
    }
    
    
    func stopFtpServer() {
        
        if(listenSocket != nil) {
            self.listenSocket.disconnect()
        }
        
        // clear all connections
        
        self.connectedSockets.removeAll()
        self.connections.removeAll()
        
    }
    
    //MARK:- AsyncSocket delegate
    
    override func onSocket(sock: AsyncSocket!, didAcceptNewSocket newSocket: AsyncSocket!) {
        
        
        
    }
    
    override func onSocket(sock: AsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        //
    }
    
    //MARK:- Notifications
    
    func didReceiveFileListChanged() {
        
    }
    
    //MARK:- Connections
    
    func closeConnection(connection:AnyObject) {
        
    }
    
    func createList(directoryPath:String) -> String {
        return ""
    }
    
    deinit {
        
        if (self.listenSocket != nil) {
            self.listenSocket.disconnect()
            self.listenSocket = nil
        }
        
        self.connectedSockets = nil
        self.notificationObject = nil
        self.connections = nil
        self.commands = nil
        self.baseDir = nil
        
    }
    
}
