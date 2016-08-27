//
//  JSONDataTreeStructureModelFileCreator.swift
//  CreateJSONModel
//
//  Created by YouXianMing on 16/8/26.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class JSONDataTreeStructureModelFileCreator: NSObject {
    
    private var structModel     : JSONDataTreeStructureModel?
    private var swiftFile       : String!
    private var swiftDictionary : String!
    private var swiftArray      : String!
    
    init?(model : JSONDataTreeStructureModel?) {
        
        super.init()
        structModel = model
        
        if let filePath = NSBundle.mainBundle().pathForResource("swiftTextPattern", ofType: nil) {
            
            if let string = try? String(contentsOfFile: filePath) {
                
                swiftFile = string
            }
        }
        
        if let filePath = NSBundle.mainBundle().pathForResource("swiftDictionaryPattern", ofType: nil) {
            
            if let string = try? String(contentsOfFile: filePath) {
                
                swiftDictionary = string
            }
        }
        
        if let filePath = NSBundle.mainBundle().pathForResource("swiftArrayPattern", ofType: nil) {
            
            if let string = try? String(contentsOfFile: filePath) {
                
                swiftArray = string
            }
        }
    }
    
    func createFile() {
        
        guard structModel != nil else {
            
            return
        }
        
        // Replace the class string.
        swiftFile = swiftFile.stringByReplacingOccurrencesOfString("[SWIFT-CLASS-NAME-STRING]", withString: (structModel?.modelName)!)
     
        // Replace the properties string.
        let propertyString = createProperties()
        swiftFile          = swiftFile.stringByReplacingOccurrencesOfString("[SWIFT-PROPERTIES-STRING]", withString: propertyString)
        
        // Replace the list string.
        let listString = createArrayAndDictionaryString()
        swiftFile      = swiftFile.stringByReplacingOccurrencesOfString("[PLIST-STRING]", withString: listString)
        
        // Create file.
        let Documents     = NSHomeDirectory().stringByAppendingString("/Documents")
        let swiftFilePath = Documents.stringByAppendingString("/" + (structModel?.modelName)! + ".swift")
        if let _ = try? swiftFile.writeToURL(NSURL.fileURLWithPath(swiftFilePath), atomically: true, encoding: NSUTF8StringEncoding) {}
    }
    
    private func createProperties() -> String {
        
        var propertiesString = ""
        
        // Get the longest characters count.
        var longestCharacters = 0
        let properties        = structModel?.allProperties()
        for (_, value) in (properties?.enumerate())! {
            
            if longestCharacters <= value.propertyName?.characters.count {
                
                longestCharacters = (value.propertyName?.characters.count)!
            }
        }
        
        // Create var pattern.
        let spaceString       = "                                                                                "
        let usefulSpaceString = spaceString.substringToIndex(spaceString.startIndex.advancedBy(longestCharacters))
        let offset            = 8
        let patternString     = "    var \(usefulSpaceString) : [PATTERN]"
        
        // Get all properties.
        for (_, value) in (structModel?.allProperties().enumerate())! {
            
            switch value.propertyType! {
                
            case .NSString:
                
                let start         = patternString.startIndex.advancedBy(offset)
                let end           = patternString.startIndex.advancedBy(offset + value.propertyName!.characters.count)
                let tmpShowString = patternString.stringByReplacingCharactersInRange(Range(start ..< end), withString: value.propertyName!)
                
                let showShowString = tmpShowString.stringByReplacingOccurrencesOfString("[PATTERN]", withString: "String?")
                propertiesString   = propertiesString + showShowString + "\n"
                
            case .NSNumber:
                
                let start         = patternString.startIndex.advancedBy(offset)
                let end           = patternString.startIndex.advancedBy(offset + value.propertyName!.characters.count)
                let tmpShowString = patternString.stringByReplacingCharactersInRange(Range(start ..< end), withString: value.propertyName!)

                let showShowString = tmpShowString.stringByReplacingOccurrencesOfString("[PATTERN]", withString: "NSNumber?")
                propertiesString   = propertiesString + showShowString + "\n"
                
            case .Null:
                
                let start         = patternString.startIndex.advancedBy(offset)
                let end           = patternString.startIndex.advancedBy(offset + value.propertyName!.characters.count)
                let tmpShowString = patternString.stringByReplacingCharactersInRange(Range(start ..< end), withString: value.propertyName!)
                
                let showShowString = tmpShowString.stringByReplacingOccurrencesOfString("[PATTERN]", withString: "Null?")
                propertiesString   = propertiesString + showShowString + "\n"
                
            case .NSArray:
                
                let start         = patternString.startIndex.advancedBy(offset)
                let end           = patternString.startIndex.advancedBy(offset + value.propertyName!.characters.count)
                let tmpShowString = patternString.stringByReplacingCharactersInRange(Range(start ..< end), withString: value.propertyName!)
                
                let modelName      = "\((structModel?.arrayTypeModelList[value.propertyName!]?.modelName)!)"
                let showShowString = tmpShowString.stringByReplacingOccurrencesOfString("[PATTERN]", withString: "[\(modelName)]?")
                propertiesString   = propertiesString + showShowString + "\n"
                
            case .NSDictionary:
                
                let start         = patternString.startIndex.advancedBy(offset)
                let end           = patternString.startIndex.advancedBy(offset + value.propertyName!.characters.count)
                let tmpShowString = patternString.stringByReplacingCharactersInRange(Range(start ..< end), withString: value.propertyName!)
                
                let modelName      = "\((structModel?.dictionaryTypeModelList[value.propertyName!]?.modelName)!)"
                let showShowString = tmpShowString.stringByReplacingOccurrencesOfString("[PATTERN]", withString: "\(modelName)?")
                propertiesString   = propertiesString + showShowString + "\n"
            }
        }
        
        return propertiesString
    }
    
    private func createArrayAndDictionaryString() -> String {
        
        var showString = ""
        
        // Get all properties.
        for (_, value) in (structModel?.allProperties().enumerate())! {
            
            switch value.propertyType! {
    
            case .NSArray:
                
                let typeName      = "\((structModel?.arrayTypeModelList[value.propertyName!]?.modelName)!)"
                let propertyName  = (value.propertyName)!
                
                var arrayString = String(swiftArray)
                arrayString     = arrayString.stringByReplacingOccurrencesOfString("[PROPERTY-NAME]", withString: propertyName)
                arrayString     = arrayString.stringByReplacingOccurrencesOfString("[PROPERTY-TYPE]", withString: typeName)
                showString      = showString + arrayString + "\n"
                
            case .NSDictionary:
                
                let typeName      = "\((structModel?.dictionaryTypeModelList[value.propertyName!]?.modelName)!)"
                let propertyName  = (value.propertyName)!
                
                var dictionaryString = String(swiftDictionary)
                dictionaryString     = dictionaryString.stringByReplacingOccurrencesOfString("[PROPERTY-NAME]", withString: propertyName)
                dictionaryString     = dictionaryString.stringByReplacingOccurrencesOfString("[PROPERTY-TYPE]", withString: typeName)
                showString           = showString + dictionaryString + "\n"
                
            default:break}
        }
        
        return showString
    }
}


