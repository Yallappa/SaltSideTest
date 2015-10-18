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
    
    
    func fetchItems(completionHandler: (operationObject: SSOperation, status: Bool) -> ()) {
        let itemsOperation = SSItemsOperation() {
            (operation, result) -> () in
            
            if result {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(operationObject: operation, status: true)
                })
                
            }else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(operationObject: operation, status: false)
                })
            }
        }
        
        itemsOperation.url = NSURL(string: kItemsListURL)
        operationQueue.addOperation(itemsOperation)
    }
}
