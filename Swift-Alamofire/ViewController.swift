//
//  ViewController.swift
//  Swift-Alamofire
//
//  Created by YouXianMing on 16/8/22.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var rootModel : RootModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"]) .responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                
                print("JSON: \(JSON)")
                self.rootModel = RootModel(dictionary: JSON as? [String : AnyObject])
            }
        }
    }
}

