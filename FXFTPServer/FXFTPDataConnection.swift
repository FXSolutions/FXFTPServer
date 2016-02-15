//
//  FXFTPDataConnection.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/3/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation

class FXFTPDataConnection:NSObject,GCDAsyncSocketDelegate {
    
    var dataSocket : GCDAsyncSocket!
    var ftpConnect : FXFtpConnection!
    
    var dataListeningSocket : GCDAsyncSocket!
    var dataConnection      : AnyObject!
    var receivedData        : NSMutableData!
    var connectionState     : Int!
    
    ///

    ///
    
    //MARK:- Init
    
    init(newSocket:GCDAsyncSocket, connection:AnyObject, queuedData:NSMutableArray) {
        
        super.init()
        
        
        
    }
    
    //MARK:- Write
    
    func writeString(dataString:NSString) {
        
        
        
    }
    
    func writeData(data:NSMutableData) {
        
        
        
    }
    
    func writeQueuedData(queuedData:NSMutableArray) {
        
        
        
    }
    
    //MARK:- Close
    
    func closeConnection () {
        
        
        
    }
    
    //MARK: - GCDAsyncSocket delegates
    
    override func onSocketWillConnect(sock: AsyncSocket!) -> Bool {
        //
        
        return true
        
    }
    
    override func onSocket(sock: AsyncSocket!, didAcceptNewSocket newSocket: AsyncSocket!) {
        //
        
        
    }
    
    override func onSocket(sock: AsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        //
        
        
    }
    
    override func onSocket(sock: AsyncSocket!, didWriteDataWithTag tag: Int) {
        //
        
        
    }
    
    override func onSocket(sock: AsyncSocket!, willDisconnectWithError err: NSError!) {
        
        
        //
    }
    
    
    

}
