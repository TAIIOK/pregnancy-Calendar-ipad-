//
//  DoctorViewController.swift
//  rodicalc
//
//  Created by deck on 27.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit


class Drugs: NSObject {
    var name: String
    var hour: Int
    var minute: Int
    var start: NSDate
    var end: NSDate
    var interval: Int
    var isRemind: Bool
    var cellType: Int
    
    init(name: String, hour: Int, minute: Int, start: NSDate, end: NSDate, interval: Int, isRemind: Bool, cellType: Int) {
        self.name = name
        self.hour = hour
        self.minute = minute
        self.start = start
        self.end = end
        self.interval = interval
        self.isRemind = isRemind
        self.cellType = cellType
        super.init()
    }
}


let Interval = ["Никогда","Каждый день","Каждую неделю","Раз в 2 недели","Каждый месяц","Каждый год"]
var StartORend = -1 //0 - start 1 - end
var curDate = NSDate()
class DrugsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate , UIGestureRecognizerDelegate {
    
    var isKeyboard = false
    
    func keyboardWillShow(notification: NSNotification) {
        if !isKeyboard{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height/2
                isKeyboard = true
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if isKeyboard{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y += keyboardSize.height/2
                isKeyboard = false
            }
        }
    }
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var NoteTitle: UILabel!
    @IBOutlet weak var tbl: UITableView!

    var drugs = [Drugs]()
    
    var arrayForBool : NSMutableArray = NSMutableArray()

    var shouldShowDaysOut = true
    var animationFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = .clearColor()
        
        var nibName = UINib(nibName: "DrugsViewCell", bundle:nil)
        self.tbl.registerNib(nibName, forCellReuseIdentifier: "DrugsViewCell")
        
         nibName = UINib(nibName: "addCell", bundle:nil)
        self.tbl.registerNib(nibName, forCellReuseIdentifier: "addCell")
        
        //self.title = CVDate(date: NSDate()).globalDescription
        NoteTitle.text = notes[NoteType]
        if selectedNoteDay != nil {
            self.calendarView.toggleViewWithDate(selectedNoteDay.date.convertedDate()!)
        }else{
            let date = NSDate()
            self.calendarView.toggleViewWithDate(date)
        }

