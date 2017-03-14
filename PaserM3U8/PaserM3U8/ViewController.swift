//
//  ViewController.swift
//  PaserM3U8
//
//  Created by Nguyen Van Tu on 3/14/17.
//  Copyright © 2017 Nguyen Van Tu. All rights reserved.
//

import UIKit
import Pantomime
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let builder = ManifestBuilder()
        if let url = NSURL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8") {
            let manifest = builder.parse(url as URL)
            print(manifest)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

