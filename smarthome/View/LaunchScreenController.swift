//
//  ViewController.swift
//  smarthome
//
//  Created by lu on 2018/10/17.
//  Copyright © 2018年 jifan. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    var mypluto:Pluto = Pluto();
    override func viewDidLoad() {
        mypluto = Pluto();
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

