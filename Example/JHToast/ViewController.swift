//
//  ViewController.swift
//  JHToast
//
//  Created by 13298303056@163.com on 05/21/2020.
//  Copyright (c) 2020 13298303056@163.com. All rights reserved.
//

import UIKit
import JHToast

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func show(_ sender: Any) {
        JHToast.showToast(text: "是打工的家啊好风光拉黑是健康", type: .center)
    }
    
}