        arrayForBool.addObject("1")
        loadNotes()
        for(var i = 0 ; i<drugs.count ;i++)
        {
            arrayForBool.addObject("0")
        }

        
        self.presentedDateUpdated(CVDate(date: NSDate()))
    }
    
    func loadNotes(){
        print("load ",selectedNoteDay.date.convertedDate()!)
        drugs.removeAll()
        let table = Table("MedicineTake")
        let name = Expression<String>("Name")
        let start = Expression<String>("Start")
        let end = Expression<String>("End")
        let isRemind = Expression<Bool>("isRemind")
        let hour_ = Expression<Int>("Hour")
        let minute_ = Expression<Int>("Minute")
        let interval_ = Expression<Int>("Interval")

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newcurDate = calendar.dateFromComponents(components)
        
        
        for i in try! db.prepare(table.select(name,start,end,isRemind,hour_,minute_,interval_)) {
            //let b = i[date]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            let componentsS = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(i[start])!)
            let componentsE = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(i[end])!)
            componentsS.hour = 00
            componentsS.minute = 00
            componentsS.second = 00
            let newDateS = calendar.dateFromComponents(componentsS)
            componentsE.hour = 00
            componentsE.minute = 00
            componentsE.second = 00
            let newDateE = calendar.dateFromComponents(componentsE)
            let a = newcurDate?.compare(newDateS!)
            let b = newcurDate?.compare(newDateE!)
            if (a == NSComparisonResult.OrderedDescending || a == NSComparisonResult.OrderedSame) && (b == NSComparisonResult.OrderedAscending || b == NSComparisonResult.OrderedSame) {
                drugs.append(Drugs(name: i[name], hour: i[hour_], minute: i[minute_], start: dateFormatter.dateFromString(i[start])!, end: dateFormatter.dateFromString(i[end])!, interval: i[interval_], isRemind: i[isRemind], cellType: 0))
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 0 && indexPath.section == 0  {
            
            let curDate = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let componentsCurrent = calendar.components([.Hour , .Minute , .Second], fromDate: curDate)

            let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
            components.hour = componentsCurrent.hour
            components.minute = componentsCurrent.minute
            components.second = componentsCurrent.second
            let newDate = calendar.dateFromComponents(components)
            view.endEditing(true)
            drugs.append(Drugs(name: "", hour: 0, minute: 0, start: NSDate(), end: NSDate(), interval: 0, isRemind: false, cellType: 0))
            
            arrayForBool.removeAllObjects()
            arrayForBool.addObject("1")
            for(var i = 0 ; i<drugs.count-1 ;i++)
            {
                arrayForBool.addObject("0")
            }
            arrayForBool.addObject("1")

            
            tbl.reloadData()
            let range = NSMakeRange(drugs.count, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tbl.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            let headerview = tbl.viewWithTag(drugs.count) as? DoctorHeader
            headerview?.setopen(true)
            headerview?.changeFields()
            
            //let range = NSMakeRange(doctors.count, 1)
            //let sectionToReload = NSIndexSet(indexesInRange: range)
            //self.tbl.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            
            headerview?.doctornameText.editing == true
            headerview?.doctornameText.selected == true
            headerview?.doctornameText.becomeFirstResponder();
        }

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrayForBool.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true)
        {
            return 1
        }
        return 0;
    }
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        
        return 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 40
        }
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true){
            return 120
        }
        
        return 2;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        
        let view = DoctorHeader(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        view.setupView(section, doctor: drugs[section-1].name, time: "\(firstComponent1[drugs[section-1].hour]):\(secondComponent1[drugs[section-1].minute])")
        
        view.tag = section
        
        headerView.tag = section
        
        let imageTapped = UITapGestureRecognizer (target: self, action:"enablenotification:")
        imageTapped.numberOfTapsRequired = 1
        imageTapped.numberOfTouchesRequired = 1
        imageTapped.delegate = self
        
   
        view.imageView.addGestureRecognizer(imageTapped)
      
        let delimageTapped = UITapGestureRecognizer (target: self, action:"deletenote:")
        delimageTapped.numberOfTapsRequired = 1
        delimageTapped.numberOfTouchesRequired = 1
        delimageTapped.delegate = self
        
        
        view.deletecross.addGestureRecognizer(delimageTapped)
        
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        view.addGestureRecognizer(headerTapped)
        
        if (drugs[section-1].isRemind == true){
            view.changeImage()
        }
        
        
        view.doctorname.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "lblTapped:")
        tapGesture.numberOfTapsRequired = 1
        view.doctorname.addGestureRecognizer(tapGesture)
        
        
        let longtap = UILongPressGestureRecognizer (target: self, action:"longtap:")
        longtap.minimumPressDuration = 1.2
        longtap.delegate = self
        
        view.doctorname.addGestureRecognizer(longtap)

        
        return view
    }
    
    func longtap(gesture:UILongPressGestureRecognizer){
        
        if gesture.state == .Began {
            //Create the AlertController
            if #available(iOS 8.0, *) {
                let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Дублировать выбранное лекарство?", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                //Create and an option action
                let nextAction: UIAlertAction = UIAlertAction(title: "Да", style: .Default) { action -> Void in
                    //Do some other stuff
                    if let cellContentView = gesture.view {
                        let tappedPoint = cellContentView.convertPoint(cellContentView.bounds.origin, toView: self.tbl)
                        for i in 1..<self.tbl.numberOfSections  {
                            let sectionHeaderArea = self.tbl.rectForHeaderInSection(i)
                            if CGRectContainsPoint(sectionHeaderArea, tappedPoint) {
                                print("longtap:: \(i)")
                                self.drugs.append(Drugs(name: self.drugs[i-1].name, hour: self.drugs[i-1].hour, minute: self.drugs[i-1].minute, start: self.drugs[i-1].start, end: self.drugs[i-1].end, interval: self.drugs[i-1].interval, isRemind: self.drugs[i-1].isRemind, cellType: 0))
                                self.arrayForBool.addObject("0")
    
                                self.tbl.reloadData()
                                break
                            }
                        }
                    }
                }
                actionSheetController.addAction(nextAction)
                
                //Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }

        }
    }
    
    func deletenote(gesture:UIGestureRecognizer){
        //Create the AlertController
        if #available(iOS 8.0, *) {
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Удалить выбранное лекарство?", preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "Да", style: .Default) { action -> Void in
                //Do some other stuff
                if let cellContentView = gesture.view {
                    let tappedPoint = cellContentView.convertPoint(cellContentView.bounds.origin, toView: self.tbl)
                    for i in 1..<self.tbl.numberOfSections  {
                        let sectionHeaderArea = self.tbl.rectForHeaderInSection(i)
                        if CGRectContainsPoint(sectionHeaderArea, tappedPoint) {
                            print("delete note:: \(i)")
                            self.drugs.removeAtIndex(i-1)
                            self.arrayForBool.removeObjectAtIndex(i)
                            self.tbl.reloadData()
                            break
                        }
                    }
                }            }
                actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    func lblTapped(recognizer: UITapGestureRecognizer){
        if let cellContentView = recognizer.view {
            let tappedPoint = cellContentView.convertPoint(cellContentView.bounds.origin, toView: tbl)
            for i in 0..<tbl.numberOfSections {
                let sectionHeaderArea = tbl.rectForHeaderInSection(i)
                if CGRectContainsPoint(sectionHeaderArea, tappedPoint) {
                    print("tapped on section header:: \(i)")
                    
                    let headerview = tbl.viewWithTag(i) as? DoctorHeader
                    headerview?.changeFields()
                    //tbl.reloadSections(NSIndexSet(index: i), withRowAnimation: .None)
                    
                    
                }
            }
        }
    }

    
    
    func enablenotification(gesture:UIGestureRecognizer){
        if let cellContentView = gesture.view {
            let tappedPoint = cellContentView.convertPoint(cellContentView.bounds.origin, toView: tbl)
            for i in 1..<tbl.numberOfSections  {
                let sectionHeaderArea = tbl.rectForHeaderInSection(i)
                if CGRectContainsPoint(sectionHeaderArea, tappedPoint) {
                    print("tapped on section header:: \(i)")
                    
                    if(drugs[i-1].isRemind == true){
                    drugs[i-1].isRemind = false
                        
                        let notifiday = drugs[i-1].start
                        
                        for(var j = 0 ;j <= notifiday.daysFrom(drugs[i-1].end); j++)
                        {
                        cancelLocalNotification("\(addDaystoGivenDate(drugs[i-1].start, NumberOfDaysToAdd: j, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0))")
                        }

                        
                    }
                    else if(drugs[i-1].isRemind == false){
                        drugs[i-1].isRemind = true
                        
                        let notifiday = drugs[i-1].start
                        
                        for(var j = 0 ;j <= notifiday.daysFrom(drugs[i-1].end); j++)
                        {
                            scheduleNotification(calculateDate(addDaystoGivenDate(drugs[i-1].start, NumberOfDaysToAdd: j, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0), before: -1 , after: drugs[i-1].cellType), notificationTitle:"Время приема лекарства \(drugs[i-1].name)" , objectId: "\(calculateDate(addDaystoGivenDate(drugs[i-1].start, NumberOfDaysToAdd: j, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0), before: -1, after: drugs[i-1].cellType))")
                        }
                        
        
                    }
                    tbl.reloadSections(NSIndexSet(index: i), withRowAnimation: .None)
                    break
                }
            }
        }
    }
    
    
    
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        print("Tapping working")
        print(recognizer.view?.tag)
        
          //  var header = tbl.headerViewForSection((recognizer.view?.tag)!) as? DoctorHeader
   
        
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0 && indexPath.section != 0) {
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            print(collapsed)
            collapsed = !collapsed;
            print(collapsed)

            save()
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)

            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tbl.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            let header = tbl?.viewWithTag(indexPath.section) as? DoctorHeader
            if(collapsed == true){
                header!.setopen(true)
            }
            else if (collapsed == false){
                header!.setopen(false)
            }
            header!.changeFields()
        }
        
    }
    
    
    
    func loadtime(recognizer: UITapGestureRecognizer){
        
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DrugsTableViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("TimeTable") 
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                let location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                
                popover.sourceView = swipedCell.timebutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                hour = drugs[currentRec-1].hour
                minute = drugs[currentRec-1].minute
                presentViewController(vc, animated: true, completion:nil)
            }
        }
    }
    
    func loadnotifilist(recognizer: UITapGestureRecognizer){
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DrugsTableViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("DrugsTable") 
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                let location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                popover.sourceView = swipedCell.notifibutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                curRemindType = drugs[currentRec-1].interval
                presentViewController(vc, animated: true, completion:nil)
            }
        }
    }

    func loadstartdate(recognizer: UITapGestureRecognizer){
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DrugsTableViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("DatePickerView") 
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                let location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                
                popover.sourceView = swipedCell.timebutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                curDate = drugs[currentRec-1].start
                StartORend = 0
                presentViewController(vc, animated: true, completion:nil)
            }
        }
    }

    func loadenddate(recognizer: UITapGestureRecognizer){
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DrugsTableViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("DatePickerView") 
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                let location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                popover.sourceView = swipedCell.timebutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                curDate = drugs[currentRec-1].end
                StartORend = 1
                presentViewController(vc, animated: true, completion:nil)
            }
        }
    }

    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("addCell", forIndexPath: indexPath)
            cell.backgroundColor = .clearColor()
            cell.selectionStyle = .None
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("DrugsViewCell", forIndexPath: indexPath) as! DrugsTableViewCell
        
        if(indexPath.section != 0)
        {
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
            
        }
        else{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            var selectedDate = dateFormatter.stringFromDate(drugs[indexPath.section-1].start)
            cell.timebutton.setTitle("\(firstComponent1[drugs[indexPath.section-1].hour]):\(secondComponent1[drugs[indexPath.section-1].minute])", forState: .Normal)
            cell.startbutton.setTitle(dateFormatter.stringFromDate(drugs[indexPath.section-1].start), forState: .Normal)
            cell.stopbutton.setTitle(dateFormatter.stringFromDate(drugs[indexPath.section-1].end), forState: .Normal)
            cell.notifibutton.setTitle(Interval[drugs[indexPath.section-1].interval], forState: .Normal)
            var notifiTapped = UITapGestureRecognizer (target: self, action:"loadnotifilist:")
            cell.notifibutton.addGestureRecognizer(notifiTapped)
            notifiTapped = UITapGestureRecognizer (target: self, action:"loadstartdate:")
            cell.startbutton.addGestureRecognizer(notifiTapped)
            notifiTapped = UITapGestureRecognizer (target: self, action:"loadenddate:")
            cell.stopbutton.addGestureRecognizer(notifiTapped)
            notifiTapped = UITapGestureRecognizer (target: self, action:"loadtime:")
            cell.timebutton.addGestureRecognizer(notifiTapped)
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        }
        return cell
    }
    
    @IBAction func UpdateSectionTime(segue:UIStoryboardSegue) {
        print("Update TIME")
        self.dismissViewControllerAnimated(true, completion: nil)
        //cancelLocalNotification("\(drugs[currentRec-1].date)")
        let notifiday = drugs[currentRec-1].start
        print(drugs[currentRec-1].start, drugs[currentRec-1].end)
        for(var i = 0 ;i <= notifiday.daysFrom(drugs[currentRec-1].end); i++)
        {
            cancelLocalNotification("\(addDaystoGivenDate(drugs[currentRec-1].start, NumberOfDaysToAdd: i, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0))")
        }
        

    
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: drugs[currentRec-1].start)
        components.hour = hour
        components.minute = minute
        components.second = 00
        let newDate = calendar.dateFromComponents(components)
        drugs[currentRec-1].start = newDate!
    
        
        drugs[currentRec-1].hour = hour
        drugs[currentRec-1].minute = minute
        
        if(drugs[currentRec-1].isRemind){
            
            let notifiday = drugs[currentRec-1].start
            
            for(var i = 0 ;i <= notifiday.daysFrom(drugs[currentRec-1].end); i++)
            {
                scheduleNotification(calculateDate(addDaystoGivenDate(drugs[currentRec-1].start, NumberOfDaysToAdd: i, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0), before: -1 , after: drugs[currentRec-1].cellType), notificationTitle:"Время приема лекарства \(drugs[currentRec-1].name)" , objectId: "\(calculateDate(addDaystoGivenDate(drugs[currentRec-1].start, NumberOfDaysToAdd: i, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0), before: -1, after: drugs[currentRec-1].cellType))")
            }
        }
        //tbl.reloadSections(NSIndexSet(index: currentRec), withRowAnimation: .None)
        
        let headerview = tbl.viewWithTag(currentRec-1) as? DoctorHeader
        headerview?.setopen(true)
        headerview?.changeFields()
        
        tbl.reloadData()
    }
    
    @IBAction func UpdateSection(segue:UIStoryboardSegue) {
        print("Update Notifi")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        /*
        cancelLocalNotification("\(drugs[currentRec-1].date)")
        
        if(drugs[currentRec-1].isRemind){
            scheduleNotification(calculateDate(drugs[currentRec-1].date, before: drugs[currentRec-1].remindType , after: changeRemindInCurRec), notificationTitle:"У вас посещение врача \(drugs[currentRec-1].name)" , objectId: "\(calculateDate(drugs[currentRec-1].date, before: drugs[currentRec-1].remindType , after: changeRemindInCurRec))")
        }
        */
        drugs[currentRec-1].interval = changeRemindInCurRec
        //tbl.reloadSections(NSIndexSet(index: currentRec), withRowAnimation: .None)
        
     
        
        tbl.reloadData()
    }
    
    func addDaystoGivenDate(baseDate: NSDate, NumberOfDaysToAdd: Int, NumberOfHoursToAdd: Int, NumberOfMinuteToAdd: Int) -> NSDate
    {
        let dateComponents = NSDateComponents()
        let CurrentCalendar = NSCalendar.currentCalendar()
        let CalendarOption = NSCalendarOptions()
        
        dateComponents.day = NumberOfDaysToAdd
        dateComponents.hour = NumberOfHoursToAdd
        dateComponents.minute = NumberOfMinuteToAdd
        let newDate = CurrentCalendar.dateByAddingComponents(dateComponents, toDate: baseDate, options: CalendarOption)
        return newDate!
    }
    
    func calculateDate(date : NSDate,before : Int ,after : Int) -> NSDate
    {

        var newdate = NSDate()
        
        switch before {
        case 0:
            return date
        case 1:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: -5)
        case 2:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: -15)
        case 3:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: -30)
        case 4:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: -1, NumberOfMinuteToAdd: 0)
        case 5:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: -2, NumberOfMinuteToAdd: 0)
        case 6:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: -1, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0)
        case 7:
            newdate = addDaystoGivenDate(date, NumberOfDaysToAdd: -7, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0)
        default:
            return date
        }
        
        switch after {
        case 0:
            return newdate
        case 1:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 5)
        case 2:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 15)
        case 3:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 30)
        case 4:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 1, NumberOfMinuteToAdd: 0)
        case 5:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 0, NumberOfHoursToAdd: 2, NumberOfMinuteToAdd: 0)
        case 6:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 1, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0)
        case 7:
            return addDaystoGivenDate(newdate, NumberOfDaysToAdd: 7, NumberOfHoursToAdd: 0, NumberOfMinuteToAdd: 0)
        default:
            break
        }
        
        return date
        
    }

    
    @IBAction func UpdateSectionDate(segue:UIStoryboardSegue) {
        print("Update Date")
        self.dismissViewControllerAnimated(true, completion: nil)
        switch StartORend {
        case 0:
            if drugs[currentRec-1].end.daysFrom(curDate) < 0 {break}
            drugs[currentRec-1].start = curDate
        default:
            if drugs[currentRec-1].start.daysFrom(curDate) > 0 {break}
            drugs[currentRec-1].end = curDate
        }
        
        let headerview = tbl.viewWithTag(currentRec-1) as? DoctorHeader
        headerview?.setopen(true)
        headerview?.changeFields()
        
        //tbl.reloadSections(NSIndexSet(index: currentRec), withRowAnimation: .None)
        tbl.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        save()
        saveNote()
        self.performSegueWithIdentifier("UpdateSectionTable", sender: self)
    }
    
    func saveNote(){
        print("save ",selectedNoteDay.date.convertedDate()!)
        let table = Table("MedicineTake")
        let id = Expression<Int64>("_id")
        let name = Expression<String>("Name")
        let start = Expression<String>("Start")
        let end = Expression<String>("End")
        let isRemind = Expression<Bool>("isRemind")
        let hour_ = Expression<Int>("Hour")
        let minute_ = Expression<Int>("Minute")
        let interval_ = Expression<Int>("Interval")
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let newcurDate = calendar.dateFromComponents(components)
        
        for i in try! db.prepare(table.select(id,start,end)) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            let componentsS = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(i[start])!)
            let componentsE = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(i[end])!)
            componentsS.hour = 00
            componentsS.minute = 00
            componentsS.second = 00
            let newDateS = calendar.dateFromComponents(componentsS)
            componentsE.hour = 00
            componentsE.minute = 00
            componentsE.second = 00
            let newDateE = calendar.dateFromComponents(componentsE)
            let a = newcurDate?.compare(newDateS!)
            let b = newcurDate?.compare(newDateE!)
            if (a == NSComparisonResult.OrderedDescending || a == NSComparisonResult.OrderedSame) && (b == NSComparisonResult.OrderedAscending || b == NSComparisonResult.OrderedSame) {
                try! db.run(table.filter(id == i[id]).delete())
            }
            
        }
        
        for i in drugs{
            try! db.run(table.insert(name <- i.name, start <- String(i.start), end <- String(i.end), isRemind <- i.isRemind, hour_ <- i.hour, minute_ <- i.minute, interval_ <- i.interval))
        }
    }
    
    func save()
    {
        for (var i = 0 ; i<drugs.count   ; i += 1  ){
            
            let index = NSIndexPath(forItem: 0, inSection: i+1)
            
            let header = tbl?.viewWithTag(index.section) as? DoctorHeader
            if(header!.doctornameText.text?.isEmpty == false){
                drugs[i].name = (header!.doctornameText.text)!
            }
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = selectedNoteDay.date
        let controller = calendarView.contentController as! CVCalendarMonthContentViewController
        controller.selectDayViewWithDay(date.day, inMonthView: controller.presentedMonthView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.backgroundColor = StrawBerryColor
        menuView.backgroundColor = StrawBerryColor
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        // calendarView.changeMode(.WeekView)
    }
}

extension DrugsViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Monday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool
    {
        return false
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        saveNote()
        drugs.removeAll()
        arrayForBool.removeAllObjects()
        tbl.reloadData()
        selectedNoteDay = dayView
        arrayForBool.addObject("1")
        loadNotes()
        for(var i = 0 ; i<drugs.count ;i++)
        {
            arrayForBool.addObject("0")
        }
        tbl.reloadData()
    }
    
    func swipedetected(){
    }
    
    func presentedDateUpdated(date: CVDate) {
        
        if self.title != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            // updatedMonthLabel.textColor = monthLabel.textColor
            //updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            
            
            
            switch date.month {
            case 1:
                self.navigationController?.parentViewController?.title = "Январь \(date.year)"
                self.title = "Январь \(date.year)"
                break
            case 2:
                self.navigationController?.parentViewController?.title = "Февраль \(date.year)"
                self.title = "Февраль \(date.year)"
                break
            case 3:
                self.navigationController?.parentViewController?.title = "Март \(date.year)"
                self.title = "Март \(date.year)"
                break
            case 4:
                self.navigationController?.parentViewController?.title = "Апрель \(date.year)"
                self.title = "Апрель \(date.year)"
                break
            case 5:
                self.navigationController?.parentViewController?.title = "Май \(date.year)"
                self.title = "Май \(date.year)"
                break
            case 6:
                self.navigationController?.parentViewController?.title = "Июнь \(date.year)"
                self.title = "Июнь \(date.year)"
                break
            case 7:
                self.navigationController?.parentViewController?.title = "Июль \(date.year)"
                self.title = "Июль \(date.year)"
                break
            case 8:
                self.navigationController?.parentViewController?.title = "Август \(date.year)"
                self.title = "Август \(date.year)"
                break
            case 9:
                self.navigationController?.parentViewController?.title = "Сентябрь \(date.year)"
                self.title = "Сентябрь \(date.year)"
                break
            case 10:
                self.navigationController?.parentViewController?.title = "Октябрь \(date.year)"
                self.title = "Октябрь \(date.year)"
                break
            case 11:
                self.navigationController?.parentViewController?.title = "Ноябрь \(date.year)"
                self.title = "Ноябрь \(date.year)"
                break
            case 12:
                self.navigationController?.parentViewController?.title = "Декабрь \(date.year)"
                self.title = "Декабрь \(date.year)"
                break
            default:
                break
            }
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let res = ImageFromCalendar.ShowCalendarImages(dayView.date.convertedDate()!)
        if (res.0 || res.1 || res.2)
        {
            return true
        }
        
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        var numberOfDots = 0
        
        var colors = [UIColor]()
        
        let res = ImageFromCalendar.ShowCalendarImages(dayView.date.convertedDate()!)
        if (res.0 )
        {
            numberOfDots += 1
            colors.append(UIColor.redColor())
        }
        if (res.1 )
        {
            numberOfDots += 1
            colors.append(UIColor.greenColor())
        }
        if (res.2 )
        {
            numberOfDots += 1
            colors.append(UIColor.blueColor())
        }
        
        return colors
        
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }

    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (Int(arc4random_uniform(3)) == 1) {
            return false
        }
        
        return false
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension DrugsViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension DrugsViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension DrugsViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}
