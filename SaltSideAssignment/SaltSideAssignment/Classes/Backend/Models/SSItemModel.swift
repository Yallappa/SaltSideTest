//
//  SSItemModel.swift
//  SaltSideAssignment
//
//  Created by Yallappa Kuntennavar on 18/10/15.
//  Copyright © 2015 Yallappa. All rights reserved.
//

import UIKit

class SSItemModel: SSImageBaseModel {
    
    var imageURLString: String? = nil
    var itemDescription: String? = nil
    var title: String? = nil
    
    init(parseDict: Dictionary<String, AnyObject>) {
        super.init()
        
        if let imageURLStringValue = parseDict["image"] as? String {
            self.imageURLString = imageURLStringValue
            self.imageLink = imageURLStringValue
        }
        if let itemDescriptionValue = parseDict["description"] as? String {
            self.itemDescription = itemDescriptionValue
        }
        if let titleValue = parseDict["title"] as? String {
            self.title = titleValue
        }
    }
}
