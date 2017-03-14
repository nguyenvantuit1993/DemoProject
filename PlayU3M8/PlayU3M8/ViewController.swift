//
//  ViewController.swift
//  PlayU3M8
//
//  Created by Tuuu on 3/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class ViewController: UIViewController {
    
    var moviePlayer : AVPlayerViewController?
    var videoPlayer:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        let fileURL = NSURL(string: "")
        
    }
    
    @IBAction func action(_ sender: Any) {
        print(getURL())
    }
    func getURL() -> URL?
    {
        let asset = videoPlayer.currentItem?.asset
        if asset == nil {
            return nil
        }
        if let urlAsset = asset as? AVURLAsset {
            return urlAsset.url
        }
        return nil
    }
    private func playVideo() {
        let path = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        
        //path = NSBundle.mainBundle().pathForResource("movie", ofType:"m4v"),
        
        moviePlayer = AVPlayerViewController()
        
        let url = NSURL(string: path)
        self.videoPlayer = AVPlayer(url: url! as URL)
        self.moviePlayer?.player = videoPlayer
        self.addChildViewController(moviePlayer!)
        self.view.addSubview((moviePlayer?.view)!)
        
        
        moviePlayer?.view.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height)
        
        
    }
    
    
}

