//
//  PhotosTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let a = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "openCamera")
        let b = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhoto")
        a.tintColor = UIColor.whiteColor()
        b.tintColor = UIColor.whiteColor()
        self.navigationItem.setLeftBarButtonItems([a,b], animated: true)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func openCamera(){
        //var picker: UIImagePickerController
        //picker.delegate = self;
        
        
        /*if([UIImagePickerController isSourceTypeAvailable UIImagePickerControllerSourceType.Camera])
        {
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            self
        }*/
    }
    
    func addPhoto(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
