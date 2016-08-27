//
//  JSONDataTreeStructureModelRootNavigationController.swift
//  CreateJSONModel
//
//  Created by YouXianMing on 16/8/24.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

class JSONDataTreeStructureModelRootNavigationController: UINavigationController {
    
    convenience init(rootModel : JSONDataTreeStructureModel) {
        
        let rootViewController                  = JSONDataTreeStructureModelController()
        rootViewController.treeStructureModel   = rootModel
        rootViewController.title                = rootModel.modelName
        rootViewController.isRootViewController = true
        
        self.init(rootViewController : rootViewController)
        setNavigationBarHidden(true, animated: false)
        
        rootViewController.useInteractivePopGestureRecognizer()
    }
}
