//
//  PhotosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData

var photos = [UIImage]()
var uzis = [UIImage]()
var choosedSegmentImages = true // true: photo, false: uzi
class PhotosViewController: UICollectionViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    
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
        loadImage()
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
        choosedSegmentImages ? photos.append(chosenImage) : uzis.append(chosenImage)
        dismissViewControllerAnimated(true, completion: nil)
        PhotoCollectionView.reloadData()
        let type: String
        choosedSegmentImages ? (type="photo") : (type="uzi")
        savePhotos(chosenImage,type: type)
    }
    
    @IBAction func SegmentChanger(sender: AnyObject) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    private func reloadTable(index: Bool) {
        choosedSegmentImages = index
        PhotoCollectionView.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedSegmentImages ? photos.count : uzis.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        PhotoCell.photo.image = choosedSegmentImages ? photos[indexPath.row] : uzis[indexPath.row]
        return PhotoCell
    }
    
    func savePhotos(img: UIImage, type: String){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Image",
                                                        inManagedObjectContext:
            managedContext)
        
        let Photos = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext:managedContext)
        
        let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
        
        Photos.setValue(imageData, forKey: "photo")
        
        Photos.setValue(type, forKey: "type")
        
        do {
            try Photos.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
 
    func loadImage(){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Image", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        photos.removeAll()
        uzis.removeAll()
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for i in result {
                    let Images = i as! NSManagedObject
                    let tmpIMG = Images.valueForKey("photo") as! NSData
                    let tmpTYPE = Images.valueForKey("type") as! String
                    let img = UIImage(data: tmpIMG)
                    
                    if(tmpTYPE == "photo"){
                        photos.append(img!)
                    }else{
                        uzis.append(img!)
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
