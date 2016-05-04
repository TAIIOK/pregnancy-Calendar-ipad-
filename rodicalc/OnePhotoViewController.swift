//
//  OnePhotoViewController.swift
//  Календарь беременности
//
//  Created by deck on 04.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class OnePhotoViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = choosedSegmentImages ? photos[currentPhoto].image : uzis[currentPhoto].image
    }
    

    @IBAction func Delete(sender: UIBarButtonItem) {
 
            //Create the AlertController
            if #available(iOS 8.0, *) {
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Удалить фото?", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                //Create and an option action
                let nextAction: UIAlertAction = UIAlertAction(title: "Удалить", style: .Default) { action -> Void in
                    //Do some other stuff
                    choosedSegmentImages ? photos.removeAtIndex(currentPhoto) : uzis.removeAtIndex(currentPhoto)
                    choosedSegmentImages ? self.deleteImage(currentPhoto) : self.deleteImageUzi(currentPhoto)
                    let ph = self.storyboard?.instantiateViewControllerWithIdentifier("photo")
                    self.splitViewController?.showDetailViewController(ph!, sender: self)
                }
                actionSheetController.addAction(nextAction)
                
                //Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        
    }
    
    func backwards(s1: NSIndexPath, _ s2: NSIndexPath) -> Bool {
        return s1.row > s2.row
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
        let table = Table("Photo")
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        
        let count = try! db.scalar(table.count)
        
        if count > 0{
            try! db.run(table.delete())
        }
        for var i in photos{
            let imageData = NSData(data: UIImageJPEGRepresentation(i.image, 1.0)!)
            try! db.run(table.insert(date <- "\(i.date)", image <- Blob(bytes: imageData.datatypeValue.bytes)))
        }
    }
    
    func deleteImageUzi(index: Int){
        let table = Table("Uzi")
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        let count = try! db.scalar(table.count)
        
        if count > 0{
            try! db.run(table.delete())
        }
        
        for var i in uzis{
            let imageData = NSData(data: UIImageJPEGRepresentation(i.image, 1.0)!)
            let dateFormatter = NSDateFormatter()
            try! db.run(table.insert(date <- "\(i.date)", image <- Blob(bytes: imageData.datatypeValue.bytes)))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
