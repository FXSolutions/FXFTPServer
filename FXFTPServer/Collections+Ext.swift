//
//  Collections+Ext.swift
//  FXFTPServer
//
//  Created by kioshimafx on 2/9/16.
//  Copyright © 2016 kioshimafx. All rights reserved.
//

import Foundation


extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
}