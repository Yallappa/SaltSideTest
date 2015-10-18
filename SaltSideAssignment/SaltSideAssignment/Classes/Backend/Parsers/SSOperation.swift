//
//  SSOperation.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSOperation: NSOperation {
    var url: NSURL? = nil
    var error: NSError? = nil
    var status: Bool = false
    
    var completionHandler: ((operation: SSOperation, result: AnyObject?) ->())!
    
    init(completionHandler: (operation: SSOperation, result: AnyObject?) -> ()) {
        super.init()
        
        self.completionHandler = completionHandler
    }
}
