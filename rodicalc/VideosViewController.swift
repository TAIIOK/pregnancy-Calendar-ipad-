//
//  VideosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import MediaPlayer
import YouTubePlayer


class VideosViewController: UICollectionViewController {
    var choosedSegment = true // true: dress, false: gym
    
    @IBOutlet weak var web: UIWebView!

    @IBOutlet weak var playerView: YouTubePlayerView!
    

    
    let videosDress = ["https://www.youtube.com/embed/iC5Oe_molfw",
                       "https://www.youtube.com/embed/2-rkmvmlZhY",
                       "https://www.youtube.com/embed/PpIWPXG67LE",
                       "https://www.youtube.com/embed/6xDPPupoErk",
                       "https://www.youtube.com/embed/jTYKDH9Gp8A",
                       "https://www.youtube.com/embed/CqbEmt5OvTw",
                       "https://www.youtube.com/embed/qt4Nrwi2H6s",
                       "https://www.youtube.com/embed/5EtmXqBcgHM",
                       "https://www.youtube.com/embed/r5BwTUiPHDM",
                       "https://www.youtube.com/embed/kfIfbrlg1Ik",
                       "https://www.youtube.com/embed/gkTuKuvnVvo",
                       "https://www.youtube.com/embed/H9u7Skai4gY",
                       "https://www.youtube.com/embed/PJL5TMXYSOQ",
                       "https://www.youtube.com/embed/fcUPgKMVWXA",
                       "https://www.youtube.com/embed/6HI_l9JitwE",
                       "https://www.youtube.com/embed/HBeBFGPJvwU",
                       "https://www.youtube.com/embed/D7xclqFnmrk",
                       "https://www.youtube.com/embed/YgsHdIhCCrQ",
                       "https://www.youtube.com/embed/j3wmoPJlR2A",
                       "https://www.youtube.com/embed/ZuBKd2D3TPg",
                       "https://www.youtube.com/embed/u9-klWTYBeo",
                       "https://www.youtube.com/embed/Da8nM8Ga1Jc",
                       "https://www.youtube.com/embed/TgihONK_swI",
                       "https://www.youtube.com/embed/dt-XaCO5mtc",
                       "https://www.youtube.com/embed/0F-dlfN9664"]
    
    let videosGym = ["https://www.youtube.com/embed/iBzR_TNrWMI",
                     "https://www.youtube.com/embed/oCXnXP2R1NE",
                     "https://www.youtube.com/embed/evUKbaeGXB0",
                     "https://www.youtube.com/embed/-2jV00pq8Iw",
                     "https://www.youtube.com/embed/QELTjHFHqxg"]
    
    
   
    //@IBOutlet weak var VideoCollectionView: UICollectionView!
    
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet weak var VideoChanger: UISegmentedControl!
    //@IBOutlet weak var VideoChanger: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //VideoCollectionView.delegate = self
        //VideoCollectionView.dataSource = self
        //self.VideoCollectionView.registerClass(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCell")
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

   

    
    @IBAction func ChangeSegment(sender: AnyObject) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    private func reloadTable(index: Bool) {
        choosedSegment = index
        VideoCollectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedSegment ? videosDress.count : videosGym.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let VideoCell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCollectionViewCell

        VideoCell.photo.image = choosedSegment ? UIImage(named: "\(indexPath.row).jpg") : UIImage(named: "\(indexPath.row).png")
        return VideoCell
    }
    

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        var videoPlayer = YouTubePlayerView(frame: self.view.frame)
       
        self.view.addSubview(videoPlayer)
        self.view.bringSubviewToFront(videoPlayer)
        
        
        videoPlayer.loadVideoID("iC5Oe_molfw")
        
        
        
        
        
    
        /*
        let webView = UIWebView(frame: self.view.frame)
        
        self.view.addSubview(webView)
        self.view.bringSubviewToFront(webView)
        
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = false
        webView
        var url: String
        choosedSegment ? (url = videosDress[indexPath.row]) : (url = videosGym[indexPath.row])
        
        
        
        
        var audioplayer : MPMoviePlayerController
        
        var MPMoviePlayerViewController = MPMoviePlayerController(contentURL:  NSURL.fileURLWithPath(url))
        
        MPMoviePlayerViewController.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        MPMoviePlayerViewController.movieSourceType = MPMovieSourceType.File
        
        self.view.addSubview(MPMoviePlayerViewController.view)
        MPMoviePlayerViewController.prepareToPlay()
        MPMoviePlayerViewController.play()
        MPMoviePlayerViewController.pause()
        */
        print ( playerView.ready)

        
        
        /*
        /*
        web.allowsInlineMediaPlayback = true
         
         <iframe width="560" height="315" src="/(url)?rel=0&autoplay=1&amp;controls=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>
         
         
        let html = "<html><body><iframe src=\"http://www.youtube.com/embed/W7qWa52k-nE?autoplay=1&fullscrean=1\" width=\"560\" height=\"315\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
        
        web.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
        */
        
        var url: String
        choosedSegment ? (url = videosDress[indexPath.row]) : (url = videosGym[indexPath.row])
        
        
        web.allowsInlineMediaPlayback = true
        
        let html = " <iframe id=\"video\" src=\"//\(url)?rel=0&autoplay=1\" frameborder=\"0\" allowfullscreen></iframe>"
        
        web.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
        

      //  let myURLRequest : NSURLRequest = NSURLRequest(URL: NSURL(string: url+"&autoplay=1")!)
       // self.web.loadRequest(myURLRequest)
        
        /*
        var url = NSURL(string:"youtube://oHg5SJYRHA0")!
        if UIApplication.sharedApplication().canOpenURL(url)  {
            UIApplication.sharedApplication().openURL(url)
        } else {
            url = NSURL(string: URL)!
            UIApplication.sharedApplication().openURL(url)
        }
         */
        
  */
        
    }
 

}
