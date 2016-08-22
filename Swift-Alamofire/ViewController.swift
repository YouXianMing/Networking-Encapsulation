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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"]).response { request, response, data, error in
            
            print(request)
            print(response)
            print(data?.classForCoder)
            print(error)
        }
    }
}

