//
//  PhotosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData

class SelectPhotosViewController: UICollectionViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var PhotoCollectionView: UICollectionView!
    var selected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let a = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(PhotosViewController.openCamera))
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PhotosViewController.addPhoto))
        a.tintColor = UIColor.whiteColor()
        b.tintColor = UIColor.whiteColor()
        self.navigationItem.setLeftBarButtonItems([a,b], animated: true)*/
    }
    
    @IBAction func ShareSelected(sender: AnyObject) {
    }

    @IBAction func DeleteSelected(sender: AnyObject) {
        let indexPath = PhotoCollectionView.indexPathsForSelectedItems()
        for i in indexPath! {
            choosedSegmentImages ? photos.removeAtIndex(i.row) : uzis[i.row]
            PhotoCollectionView.reloadData()
            selected -= 1
        }
        self.title =  "\(selected) выбрано"
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedSegmentImages ? photos.count : uzis.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoSelCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        PhotoCell.photo.image = choosedSegmentImages ? photos[indexPath.row] : uzis[indexPath.row]
        
        return PhotoCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        if(cell.ImgSelector.hidden == true){
            cell.ImgSelector.hidden = false
            cell.selected = true
            selected += 1
        }else{
            cell.ImgSelector.hidden = true
            selected -= 1
            cell.selected = false
        }
        self.title =  "\(selected) выбрано"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
