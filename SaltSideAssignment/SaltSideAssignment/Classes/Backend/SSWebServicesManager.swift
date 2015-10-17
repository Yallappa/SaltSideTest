//
//  SSWebServicesManager.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSWebServicesManager: NSObject {
    
    var operationQueue = NSOperationQueue()
    
    class var sharedInstance: SSWebServicesManager {
        struct Static {
            static var instance: SSWebServicesManager? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = SSWebServicesManager()
        }
        
        return Static.instance!
    }
    
    
    func fetchItems(completionHandler: (operationObject: SSOperation, result: Array<SSItemModel>)) {
        let itemsOperation = SSItemsOperation() {
            (opertion, result) -> () in
            
            
        }
        
        itemsOperation.url = NSURL(string: kItemsListURL)
        operationQueue.addOperation(itemsOperation)
    }
}
