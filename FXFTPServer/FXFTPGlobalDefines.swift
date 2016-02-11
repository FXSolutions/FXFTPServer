//
//  FXFTPGlobalDefines.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/11/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation

enum ftp_enum:Int {
    case pasvftp = 0,epsvftp,portftp,lprtftp, eprtftp
}

let SERVER_PORT = 20000
let READ_TIMEOUT = -1

let FTP_CLIENT_REQUEST = 0

enum client:Int {
    case Sending = 0, Receiving, Quiet, Sent
}

//DATASTR
extension String {
    
    func getData() -> NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }

}