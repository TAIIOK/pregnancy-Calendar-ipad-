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
        
        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var buttonSpasm: UIButton!
        @IBOutlet weak var collectionView: UICollectionView!
        
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
            self.collectionView.setContentOffset(CGPoint.zero, animated: false)
            self.dict.removeAll()
            clearSpasm()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.collectionView.registerNib(UINib(nibName: "NumberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: numberCellIdentifier)
            self.collectionView.registerNib(UINib(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: contentCellIdentifier)
        }
        
        private func spasmStart() {
            self.label.text = "0"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerUpdate", userInfo: NSDate(), repeats: true)
            self.tmp = tmpSpasm()
            self.tmp.start = NSDate().toFormattedTimeString()
        }
        
        private func spasmStop() {
            self.tmp.stop = NSDate().toFormattedTimeString()
            self.tmp.duration = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
            self.dict.append(tmp)
            self.collectionView.reloadData()
            self.scrollToBottom()
            self.timer.invalidate()
            self.label.text = ""
            saveSpasm(tmp)
        }
        
        func timerUpdate() {
            let elapsed = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
            self.label.text = String(format: "%.0f", elapsed)
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
                        if interval < 60 {
                            contentCell.contentLabel.text = String(format: "%.0f", interval!) + " сек."
                        }else {
                            contentCell.contentLabel.text = String(format: "%.0f", interval!/60) + " мин."
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
                    var temp = tmpSpasm()
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