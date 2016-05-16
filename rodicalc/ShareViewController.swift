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
import Social

import MessageUI

class ShareViewController: UIViewController ,VKDelegate, MFMailComposeViewControllerDelegate {

    
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


    
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ShareMail(sender: AnyObject) {
        var mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self;
        if let filePath = NSBundle.mainBundle().pathForResource("0z", ofType: "jpg") {
            print("File path loaded.")
            
            if let fileData = NSData(contentsOfFile: filePath) {
                print("File data loaded.")
                mailComposerVC.addAttachmentData(fileData, mimeType: "image/jpg", fileName: "0z")
            }
        }
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            
        }
        
        print("шарю на мыло")
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
            
        case MFMailComposeResultCancelled:
            print("Cancelled mail")
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        case MFMailComposeResultSent:
            print("Message sent")
            self.dismissViewControllerAnimated(true, completion: nil)
            break
        default:
            break
        }
        
        
        
    }
    
    @IBAction func ShareVK(sender: AnyObject) {
        
            print("шарю во вконтактик")
        VK.start(appID: "4745842", delegate: self)
        VK.autorize()
        

    }
    
    @IBAction func ShareOK(sender: AnyObject) {
        

        var settings  = OKSDKInitSettings.init()
        settings.appKey = "CBAFLEFLEBABABABA"
        settings.appId = "1246999552"
        settings.controllerHandler = {
            return self;
        }
        
        OKSDK.initWithSettings(settings)


        
        OKSDK.authorizeWithPermissions(["VALUABLE_ACCESS","LONG_ACCESS_TOKEN","PHOTO_CONTENT"], success: {id in print(id)
            
          //  OKSDK.invokeMethod("users.getCurrentUser", arguments: [:], success: {data in print(data)}, error: {error in print(error)})
        
        OKSDK.invokeMethod("photosV2.getUploadUrl", arguments: [:], success: {
            data in print(data)
            
            
            let imageData = UIImageJPEGRepresentation(UIImage(named: "0z.jpg")!, 1)

         let photoId = (data["photo_ids"]as! NSArray)[0] as! String
         let boundary = "0xKhTmLbOuNdArY"
         let kNewLine = "\r\n"
         let urlPath = data["upload_url"] as! String
         let url: NSURL = NSURL(string: urlPath)!
         let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
          var data = NSMutableData()
            
            request1.HTTPMethod = "POST"
            request1.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            data.appendData("--\(boundary)\(kNewLine)".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData("Content-Disposition: form-data; name=\"0z.jpg\"; filename=\"0z.jpg\"\(kNewLine)".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData("Content-Type: image/jpg".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData("\(kNewLine)\(kNewLine)".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData(imageData!)
            data.appendData("\(kNewLine)".dataUsingEncoding(NSUTF8StringEncoding)!)
            data.appendData("--\(boundary)--".dataUsingEncoding(NSUTF8StringEncoding)!)
            request1.HTTPBody=data
            request1.timeoutInterval = 60
            request1.HTTPShouldHandleCookies=false
               let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        print("ASynchronous\(jsonResult)")
                        
                        var token = jsonResult.valueForKeyPath("photos.\(photoId).token") // ["photos"][photoId]["token"]

                        OKSDK.invokeMethod("photosV2.commit", arguments: ["photo_id":photoId,"token":token!,"comment":"Example Anon"], success:{ data in print(data)}, error: {error in print(error)})
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                
            })
            
      
            }
            , error: {error in print(error)})
        
            }, error: {error in print(error)
        })
        OKSDK.clearAuth()
    
        
    }
    
    @IBAction func ShareFB(sender: AnyObject) {
        print("шарю в фсб")
        
        var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText("")
        shareToFacebook.addImage(UIImage(named: "0z.jpg"))
        
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
        
        // если использовать апи )) для верисии ios 7
        
        /*
       var login = FBSDKLoginManager()
        
        login.logInWithReadPermissions(["public_profile"],
                                                     fromViewController:self,
            handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
                if ((error) != nil) {
                    NSLog("Process error");
                } else if (result.isCancelled) {
                    NSLog("Cancelled");
                } else {
                    NSLog("Logged in");
   
                }
                
        })
        
        
       var res =  FBSDKLoginManager.logOut(login)
        

        print(res)
        */
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
