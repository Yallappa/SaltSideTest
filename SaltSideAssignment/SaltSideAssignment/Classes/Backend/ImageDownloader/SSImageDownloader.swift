//
//  SSImageDownloader.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSImageDownloader: NSObject {
    
    var imageModel: SSImageBaseModel? = nil
    var downloadedData: NSMutableData? = nil
    var urlSessionDataTask: NSURLSessionDataTask? = nil
    
    func startDownload(completionHandler: () -> ()) {
        if let image = SSFileCacheManager.sharedInstance.cacheObjectForKey((imageModel?.imageLink)!) as? UIImage {
            imageModel?.image = image
            completionHandler()
            
        }else {
            weak var weakSelf = self
            
            self.downloadedData = NSMutableData(capacity: 1)
            let urlRequest = NSURLRequest(URL: NSURL(string: (imageModel?.imageLink)!)!)
            
            let session = NSURLSession.sharedSession()
            self.urlSessionDataTask = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, _, error) -> Void in
                if let imageData = data {
                    weakSelf!.imageModel?.image = UIImage(data: imageData)
                    SSFileCacheManager.sharedInstance.cacheObject((weakSelf!.imageModel?.image)!, forKey: (weakSelf!.imageModel?.imageLink)!)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler()
                })
            })
            urlSessionDataTask!.resume()
        }
    }
    
    func stopDownload() {
        urlSessionDataTask?.cancel()
    }
}
