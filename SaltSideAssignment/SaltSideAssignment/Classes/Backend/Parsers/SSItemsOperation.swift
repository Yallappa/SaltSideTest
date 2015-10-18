//
//  SSItemsOperation.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSItemsOperation: SSOperation {
    
    override init(completionHandler: (operation: SSOperation, status: Bool) -> ()) {
        super.init(completionHandler: completionHandler)
        
    }
    
    override func main() {
        let urlRequest = NSURLRequest(URL: self.url!)
        
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let urlSessionTask = urlSession.dataTaskWithRequest(urlRequest) {
            (data, _, error) -> Void in
            
            if error == nil {
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    if let itemsArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                        var index = 0
                        
                        /**
                        If items are fetched delete all old items and allow offline access
                        */
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let coreDataController = SSCoreDataController.sharedInstance
                            coreDataController.deleteAllItemModels()
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                                () -> Void in
                                
                                for item in itemsArray {
                                    coreDataController.addItem(item, forIndex: index)
                                    index++
                                }
                                
                                coreDataController.saveContext(coreDataController.backgroundContext!)
                                self.completionHandler(operation: self, status: true)
                            })
                        })
                    }
                    
                } catch let error as NSError {
                    self.error = error
                    self.completionHandler(operation: self, status: false)
                    
                    abort()
                }
            }else {
                self.error = error
                self.completionHandler(operation: self, status: false)
            }
        }
        urlSessionTask.resume()
    }
}
