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
        
        if selected > 0 {
        //Create the AlertController
            if #available(iOS 8.0, *) {
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Удалить выбранные фото?", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                //Create and an option action
                let nextAction: UIAlertAction = UIAlertAction(title: "Удалить", style: .Default) { action -> Void in
                    //Do some other stuff
                    /*let indexPath = self.PhotoCollectionView.indexPathsForVisibleItems()
                    let reversed = indexPath.sort(self.backwards)
                    
                    for i in reversed{
                        let cell = self.PhotoCollectionView.cellForItemAtIndexPath(i) as! PhotoCollectionViewCell
                        if cell.ImgSelector.hidden == false {
                            choosedSegmentImages ? photos.removeAtIndex(i.row) : uzis.removeAtIndex(i.row)
                            self.selected -= 1
                            choosedSegmentImages ? self.deleteImage(i.row) : self.deleteImageUzi(i.row)
                        }
                        
                    }*/
                    self.deleteImage(0)
                    self.title =  "\(self.selected) выбрано"
                    self.PhotoCollectionView.reloadData()
                }
                actionSheetController.addAction(nextAction)
                
                //Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func backwards(s1: NSIndexPath, _ s2: NSIndexPath) -> Bool {
        return s1.row > s2.row
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  choosedSegmentImages ? photos.count : uzis.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoSelCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        PhotoCell.photo.image = choosedSegmentImages ? photos[indexPath.row].image : uzis[indexPath.row].image
        PhotoCell.ImgSelector.hidden = true
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
    
    func savePhotos(img: UIImage, Type: Int){
        
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        let type = Expression<Int64>("Type")
        
        let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
        
        if(Type == 0){
            let table = Table("Photo")
            try! db.run(table.insert(date <- "\(NSDate())", image <- Blob(bytes: imageData.datatypeValue.bytes), type <- Int64(Type)))
        }else{
            let table = Table("Uzi")
            try! db.run(table.insert(date <- "\(NSDate())", image <- Blob(bytes: imageData.datatypeValue.bytes), type <- Int64(Type)))
        }
    }
    
    func deleteImage(index: Int){
        var table = Table("Photo")
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        
        var count = try! db.scalar(table.count)
        
        if count > 0{
            try! db.run(table.delete())
        }
        
        for var i in photos{
            let imageData = NSData(data: UIImageJPEGRepresentation(i.image, 1.0)!)
            try! db.run(table.insert(date <- "\(i.date)", image <- Blob(bytes: imageData.datatypeValue.bytes)))
        }
        
        table = Table("Uzi")
        
        count = try! db.scalar(table.count)
        
        if count > 0{
            try! db.run(table.delete())
        }
        
        for var i in uzis{
            let imageData = NSData(data: UIImageJPEGRepresentation(i.image, 1.0)!)
            try! db.run(table.insert(date <- "\(i.date)", image <- Blob(bytes: imageData.datatypeValue.bytes)))
        }
        /*let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Image", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            var j=0
            for i in result{
                if j == index {
                    managedContext.deleteObject(i as! NSManagedObject)}
                j += 1
            }
            do {
                try managedContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }*/
    }
    
    func deleteImageUzi(index: Int){
        /*let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("ImageUzi", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            var j=0
            for i in result{
                if j == index {
                    managedContext.deleteObject(i as! NSManagedObject)}
                j += 1
            }
            do {
                try managedContext.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }*/
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
