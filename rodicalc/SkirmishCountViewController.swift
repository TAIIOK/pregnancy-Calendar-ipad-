//
//  SkirmishCountTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//


//class SkirmishCountViewController: UIViewController {

import UIKit
import CoreData

enum State {
    case Watching
    case Stop
}

extension NSDate {
    func toFormattedTimeString() -> String {
        let today = NSDate()
        let gregorian = NSCalendar.currentCalendar()
        
        if #available(iOS 8.0, *) {
            let hour = gregorian.component(.Hour, fromDate: today)
        
        let hourStr = (hour < 10 ? "0" : "") + String(hour) + ":"
        
        let minute = gregorian.component(.Minute, fromDate: today)
        let minuteStr = (minute < 10 ? "0" : "") + String(minute) + ":"
        
        let second = gregorian.component(.Second, fromDate: today)
        let secondStr = (second < 10 ? "0" : "") + String(second)
        
        return hourStr + minuteStr + secondStr
        } else {
            // Fallback on earlier versions
        }
        return "nil"
    }
}

class tmpSpasm {
    var start = ""
    var duration = NSTimeInterval()
    var stop = ""
}

    class SkirmishCountViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        let numberCellIdentifier = "NumberCellIdentifier"
        let contentCellIdentifier = "ContentCellIdentifier"

        var people = [NSManagedObject]()
        var timer = NSTimer()
        var tmp = tmpSpasm()
        var state = State.Stop
        var dict: [tmpSpasm] = []
        
        let progressLine = CAShapeLayer()
        
        @IBOutlet weak var textlabel: UILabel!
        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var buttonSpasm: UIButton!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var watch: UIImageView!
        @IBOutlet weak var animView: UIView!
        
        @IBAction func buttonSpasms(sender: AnyObject) {
            if self.state == .Stop {
                self.buttonSpasm.setTitle("УФ, ЗАКОНЧИЛАСЬ", forState: .Normal)
                self.state = .Watching
                self.spasmStart()
            } else {
                self.buttonSpasm.setTitle("ОЙ, СХВАТКА", forState: .Normal)
                self.state = .Stop
                self.spasmStop()
            }
        }
        @IBAction func buttonTrash(sender: AnyObject) {
            if self.dict.count > 0{
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Вы уверены, что хотите удалить данные?", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                //Create and an option action
                let nextAction: UIAlertAction = UIAlertAction(title: "Очистить", style: .Destructive) { action -> Void in
                    //Do some other stuff
                    self.collectionView.setContentOffset(CGPoint.zero, animated: false)
                    self.dict.removeAll()
                    self.clearSpasm()
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
                actionSheetController.addAction(nextAction)
                
                //Present the AlertController
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.label.textAlignment = .Center
            self.collectionView.registerNib(UINib(nibName: "NumberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: numberCellIdentifier)
            self.collectionView.registerNib(UINib(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: contentCellIdentifier)
        }
        
        func animWatch(){
            // set up some values to use in the curve
            let ovalStartAngle = CGFloat(270.01 * M_PI/180)
            let ovalEndAngle = CGFloat(270.009 * M_PI/180)
            let ovalRect = CGRectMake(17, 22, 85, 85)//(110, 605, 100, 100)
            
            // create the bezier path
            let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)),
                                        radius: CGRectGetWidth(ovalRect) / 2,
                                        startAngle: ovalStartAngle,
                                        endAngle: ovalEndAngle, clockwise: true)
            
            /*ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)),
                radius: CGRectGetWidth(ovalRect) / 2,
                startAngle: ovalStartAngle,
                endAngle: ovalEndAngle, clockwise: true)*/
            
            /*ovalPath.moveToPoint(CGPoint(x: 60, y: 30))
            ovalPath.addLineToPoint(CGPoint(x: 60, y: 20))
            
            ovalPath.moveToPoint(CGPoint(x: 60, y: 110))
            ovalPath.addLineToPoint(CGPoint(x: 60, y: 100))*/
            // create an object that represents how the curve
            // should be presented on the screen
            progressLine.path = ovalPath.CGPath
            progressLine.strokeColor = StrawBerryColor.CGColor
            progressLine.fillColor = UIColor.clearColor().CGColor
            progressLine.lineWidth = 12.0
        
            //progressLine.lineCap = kCALineCapRound
            progressLine.lineDashPattern = [4,18,4,18,4,18,4,18,4,18,4,18,4,18,4,18,4,18,4,18,4,20]
            
            // add the curve to the screen
            self.watch.layer.addSublayer(progressLine)
            
            // create a basic animation that animates the value 'strokeEnd'
            // from 0.0 to 1.0 over 3.0 seconds
            let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            animateStrokeEnd.duration = 60.0
            animateStrokeEnd.fromValue = 0.0
            animateStrokeEnd.toValue = 1.0
            animateStrokeEnd.repeatCount = 2
            // add the animation
            progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        }
        
        private func spasmStart() {
            self.label.text = "0"
            self.textlabel.text = "СЕКУНД"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerUpdate", userInfo: NSDate(), repeats: true)
            self.tmp = tmpSpasm()
            self.tmp.start = NSDate().toFormattedTimeString()
            animWatch()
            watch.highlighted = true
        }
        
        private func spasmStop() {
            self.tmp.stop = NSDate().toFormattedTimeString()
            self.tmp.duration = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
            self.dict.append(tmp)
            self.collectionView.reloadData()
            self.scrollToBottom()
            self.timer.invalidate()
            self.label.text = ""
            self.textlabel.text = ""
            saveSpasm(tmp)
            progressLine.removeFromSuperlayer()
            watch.highlighted = false
        }
        
        func timerUpdate() {
            let elapsed = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
            let sek: Int = Int(Double(elapsed+0.1))
            var txt = ""
            if sek%10 == 1{
                txt = "СЕКУНДА"
            }else if sek%10 == 2 || sek%10 == 3 || sek%10 == 4 {
                txt = "СЕКУНДЫ"
            }else{
                txt = "СЕКУНД"
            }
            
            if sek > 10 && sek < 15{
                txt = "СЕКУНД"
            }
            if sek == 111 {
                txt = "СЕКУНД"
            }
            
            self.label.text = String(format: "%.0f", elapsed)
            self.textlabel.text = txt
            
            if elapsed > 119 {
                self.label.text = ""
                progressLine.removeFromSuperlayer()
                if #available(iOS 8.0, *) {
                    let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Таймер остановлен", preferredStyle: .Alert)
                    
                    //Create and add the Cancel action
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Ок", style: .Default) { action -> Void in
                        //Do some stuff
                        let stopwatch = self.storyboard?.instantiateViewControllerWithIdentifier("StopWatch")
                        self.splitViewController?.showDetailViewController(stopwatch!, sender: self)
                    }
                    actionSheetController.addAction(cancelAction)
                    
                    //Present the AlertController
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }

            }
        }
        
        func scrollToBottom() {
            // don't look there
            let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 5) - 1
            let lastItemIndex = NSIndexPath(forItem: item, inSection: self.dict.count)
            self.collectionView.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: .Bottom, animated: true)
        }
        
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return self.dict.count + 1
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let numberCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(numberCellIdentifier, forIndexPath: indexPath) as! NumberCollectionViewCell
                    numberCell.numberLabel.text = "№"
                    numberCell.numberLabel.font = .boldSystemFontOfSize(13)
                    return numberCell
                } else if indexPath.row == 1 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.text = "НАЧАЛАСЬ"
                    contentCell.contentLabel.font = .boldSystemFontOfSize(13)
                    return contentCell
                } else if indexPath.row == 2 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.text = "ДЛИТЕЛЬНОСТЬ"
                    contentCell.contentLabel.font = .boldSystemFontOfSize(13)
                    return contentCell
                } else if indexPath.row == 3 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.text = "ЗАКОНЧИЛАСЬ"
                    contentCell.contentLabel.font = .boldSystemFontOfSize(13)
                    return contentCell
                } else {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.text = "ПРОМЕЖУТОК"
                    contentCell.contentLabel.font = .boldSystemFontOfSize(13)
                    return contentCell
                }
            } else {
                if indexPath.row == 0 {
                    let numberCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(numberCellIdentifier, forIndexPath: indexPath) as! NumberCollectionViewCell
                    numberCell.numberLabel.font = .systemFontOfSize(14)
                    numberCell.numberLabel.text = String(indexPath.section)
                    return numberCell
                } else if indexPath.row == 1 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.font = .systemFontOfSize(14)
                    contentCell.contentLabel.text = self.dict[indexPath.section - 1].start
                    return contentCell
                } else if indexPath.row == 2 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.font = .systemFontOfSize(14)
                    contentCell.contentLabel.text = String(format: "%.0f", self.dict[indexPath.section - 1].duration) + " сек."
                    return contentCell
                } else if indexPath.row == 3 {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.font = .systemFontOfSize(14)
                    contentCell.contentLabel.text = self.dict[indexPath.section - 1].stop
                    return contentCell
                } else {
                    let contentCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                    contentCell.contentLabel.font = .systemFontOfSize(14)
                    contentCell.contentLabel.text = "_"
                    
                    if(indexPath.section > 1){
                        
                        let timeStart = self.dict[indexPath.section-1].start//"2015-10-06T15:42:34Z"
                        let timeStop = self.dict[indexPath.section-2].stop
                    
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        
                        let start = dateFormatter.dateFromString(timeStart)
                        let stop = dateFormatter.dateFromString(timeStop)
                        let interval = start?.timeIntervalSinceDate(stop!)
                        if interval < 0 {
                            contentCell.contentLabel.text = "> 1 дня"
                        }else if interval < 60 {
                            contentCell.contentLabel.text = String(format: "%.0f", interval!) + " сек."
                        }else if interval < 3600 {
                            contentCell.contentLabel.text = String(format: "%.0f", interval!/60) + " мин."
                        }else {
                            contentCell.contentLabel.text = String(format: "%.0f", interval!/3600) + " час."
                        }
                        
                    }
                    return contentCell
                }
            }
        }
        
        func saveSpasm(temp: tmpSpasm) {

            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let entity =  NSEntityDescription.entityForName("Spasms",
                inManagedObjectContext:
                managedContext)
            
            let Spasms = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            Spasms.setValue(temp.start, forKey: "start")
            Spasms.setValue(temp.stop, forKey: "stop")
            Spasms.setValue(temp.duration, forKey: "duration")
            do {
                try Spasms.managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        
        func clearSpasm(){
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            // Initialize Fetch Request
            let fetchRequest = NSFetchRequest()
            
            // Create Entity Description
            let entityDescription = NSEntityDescription.entityForName("Spasms", inManagedObjectContext:managedContext)
            
            fetchRequest.entity = entityDescription
            
            do {
                let result = try managedContext.executeFetchRequest(fetchRequest)
                
                for i in result{
                    managedContext.deleteObject(i as! NSManagedObject)}
                
                do {
                    try managedContext.save()
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }

        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)

            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext

            // Initialize Fetch Request
            let fetchRequest = NSFetchRequest()
            
            // Create Entity Description
            let entityDescription = NSEntityDescription.entityForName("Spasms", inManagedObjectContext:managedContext)
            
            fetchRequest.entity = entityDescription
            
            do {
                let result = try managedContext.executeFetchRequest(fetchRequest)
                
                if (result.count > 0) {
                    for i in result {
                    let Spasms = i as! NSManagedObject
                    let temp = tmpSpasm()
                    temp.start = Spasms.valueForKey("start") as! String
                    temp.stop = Spasms.valueForKey("stop") as! String
                    temp.duration = Spasms.valueForKey("duration") as! NSTimeInterval
                        dict.append(temp)}
                }
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        
        override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            self.collectionView.collectionViewLayout.prepareLayout()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
}
