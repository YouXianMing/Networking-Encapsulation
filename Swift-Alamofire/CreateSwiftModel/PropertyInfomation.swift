//
//  PropertyInfomation.swift
//  CreateJSONModel
//
//  Created by YouXianMing on 16/8/23.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

enum PropertyType : Int {
    
    case NSString, NSNumber, Null, NSDictionary, NSArray
}

class PropertyInfomation: NSObject {

    var propertyType : PropertyType?
    var propertyName : String?
    
    convenience init(propertyType : PropertyType, propertyName : String) {
        
        self.init()
        self.propertyType = propertyType
        self.propertyName = propertyName
    }
}
