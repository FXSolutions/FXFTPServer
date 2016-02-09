//
//  FXFtpConnection.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/3/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation

class FXFtpConnection {
    
    var connectionSocket    :GCDAsyncSocket!
    var server              :FXFtpServer!
    
    var dataListeningSocket     :GCDAsyncSocket!
    var dataSocket              :GCDAsyncSocket!
    
    var dataConnection : AnyObject!
    
    init() {
        
    }
    

}
