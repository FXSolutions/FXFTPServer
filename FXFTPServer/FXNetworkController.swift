//
//  FXNetworkController.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/3/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation
import Darwin

class FXNetworkController {
    
    class func localWifiIPAddress() -> String  {
        
        let address:String = "no address"
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                
                if String.fromCString(ptr.memory.ifa_name) == "en0" {
                    var addr = ptr.memory.ifa_addr.memory
                    
                    // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                            
                            // Convert interface address to a human readable string:
                            var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                            
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                    if let decoded_address = String.fromCString(hostname) {
                                        return decoded_address
                                    }
                            }
                        }
                    }

                }
                
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    class func localIPAddress() -> String {
        
        /*
        char baseHostName[255];
        gethostname(baseHostName, 255);
        
        // Adjust for iPhone -- add .local to the host name
        char hn[255];
        sprintf(hn, "%s.local", baseHostName);
        
        struct hostent *host = gethostbyname(hn);
        if (host == NULL)
        {
        herror("resolv");
        return NULL;
        }
        else {
        struct in_addr **list = (struct in_addr **)host->h_addr_list;
        return [NSString stringWithCString:inet_ntoa(*list[0])];
        }
        
        return NULL;
        */
        
        
        return ""
    }
    
    
    class func addressFromString(ipAddress:String,address:UnsafeMutablePointer<sockaddr_in>) -> Bool {
        
        return true
        
    }
    
    class func hostAvailable(host:String) -> Bool {
        
        let addressString = getIPAddressForHost(host)
        
        if addressString == "" {
            return false;
        }
        
        var address = UnsafeMutablePointer<sockaddr_in>()
        
        let gotAddress = addressFromString(addressString, address: address)
        
        if (gotAddress == false) {
            return false;
        }

        guard let defaultRouteReachability = withUnsafePointer(&address, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        
        return isReachable
        
    }
    
    class func getIPAddressForHost(host:String) -> String {
        
        let host = CFHostCreateWithName(nil,host).takeRetainedValue()
        CFHostStartInfoResolution(host, .Addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
                var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                if getnameinfo(UnsafePointer(theAddress.bytes), socklen_t(theAddress.length),
                    &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        if let numAddress = String.fromCString(hostname) {
                            return numAddress
                        }
                }
        }
        return ""
    }
    
    class func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
}





