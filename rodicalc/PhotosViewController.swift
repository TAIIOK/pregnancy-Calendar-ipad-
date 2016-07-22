//
//  PhotosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData


//var photos = [UIImage]()
//var uzis = [UIImage]()

class Photo: NSObject {
    var image: UIImage
    var date: NSDate
    var text: String
    init(image: UIImage, date: NSDate, text: String) {
        self.image = image
        self.date = date
        self.text = text
        super.init()
    }
}

var photos = [Photo]()
var uzis = [Photo]()
var choosedSegmentImages = true // true: photo, false: uzi
var currentPhoto = 0

extension UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
}

class LandscapePickerController: UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    public override func shouldAutorotate() -> Bool {
        return false
    }
}
class PhotosViewController: UICollectionViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    

    var picker:LandscapePickerController?=LandscapePickerController()
    
    @IBOutlet weak var changer: UISegmentedControl!
    @IBOutlet var PhotoCollectionView: UICollectionView!
    override func viewDidLoad() {
        selectedImages.removeAll()
        sharingExportVk  = false
        
        super.viewDidLoad()
        PhotoCollectionView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        PhotoCollectionView.backgroundColor = .clearColor()
        if choosedSegmentImages{
            changer.selectedSegmentIndex = 0
        }else{
            changer.selectedSegmentIndex = 1
        }
        picker?.delegate=self
        let a = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(PhotosViewController.openCamera))
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PhotosViewController.addPhoto))
        a.tintColor = UIColor.whiteColor()
        b.tintColor = UIColor.whiteColor()
        self.navigationItem.setLeftBarButtonItems([a,b], animated: true)
        //loadImage()
        //loadImageUzi()
        loadPhotos()
        
        
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker!.cameraCaptureMode = .Photo
            picker!.modalPresentationStyle = .FormSheet
        
            presentViewController(picker!, animated: true, completion: nil)
        }else{
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style:.Default, handler: nil)
                alert.addAction(ok)
                presentViewController(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func addPhoto(){
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker!.modalPresentationStyle = .FormSheet
        //picker?.interfaceOrientation
        presentViewController(picker!, animated: true, completion: nil)
    }
      func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let type: Int
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera)
        {
            UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        }
        
        choosedSegmentImages ? (type=0) : (type=1)
        let Date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: Date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newDate = calendar.dateFromComponents(components)
        choosedSegmentImages ? photos.append(Photo(image: chosenImage, date: newDate!, text: "")) : uzis.append(Photo(image: chosenImage, date: newDate!, text: "")) 
        dismissViewControllerAnimated(true, completion: nil)
        PhotoCollectionView.reloadData()
        
        savePhotos(chosenImage,Type: type)
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
        PhotoCell.photo.image = choosedSegmentImages ? photos[indexPath.row].image : uzis[indexPath.row].image
        return PhotoCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentPhoto = indexPath.row
    }
    
    func savePhotos(img: UIImage, Type: Int){
       
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        let text = Expression<String>("Text")
        let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
        let Date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: Date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newDate = calendar.dateFromComponents(components)
        if(Type == 0){
            let table = Table("Photo")
            
            try! db.run(table.insert(date <- "\(newDate!)", image <- Blob(bytes: imageData.datatypeValue.bytes), text <- ""))
        }else{
            let table = Table("Uzi")
            try! db.run(table.insert(date <- "\(newDate!)", image <- Blob(bytes: imageData.datatypeValue.bytes), text <- ""))
        }
        /*let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        if type == "photo" {
        
            let entity =  NSEntityDescription.entityForName("Image",
                                                        inManagedObjectContext:
                managedContext)
        
            let Photos = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext:managedContext)
        
            let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
        
            Photos.setValue(imageData, forKey: "photo")
        
            do {
                try Photos.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }else{
            let entity =  NSEntityDescription.entityForName("ImageUzi",
                                                            inManagedObjectContext:
                managedContext)
            
            let Photos = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext:managedContext)
            
            let imageData = NSData(data: UIImageJPEGRepresentation(img, 1.0)!)
            
            Photos.setValue(imageData, forKey: "photo")

            do {
                try Photos.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }*/
    }
 
    func loadPhotos(){
        photos.removeAll()
        uzis.removeAll()
        var table = Table("Photo")
        let date = Expression<String>("Date")
        let image = Expression<Blob>("Image")
        let type = Expression<Int64>("Type")
        let text = Expression<String>("Text")
        
        for i in try! db.prepare(table.select(date,image,type,text)) {
            let a = i[image] 
            let c = NSData(bytes: a.bytes, length: a.bytes.count)
            let b = i[date]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            print(dateFormatter.dateFromString(b)!)
            photos.append(Photo(image: UIImage(data: c)!, date: dateFormatter.dateFromString(b)!, text: i[text]))
        }

        table = Table("Uzi")
        for i in try! db.prepare(table.select(date,image,type,text)) {
            let a = i[image] 
            let c = NSData(bytes: a.bytes, length: a.bytes.count)
            let b = i[date]
            let dateFormatter = NSDateFormatter() 
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            uzis.append(Photo(image: UIImage(data: c)!, date: dateFormatter.dateFromString(b)!, text: i[text]))
        }
    }
    
    /*func loadImage(){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Image", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        photos.removeAll()
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for i in result {
                    let Images = i as! NSManagedObject
                    let tmpIMG = Images.valueForKey("photo") as! NSData
                    let img = UIImage(data: tmpIMG)
                    photos.append(img!)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func loadImageUzi(){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("ImageUzi", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        uzis.removeAll()
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for i in result {
                    let Images = i as! NSManagedObject
                    let tmpIMG = Images.valueForKey("photo") as! NSData
                    let img = UIImage(data: tmpIMG)
                    
                    uzis.append(img!)
                }
            }
        } catch {
            let fetchError = error as NSError
              print(fetchError)
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
}


