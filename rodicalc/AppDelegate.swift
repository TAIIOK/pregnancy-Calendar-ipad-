//
//  AppDelegate.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData
import YouTubePlayer
import Fabric
import Crashlytics

import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

let StrawBerryColor = UIColor(red: 206/255.0, green: 15/255.0, blue: 105/255.0, alpha: 1.0)
let BiruzaColor = UIColor(red: 0/255.0, green: 189/255.0, blue: 255/255.0, alpha: 1.0)
let userGrowth = "userGrowth"
var db = try! Connection()


extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}


func getVideoDetails() {
    for (var i = 0 ; i < videosDress.count ; i += 1 ) {
        
        let urlPath: String =  "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(videosDress[i])&format=json"
        
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
           // print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                    
                    let url = NSURL(string:  (jsonResult.valueForKey("thumbnail_url") as? String)! )!
                    let imageData = NSData(contentsOfURL: url)
                    let Image: UIImage! = UIImage(data:imageData!)
                    imagesfirst.insert(Image, atIndex: imagesfirst.count)
                    let name = jsonResult.valueForKey("title") as! String
                    videoTitlefirst.insert(name, atIndex: videoTitlefirst.count)
                    //print(imagesfirst.count)
                    //print(videoTitlefirst.count)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    
    
    for (var i = 0 ; i < videosGym.count ; i += 1 ) {
        
        let urlPath: String =  "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(videosGym[i])&format=json"
        
        
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            //print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                    
                    let url = NSURL(string:  (jsonResult.valueForKey("thumbnail_url") as? String)! )!
                    let imageData = NSData(contentsOfURL: url)
                    let Image: UIImage! = UIImage(data:imageData!)
                    imagessecond.insert(Image, atIndex: i)
                    let name = jsonResult.valueForKey("title") as! String
                    videoTitlesecond.insert(name, atIndex: i)
                    //print(imagessecond.count)
                    //print(videoTitlesecond.count)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
}


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = StrawBerryColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.BlackOpaque
        //UIBarButtonItem.appearance().title = ""
        createEditableCopyOfDatabaseIfNeeded()
        Fabric.with([Crashlytics.self])
        
    
        
        

        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            if #available(iOS 8.0, *) {
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil))
            } else {
                // Fallback on earlier versions
            }
        }
        
        /*
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil))

        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = "Accept"
        acceptAction.title = "Accept"
        acceptAction.activationMode = UIUserNotificationActivationMode.Background
        acceptAction.destructive = false
        acceptAction.authenticationRequired = false
        
        let declineAction = UIMutableUserNotificationAction()
        declineAction.identifier = "Decline"
        declineAction.title = "Decline"
        declineAction.activationMode = UIUserNotificationActivationMode.Background
        declineAction.destructive = false
        declineAction.authenticationRequired = false
        
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "adolf"
        category.setActions([acceptAction, declineAction], forContext: UIUserNotificationActionContext.Default)
        let categories = Set([category])
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound] , categories: categories )
        application.registerUserNotificationSettings(settings)
        */
  
        dispatch_async(dispatch_get_main_queue(), {
            NamesJSON()
            sections = AddSect(man)
            sectionsGirl = AddSect(woman)
            }
        )
        
        dispatch_async(dispatch_get_main_queue(), {
            NotificationJSON()
            }
        )

        dispatch_async(dispatch_get_main_queue(), {
            PointsJSON()
            }
        )
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            getVideoDetails()
        }

        FBSDKApplicationDelegate.sharedInstance()
        
        return true
    }


    private func createEditableCopyOfDatabaseIfNeeded() -> Void
    {
        // First, test for existence.
        // Override point for customization after application launch.
        let sourcePath = NSBundle.mainBundle().pathForResource("db", ofType: "sqlite")
        print(sourcePath)
        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let destinationPath = (doumentDirectoryPath as NSString).stringByAppendingPathComponent("db1.sqlite")
        //print(destinationPath)
        do {
            try NSFileManager().copyItemAtPath(sourcePath!, toPath: destinationPath)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {loadNotifi()}
        } catch _ {
            
        }
        db = try! Connection(destinationPath)
    }

    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("open share link ")
        print(url)
        if(url.absoluteString.containsString("vk54745842://"))
        {
        }
        else if(url.absoluteString.containsString("fb1731805480431829://"))
        {
       return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else{
        OKSDK.openUrl(url)
        }
        return true;
    }
    
    
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "cirkon.rodicalc" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("rodicalc", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    

    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification:")
        print(notification.alertBody)
        
        let  state = application.applicationState

        if (state == UIApplicationState.Active) {
            //["92","203","155","165","271","203","210","22","57","71","267","273","247","120"]

            
            if(notification.userInfo?.first != nil)
            {
               var key = notification.userInfo?.first?.1 as! String
                
                if(lolnotifies.contains(key)){
               var   alert =  UIAlertController(title: "", message: notification.alertBody, preferredStyle: .Alert)
                var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in alert.dismissViewControllerAnimated(true, completion: nil)  } )
                switch key {
                case "92":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=54&TID=1947&TITLE_SEO=1947&MID=18262#message18262")!) } )
                    alert.addAction(open)
                case "203":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=read&FID=8&TID=2873&TITLE_SEO=2873")!) } )
                    alert.addAction(open)
                case "155":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=54&TID=2457&TITLE_SEO=2457&MID=22350#message22350")!) } )
                    alert.addAction(open)
                case "165":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=54&TID=2457&TITLE_SEO=2457&MID=22350#message22350")!) } )
                    alert.addAction(open)
                case "271":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=read&FID=8&TID=3686&TITLE_SEO=3686")!) } )
                    alert.addAction(open)
                case "203":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=read&FID=8&TID=3686&TITLE_SEO=3686")!) } )
                    alert.addAction(open)
                case "210":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=39&TID=1221&TITLE_SEO=1221&MID=12419#message12419")!) } )
                    alert.addAction(open)
                case "22":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=42&TID=659&TITLE_SEO=659&MID=5299#message5299")!) } )
                    alert.addAction(open)
                case "57":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=42&TID=659&TITLE_SEO=659&MID=5299#message5299")!) } )
                    alert.addAction(open)
                case "71":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=42&TID=659&TITLE_SEO=659&MID=5299#message5299")!) } )
                    alert.addAction(open)
                case "267":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=39&TID=1221&TITLE_SEO=1221&MID=12419#message12419")!) } )
                    alert.addAction(open)
                case "273":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=read&FID=8&TID=3686&TITLE_SEO=3686")!) } )
                    alert.addAction(open)
                case "247":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=read&FID=38&TID=603&TITLE_SEO=603&PAGEN_1=2")!) } )
                    alert.addAction(open)
                case "120":
                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aist-k.com/forum/?PAGE_NAME=message&FID=31&TID=4325&TITLE_SEO=4325&MID=42669#message42669")!) } )
                    alert.addAction(open)
                default:
                   break
                    }
                    var close = UIAlertAction(title: "Закрыть", style: .Default, handler: { (_) in alert.dismissViewControllerAnimated(true, completion: nil)  } )
                    
                    alert.addAction(close)
                
                    
                    self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
                var   alert =  UIAlertController(title: "", message: notification.alertBody, preferredStyle: .Alert)
                var ok = UIAlertAction(title: "Закрыть", style: .Default, handler: { (_) in alert.dismissViewControllerAnimated(true, completion: nil)  } )
                
                if(notification.userInfo?.first != nil)
                {
                    var key = notification.userInfo?.first?.1 as! String
                    if(key == "-1"){
                        var read = UIAlertAction(title: "Читать далее", style: .Default, handler: { (_) in
                            /*
                             let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                             let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("ExperienceViewController") as UIViewController
                             let vc : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("MasterView") as UIViewController
                             self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                             var  ViewControllers =  [vc,initialViewControlleripad]
                             
                             self.window?.rootViewController?.presentViewController(initialViewControlleripad, animated: true, completion: nil)
                             */
                            
                        } )
                        alert.addAction(read)
                    }
                }
                
                
                alert.addAction(ok)
                
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            }
            
           else if(notification.alertBody!.contains("http://www.mama-fest.com/issledovaniya_akusherov_ginekologov/")){
                
                var   alert =  UIAlertController(title: "", message: notification.alertBody, preferredStyle: .Alert)
                    var ok = UIAlertAction(title: "Закрыть", style: .Default, handler: { (_) in alert.dismissViewControllerAnimated(true, completion: nil)  } )
                    
                    alert.addAction(ok)

                    var open = UIAlertAction(title: "Перейти", style: .Default, handler: { (_) in UIApplication.sharedApplication().openURL(NSURL(string: "http://www.mama-fest.com/issledovaniya_akusherov_ginekologov/")!) } )
                    alert.addAction(open)
                
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
           var   alert =  UIAlertController(title: "", message: notification.alertBody, preferredStyle: .Alert)
            var ok = UIAlertAction(title: "Закрыть", style: .Default, handler: { (_) in alert.dismissViewControllerAnimated(true, completion: nil)  } )
                
                if(notification.userInfo?.first != nil)
                {
                    var key = notification.userInfo?.first?.1 as! String
                    if(key == "-1"){
                var read = UIAlertAction(title: "Читать далее", style: .Default, handler: { (_) in
                /*
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("ExperienceViewController") as UIViewController
                    let vc : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("MasterView") as UIViewController
                    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                   var  ViewControllers =  [vc,initialViewControlleripad]
                
                self.window?.rootViewController?.presentViewController(initialViewControlleripad, animated: true, completion: nil)
                */
        
                } )
                     alert.addAction(read)
                    }
                }

                
            alert.addAction(ok)
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            

        }
        
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        
        completionHandler()
    }
    
}
