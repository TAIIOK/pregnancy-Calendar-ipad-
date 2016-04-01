//
//  PhotosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var photos = [UIImage]()
var uzis = [UIImage]()
class PhotosViewController: UICollectionViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    var choosedSegment = true // true: photo, false: uzi
    var picker:UIImagePickerController?=UIImagePickerController()
    
    @IBOutlet var PhotoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.delegate=self
        let a = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(PhotosViewController.openCamera))
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PhotosViewController.addPhoto))
        a.tintColor = UIColor.whiteColor()
        b.tintColor = UIColor.whiteColor()
        self.navigationItem.setLeftBarButtonItems([a,b], animated: true)
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker!.cameraCaptureMode = .Photo
            presentViewController(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style:.Default, handler: nil)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func addPhoto(){
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(picker!, animated: true, completion: nil)
    }
    
    @IBAction func BtnSelect(sender: AnyObject) {
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        choosedSegment ? photos.append(chosenImage) : uzis.append(chosenImage)
        dismissViewControllerAnimated(true, completion: nil)
        PhotoCollectionView.reloadData()
    }
    
    @IBAction func SegmentChanger(sender: AnyObject) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    private func reloadTable(index: Bool) {
        choosedSegment = index
        PhotoCollectionView.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedSegment ? photos.count : uzis.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        PhotoCell.photo.image = choosedSegment ? photos[indexPath.row] : uzis[indexPath.row]
        return PhotoCell
    }
    /*override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        if(cell.ImgSelector.hidden == true){
            cell.ImgSelector.hidden = false
        }else{
            cell.ImgSelector.hidden = true
        }
        
    }*/

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
