//
//  ViewController.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
enum CompassPoint: Int {
    case north = 1
    case south
    case east
    case west
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = CompassPoint.init(rawValue: 1)
        switch a! {
        case .north: break
            
        default: break
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

