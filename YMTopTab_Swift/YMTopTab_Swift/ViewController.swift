//
//  ViewController.swift
//  YMTopTab_Swift
//
//  Created by barryclass on 10/25/14.
//  Copyright (c) 2014 barryclass. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var tabsArray:[String] = ["1","2","3"]
        
        var topTab :YMTopTab =  YMTopTab(origin: CGPointMake(0, 80), tabsArray: tabsArray)
        self.view.addSubview(topTab)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

