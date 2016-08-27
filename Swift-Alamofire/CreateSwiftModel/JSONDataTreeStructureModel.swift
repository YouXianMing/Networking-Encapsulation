//
//  JSONDataTreeStructureModel.swift
//  CreateJSONModel
//
//  Created by YouXianMing on 16/8/23.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class JSONDataTreeStructureModel: NSObject {
    
    var normalProperties        : Dictionary <String, String>                     = Dictionary()
    var dictionaryTypeModelList : Dictionary <String, JSONDataTreeStructureModel> = Dictionary()
    var arrayTypeModelList      : Dictionary <String, JSONDataTreeStructureModel> = Dictionary()
    
    var level                   : Int = 0
    var modelName               : String?
    var listType                : String?
    
    /**
     Get all the JSONDataTreeStructureModels.
     
     - parameter pointerArray: The JSONDataTreeStructureModel array.
     */
    func traverseModel(pointerArray : NSPointerArray) {
        
        pointerArray.addPointer(UnsafeMutablePointer(unsafeAddressOf(self)))

        for (_, value) in dictionaryTypeModelList {
            
            value.traverseModel(pointerArray)
        }
        
        for (_, value) in arrayTypeModelList {
            
            value.traverseModel(pointerArray)
        }
    }
    
    /**
     Get all the properties.
     
     - returns: The PropertyInfomation's array.
     */
    func allProperties() -> [PropertyInfomation] {
        
        var propertyInfomations = [PropertyInfomation]()
        
        // 处理普通属性
        for (key, value) in normalProperties {
            
            switch value {
                
            case "NSString": propertyInfomations.append(PropertyInfomation(propertyType: .NSString, propertyName: key))
            case "NSNumber": propertyInfomations.append(PropertyInfomation(propertyType: .NSNumber, propertyName: key))
            case "NSNull"  : propertyInfomations.append(PropertyInfomation(propertyType: .Null    , propertyName: key))
            default        : break
            }
        }
        
        // 处理字典属性
        for (key, _) in dictionaryTypeModelList {
            
            propertyInfomations.append(PropertyInfomation(propertyType: .NSDictionary, propertyName: key))
        }
        
        // 处理数组属性
        for (key, _) in arrayTypeModelList {
            
            propertyInfomations.append(PropertyInfomation(propertyType: .NSArray, propertyName: key))
        }
        
        return propertyInfomations
    }
    
    /**
     Access the json dictionary.
     
     - parameter dictionary: The json data dictionary.
     */
    func accessDictionary(dictionary : NSDictionary?) {
        
        guard dictionary != nil else {
            
            return
        }
        
        for (key , object) in dictionary! {
            
            // 处理普通属性
            if object.isKindOfClass(NSString.classForCoder())  {
                
                normalProperties[key as! String] = "NSString"
                continue
            }
            
            if object.isKindOfClass(NSNumber.classForCoder()) {
                
                normalProperties[key as! String] = "NSNumber"
                continue
            }
            
            if object.isKindOfClass(NSNull.classForCoder()) {
                
                normalProperties[key as! String] = "NSNull"
                continue
            }
            
            // 处理字典属性
            if object.isKindOfClass(NSDictionary.classForCoder()) {
                
                let node = nodeWithName((key as? String)!)
                node.accessDictionary(object as? NSDictionary)
                dictionaryTypeModelList.updateValue(node, forKey: key as! String)
                continue
            }
            
            // 处理数组属性
            if object.isKindOfClass(NSArray.classForCoder()) {
                
                if let array = object as? NSArray {
                    
                    if array.count > 0 && array[0].isKindOfClass(NSDictionary.classForCoder()) {
                        
                        let node = nodeWithName((key as? String)!)
                        node.accessDictionary(array[0] as? NSDictionary)
                        arrayTypeModelList.updateValue(node, forKey: key as! String)
                        
                    } else {
                        
                        let node = nodeWithName((key as? String)!)
                        node.accessDictionary(nil)
                        arrayTypeModelList.updateValue(node, forKey: key as! String)
                    }
                }
            }
        }
    }
    
    /**
     Create node with given name.
     
     - parameter name: The given name string.
     
     - returns: The JSONDataTreeStructureModel.
     */
    private func nodeWithName(name : String) -> JSONDataTreeStructureModel {
        
        let node       = JSONDataTreeStructureModel()
        node.level     = level + 1
        node.listType  = name
        node.modelName = node.listType?.stringByAppendingString("Model")
        
        let range      = node.modelName!.startIndex ..< node.modelName!.startIndex.advancedBy(1)
        var firstC     = node.modelName?.substringWithRange(range)
        firstC         = firstC?.capitalizedString
        node.modelName = node.modelName?.stringByReplacingCharactersInRange(range, withString: firstC!)
        
        return node
    }
}
