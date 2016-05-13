//
//  ShareViewController.swift
//  rodicalc
//
//  Created by deck on 04.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

import SwiftyVK


class ShareViewController: UIViewController ,VKDelegate {

    
    func vkAutorizationFailed(error: VK.Error) {
        print("Autorization failed with error: \n\(error)")
    }
    
    func vkWillAutorize() -> [VK.Scope] {
        let scope = [VK.Scope.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
        
        return  scope
    }
    
    func vkDidAutorize(parameters: Dictionary<String, String>) {
        
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("0z", ofType: "jpg")!)
        //Crete media object to upload

        let media = Media(imageData: data!, type: .JPG)

        VK.API.Upload.Photo.toWall.toUser(media, userId: parameters["user_id"]!).send(method: HTTPMethods.GET , success: {response in print(response)

            let name = response.arrayObject![0] as! NSDictionary
            
           var string = "photo" + parameters["user_id"]! as String + "_" + String(name.valueForKey("id")!)
          
            print(string)
            
            let mass = [VK.Arg.userId : parameters["user_id"]! , VK.Arg.friendsOnly : "0" , VK.Arg.message : "risov privet " , VK.Arg.attachments : string + "," + string ]
            let req = VK.API.Wall.post(mass).send(method: HTTPMethods.GET , success: {response in print(response)}, error: {error in print(error)})
            
            
                       }, error: {error in print(error)})
    
      
    }

    func vkDidUnautorize() {
        
    }
    
    func vkTokenPath() -> (useUserDefaults: Bool, alternativePath: String) {
        return (true, "")
    }
    
    func vkWillPresentView() -> UIViewController {
     
        return self
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
    //view.opaque = false
        // Do any additional setup after loading the view.
    }

    func complete(){
        print("save")
   
        self.performSegueWithIdentifier("", sender: nil)
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ShareMail(sender: AnyObject) {
        print("шарю на мыло")
    }
    
    @IBAction func ShareVK(sender: AnyObject) {
        
            print("шарю во вконтактик")
        VK.start(appID: "4745842", delegate: self)
        VK.autorize()
        

    }
    
    @IBAction func ShareOK(sender: AnyObject) {
        print("шарю в одноклассники")
    }
    
    @IBAction func ShareFB(sender: AnyObject) {
        print("шарю в фсб")
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
