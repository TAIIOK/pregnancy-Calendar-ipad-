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

let videosDress = ["iC5Oe_molfw",
                   "2-rkmvmlZhY",
                   "PpIWPXG67LE",
                   "6xDPPupoErk",
                   "jTYKDH9Gp8A",
                   "CqbEmt5OvTw",
                   "qt4Nrwi2H6s",
                   "5EtmXqBcgHM",
                   "r5BwTUiPHDM",
                   "kfIfbrlg1Ik",
                   "gkTuKuvnVvo",
                   "H9u7Skai4gY",
                   "PJL5TMXYSOQ",
                   "fcUPgKMVWXA",
                   "6HI_l9JitwE",
                   "HBeBFGPJvwU",
                   "D7xclqFnmrk",
                   "YgsHdIhCCrQ",
                   "j3wmoPJlR2A",
                   "ZuBKd2D3TPg",
                   "u9-klWTYBeo",
                   "Da8nM8Ga1Jc",
                   "TgihONK_swI",
                   "dt-XaCO5mtc",
                   "0F-dlfN9664"]

let videosGym = ["iBzR_TNrWMI",
                 "oCXnXP2R1NE",
                 "evUKbaeGXB0",
                 "-2jV00pq8Iw",
                 "QELTjHFHqxg"]

var videoTitlefirst = [String]()
var imagesfirst = [UIImage]()


var imagessecond = [UIImage]()
var videoTitlesecond = [String]()


var videoIndex = 0
var choosedVideoSegment = true // true: dress, false: gym

class VideosViewController: UICollectionViewController {

    

    @IBOutlet weak var web: UIWebView!

    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet var VideoCollectionView: UICollectionView!
    @IBOutlet weak var VideoChanger: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoCollectionView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        VideoCollectionView.backgroundColor = .clearColor()
    }
    
    @IBAction func ChangeSegment(sender: AnyObject) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    private func reloadTable(index: Bool) {
        choosedVideoSegment = index
        VideoCollectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedVideoSegment ? imagesfirst.count : imagessecond.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let VideoCell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCollectionViewCell


        let id =  choosedVideoSegment ? "\(videosDress[indexPath.row])" : "\(videosGym[indexPath.row])"
        
        
        

        VideoCell.photo.image = choosedVideoSegment ? imagesfirst[indexPath.row] : imagessecond[indexPath.row]
        VideoCell.title.text = choosedVideoSegment ? videoTitlefirst[indexPath.row]: videoTitlesecond[indexPath.row]
        VideoCell.backgroundColor = .clearColor()

        return VideoCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        videoIndex = indexPath.row
        //let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("textNote")
        //self.navigationController?.pushViewController(destinationViewController!, animated: true)
        /*// youtube player
        var videoPlayer = YouTubePlayerView(frame: self.view.frame)
        videoPlayer.backgroundColor = .whiteColor()
        self.view.addSubview(videoPlayer)
        self.view.bringSubviewToFront(videoPlayer)
        let id =  choosedVideoSegment ? "\(videosDress[indexPath.row])" : "\(videosGym[indexPath.row])"
        videoPlayer.loadVideoID(id)
        */
        /*
        let webView = UIWebView(frame: self.view.frame)
        
        self.view.addSubview(webView)
         
        self.view.bringSubviewToFront(webView)
        
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = false
        webView
        var url: String
        choosedSegment ? (url = videosDress[indexPath.row]) : (url = videosGym[indexPath.row])
        
        
        
         // попытка сделать через movieplayer
        
        var audioplayer : MPMoviePlayerController
        
        var MPMoviePlayerViewController = MPMoviePlayerController(contentURL:  NSURL.fileURLWithPath(url))
        
        MPMoviePlayerViewController.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        MPMoviePlayerViewController.movieSourceType = MPMovieSourceType.File
        
        self.view.addSubview(MPMoviePlayerViewController.view)
        MPMoviePlayerViewController.prepareToPlay()
        MPMoviePlayerViewController.play()
        MPMoviePlayerViewController.pause()
        */
        
        
        
        // web view
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
