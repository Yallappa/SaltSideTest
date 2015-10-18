//
//  SSItemsOperation.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSItemsOperation: SSOperation {
    
    override init(completionHandler: (operation: SSOperation, result: AnyObject?) -> ()) {
        super.init(completionHandler: completionHandler)
        
    }
    
    override func main() {
        let urlRequest = NSURLRequest(URL: self.url!)
        
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let urlSessionTask = urlSession.dataTaskWithRequest(urlRequest) {
            (data, _, error) -> Void in
            
            if error == nil {
                do {
                    var itemObjectsArray: Array<SSItemModel> = []
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    if let itemsArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                        for item in itemsArray {
                            let itemModel = SSItemModel(parseDict: item)
                            itemObjectsArray.append(itemModel)
                        }
                    }
                    
                    self.completionHandler(operation: self, result: itemObjectsArray)
                    
                } catch let error as NSError {
                    self.error = error
                    self.completionHandler(operation: self, result: nil)
                    
                    abort()
                }
            }else {
                self.error = error
                self.completionHandler(operation: self, result: nil)
            }
        }
        urlSessionTask.resume()
    }
}
