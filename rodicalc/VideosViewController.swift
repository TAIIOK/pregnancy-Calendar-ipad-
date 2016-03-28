//
//  VideosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit


class VideosViewController: UICollectionViewController {
    var choosedSegment = true // true: dress, false: gym
    
    let videosDress = ["https://www.youtube.com/watch?v=iC5Oe_molfw",
                       "https://www.youtube.com/watch?v=2-rkmvmlZhY",
                       "https://www.youtube.com/watch?v=PpIWPXG67LE",
                       "https://www.youtube.com/watch?v=6xDPPupoErk",
                       "https://www.youtube.com/watch?v=jTYKDH9Gp8A",
                       "https://www.youtube.com/watch?v=CqbEmt5OvTw",
                       "https://www.youtube.com/watch?v=qt4Nrwi2H6s",
                       "https://www.youtube.com/watch?v=5EtmXqBcgHM",
                       "https://www.youtube.com/watch?v=r5BwTUiPHDM",
                       "https://www.youtube.com/watch?v=kfIfbrlg1Ik",
                       "https://www.youtube.com/watch?v=gkTuKuvnVvo",
                       "https://www.youtube.com/watch?v=H9u7Skai4gY",
                       "https://www.youtube.com/watch?v=PJL5TMXYSOQ",
                       "https://www.youtube.com/watch?v=fcUPgKMVWXA",
                       "https://www.youtube.com/watch?v=6HI_l9JitwE",
                       "https://www.youtube.com/watch?v=HBeBFGPJvwU",
                       "https://www.youtube.com/watch?v=D7xclqFnmrk",
                       "https://www.youtube.com/watch?v=YgsHdIhCCrQ",
                       "https://www.youtube.com/watch?v=j3wmoPJlR2A",
                       "https://www.youtube.com/watch?v=ZuBKd2D3TPg",
                       "https://www.youtube.com/watch?v=u9-klWTYBeo",
                       "https://www.youtube.com/watch?v=Da8nM8Ga1Jc",
                       "https://www.youtube.com/watch?v=TgihONK_swI",
                       "https://www.youtube.com/watch?v=dt-XaCO5mtc",
                       "https://www.youtube.com/watch?v=0F-dlfN9664"]
    
    let videosGym = ["https://www.youtube.com/watch?v=iBzR_TNrWMI",
                     "https://www.youtube.com/watch?v=oCXnXP2R1NE",
                     "https://www.youtube.com/watch?v=evUKbaeGXB0",
                     "https://www.youtube.com/watch?v=-2jV00pq8Iw",
                     "https://www.youtube.com/watch?v=QELTjHFHqxg"]
    
    
   
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
        var URL: String
        choosedSegment ? (URL = videosDress[indexPath.row]) : (URL = videosGym[indexPath.row])
    }
}
