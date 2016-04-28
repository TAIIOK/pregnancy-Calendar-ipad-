//
//  VideoPlayerViewController.swift
//  rodicalc
//
//  Created by deck on 28.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = btnBack
        var videoPlayer = YouTubePlayerView(frame: self.view.frame)
        videoPlayer.backgroundColor = .whiteColor()
        self.view.addSubview(videoPlayer)
        self.view.bringSubviewToFront(videoPlayer)
        let id =  choosedVideoSegment ? "\(videosDress[videoIndex])" : "\(videosGym[videoIndex])"
        videoPlayer.loadVideoID(id)
        // Do any additional setup after loading the view.
    }
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
