//
//  ViewController.swift
//  PlayU3M8
//
//  Created by Tuuu on 3/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
import MediaPlayer
class ViewController: UIViewController {

    var moviePlayer : MPMoviePlayerController?
    var videoPlayer:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        let fileURL = NSURL(string: "")

    }
    private func playVideo() {
        let path = "http://74.208.128.124:1935/live/myStream/playlist.m3u8"
 
            //path = NSBundle.mainBundle().pathForResource("movie", ofType:"m4v"),
            
            let url = NSURL(string: path)
            let moviePlayer = MPMoviePlayerController(contentURL: url as URL!)
            self.moviePlayer = moviePlayer
            moviePlayer?.view.frame = self.view.bounds
            moviePlayer?.prepareToPlay()
            moviePlayer?.scalingMode = .aspectFill
            self.view.addSubview((moviePlayer?.view)!)

    }


}

