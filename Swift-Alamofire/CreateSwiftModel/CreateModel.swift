//
//  CreateModel.swift
//  JSONDataTreeStructureModel
//
//  Created by YouXianMing on 16/8/27.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class CreateModel: NSObject {

    /**
     Create Model with json data.
     
     - parameter data:              JSON type data.
     - parameter withRootModelName: The root model name.
     */
    class func WithData(data : AnyObject?, withRootModelName : String? = "RootModel") {
        
        guard withRootModelName != nil && data != nil else {
        
            return
        }
        
        if data is NSDictionary {
            
            let nodeModel       = JSONDataTreeStructureModel()
            nodeModel.modelName = withRootModelName
            nodeModel.accessDictionary(data as? NSDictionary)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let controller  = JSONDataTreeStructureModelRootNavigationController(rootModel: nodeModel)
                
                var topViewController = appDelegate.window?.rootViewController
                while topViewController?.presentedViewController != nil {
                
                    topViewController = topViewController?.presentedViewController
                }
                
                if let _ = topViewController {
                
                    topViewController!.presentViewController(controller, animated: true, completion: nil)
                }
            })
        }
    }
}
