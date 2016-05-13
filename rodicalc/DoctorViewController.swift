//
//  DoctorViewController.swift
//  rodicalc
//
//  Created by deck on 27.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit


class Doctor: NSObject {
    var date: NSDate
    var name: String
    var isRemind: Bool
    var remindType: Int
    var cellType: Int
    
    init(date: NSDate, name: String, isRemind: Bool, remindType: Int, cellType: Int) {
        self.date = date
        self.name = name
        self.isRemind = isRemind
        self.remindType = remindType
        self.cellType = cellType
        super.init()
    }
}


let Notification = ["Нет","За 5 минут","За 15 минут","За 30 минут","За 1 час","За 2 часа","За 1 день","За 1 неделю"]
let firstComponent1 = ["00", "01", "02","03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
let secondComponent1 = ["00", "01", "02","03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
var currentRec = 0
var changeRemindInCurRec = 0
var curRemindType = 0
var minute = 0
var hour = 0
class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate , UIGestureRecognizerDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var NoteTitle: UILabel!
    
    @IBOutlet weak var tbl: UITableView!

    var arrayForBool : NSMutableArray = NSMutableArray()

    var shouldShowDaysOut = true
    var animationFinished = true
    var doctors = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = .clearColor()
        
        var nibName = UINib(nibName: "DoctorViewCell", bundle:nil)
        self.tbl.registerNib(nibName, forCellReuseIdentifier: "DoctorViewCell")
        
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
        for(var i = 0 ; i<doctors.count ;i++)
        {
            arrayForBool.addObject("0")
        }

        
        self.presentedDateUpdated(CVDate(date: NSDate()))
    }
    
    func loadNotes(){
        doctors.removeAll()
        var table = Table("DoctorVisit")
        let name = Expression<String>("Name")
        let date = Expression<String>("Date")
        let isRemind = Expression<Bool>("isRemind")
        let remindType = Expression<Int>("RemindType")
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
        
        let count = try! db.scalar(table.count)
        
        for i in try! db.prepare(table.select(name,date,isRemind,remindType)) {
            let b = i[date]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            let componentsCurrent = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(b)!)
            if components.day == componentsCurrent.day && components.month == componentsCurrent.month && components.year == componentsCurrent.year {
                print("wtf")
                doctors.append(Doctor(date: dateFormatter.dateFromString(b)!, name: i[name], isRemind: i[isRemind], remindType: i[remindType], cellType: 0))
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
            
            doctors.append(Doctor(date: newDate!, name: "Доктор", isRemind: false, remindType: 0, cellType: 1))
            arrayForBool.addObject("0")
            tbl.reloadData()
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
        if(arrayForBool .objectAtIndex(indexPath.section).boolValue == true){
            return 60
        }
        
        return 2;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        
        let view = DoctorHeader(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour , .Minute , .Second], fromDate: doctors[section-1].date)
        
        view.setupView(section, doctor: doctors[section-1].name, time: "\(firstComponent1[components.hour]):\(secondComponent1[components.minute])")
        
        view.tag = section
        
        headerView.tag = section
        
        let imageTapped = UITapGestureRecognizer (target: self, action:"enablenotification:")
        imageTapped.numberOfTapsRequired = 1
        imageTapped.numberOfTouchesRequired = 1
        imageTapped.delegate = self
        
   
        view.imageView.addGestureRecognizer(imageTapped)
      
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        view.addGestureRecognizer(headerTapped)
        
        if (doctors[section-1].isRemind == true){
            
            view.changeImage()
        }
        
        
        view.doctorname.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "lblTapped:")
        tapGesture.numberOfTapsRequired = 1
        view.doctorname.addGestureRecognizer(tapGesture)
        
        
        return view
    }
    
    

    func lblTapped(recognizer: UITapGestureRecognizer){
        if let cellContentView = recognizer.view {
            let tappedPoint = cellContentView.convertPoint(cellContentView.bounds.origin, toView: tbl)
            for i in 0..<tbl.numberOfSections {
                let sectionHeaderArea = tbl.rectForHeaderInSection(i)
                if CGRectContainsPoint(sectionHeaderArea, tappedPoint) {
                    print("tapped on section header:: \(i)")
                    
                    var headerview = tbl.viewWithTag(i) as? DoctorHeader
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
                    
                    if(doctors[i-1].isRemind == true){
                    doctors[i-1].isRemind = false
                    }
                    else if(doctors[i-1].isRemind == false){
                        doctors[i-1].isRemind = true
                    }
                    tbl.reloadSections(NSIndexSet(index: i), withRowAnimation: .None)
               
    
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
            var header = tbl?.viewWithTag(indexPath.section) as? DoctorHeader
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
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("TimeTable") as! UIViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                var location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                
                popover.sourceView = swipedCell.timebutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Hour , .Minute], fromDate: doctors[currentRec-1].date)
                hour = components.hour
                minute = components.minute
                presentViewController(vc, animated: true, completion:nil)
            }
        }
    }
    
    
    
    
    func loadnotifilist(recognizer: UITapGestureRecognizer){
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorViewCell {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("NotifiTable") as! UIViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                var location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                popover.sourceView = swipedCell.notifibutton
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                currentRec = swipedIndexPath.section
                curRemindType = doctors[currentRec-1].remindType
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
        let cell = tableView.dequeueReusableCellWithIdentifier("DoctorViewCell", forIndexPath: indexPath) as! DoctorViewCell
        
        if(indexPath.section != 0)
        {
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
            cell.time.text = "lol"
        }
        else{
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Hour , .Minute , .Second], fromDate: doctors[indexPath.section-1].date)
            cell.timebutton.setTitle("\(firstComponent1[components.hour]):\(secondComponent1[components.minute])", forState: .Normal)
            cell.notifibutton.setTitle(Notification[doctors[indexPath.section-1].remindType], forState: .Normal)
            var notifiTapped = UITapGestureRecognizer (target: self, action:"loadnotifilist:")
            cell.notifibutton.addGestureRecognizer(notifiTapped)
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
        let tmp = doctors[currentRec-1].date
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: tmp)
        components.hour = hour
        components.minute = minute
        components.second = 00
        let newDate = calendar.dateFromComponents(components)
        doctors[currentRec-1].date = newDate!
        //tbl.reloadSections(NSIndexSet(index: currentRec), withRowAnimation: .None)
        tbl.reloadData()
    }
    
    @IBAction func UpdateSection(segue:UIStoryboardSegue) {
        print("Update Notifi")
        doctors[currentRec-1].remindType = changeRemindInCurRec
        //tbl.reloadSections(NSIndexSet(index: currentRec), withRowAnimation: .None)
        tbl.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        var table = Table("DoctorVisit")
        let id = Expression<Int64>("_id")
        let name = Expression<String>("Name")
        let date = Expression<String>("Date")
        let isRemind = Expression<Bool>("isRemind")
        let remindType = Expression<Int>("RemindType")
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
        for i in try! db.prepare(table.select(id,date)) {
            //filter(date == "\(selectedNoteDay.date.convertedDate()!)")
            let b = i[date]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
            let componentsCurrent = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(b)!)
            if components.day == componentsCurrent.day && components.month == componentsCurrent.month && components.year == componentsCurrent.year{
                try! db.run(table.filter(id == i[id]).delete())
            }
        }
        
        for i in doctors{
            try! db.run(table.insert(name <- i.name, date <- String(i.date), isRemind <- i.isRemind, remindType <- i.remindType))
        }
    }
    
    func save()
    {
        for (var i = 0 ; i<doctors.count   ; i += 1  ){
            
            let index = NSIndexPath(forItem: 0, inSection: i+1)
            
            var header = tbl?.viewWithTag(index.section) as? DoctorHeader
            

            if(header!.doctornameText.text?.isEmpty == false){
                let curDate = doctors[i].date
                let calendar = NSCalendar.currentCalendar()
                let componentsCurrent = calendar.components([.Hour , .Minute , .Second], fromDate: curDate)
                
                let components = calendar.components([.Day , .Month , .Year], fromDate: selectedNoteDay.date.convertedDate()!)
                components.hour = componentsCurrent.hour
                components.minute = componentsCurrent.minute
                components.second = componentsCurrent.second
                let newDate = calendar.dateFromComponents(components)
                
                doctors[i].name = (header!.doctornameText.text)!
                doctors[i].date = newDate!
            }
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension DoctorViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedNoteDay = dayView
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
                self.navigationController?.parentViewController?.title = "Январь"
                self.title = "Январь"
                break
            case 2:
                self.navigationController?.parentViewController?.title = "Февраль"
                self.title = "Февраль"
                break
            case 3:
                self.navigationController?.parentViewController?.title = "Март"
                self.title = "Март"
                break
            case 4:
                self.navigationController?.parentViewController?.title = "Апрель"
                self.title = "Апрель"
                break
            case 5:
                self.navigationController?.parentViewController?.title = "Май"
                self.title = "Май"
                break
            case 6:
                self.navigationController?.parentViewController?.title = "Июнь"
                self.title = "Июнь"
                break
            case 7:
                self.navigationController?.parentViewController?.title = "Июль"
                self.title = "Июль"
                break
            case 8:
                self.navigationController?.parentViewController?.title = "Август"
                self.title = "Август"
                break
            case 9:
                self.navigationController?.parentViewController?.title = "Сентябрь"
                self.title = "Сентябрь"
                break
            case 10:
                self.navigationController?.parentViewController?.title = "Октябрь"
                self.title = "Октябрь"
                break
            case 11:
                self.navigationController?.parentViewController?.title = "Ноябрь"
                self.title = "Ноябрь"
                break
            case 12:
                self.navigationController?.parentViewController?.title = "Декабрь"
                self.title = "Декабрь"
                break
            default:
                break
            }
            //updatedMonthLabel.center = self.monthLabel.center
            // self.title = updatedMonthLabel.text
            /*
             let offset = CGFloat(48)
             updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
             updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
             
             UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
             //self.animationFinished = false
             // self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
             //  self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
             //  self.monthLabel.alpha = 0
             
             updatedMonthLabel.alpha = 1
             updatedMonthLabel.transform = CGAffineTransformIdentity
             
             }) { _ in
             
             // self.animationFinished = true
             // self.monthLabel.frame = updatedMonthLabel.frame
             //  self.monthLabel.text = updatedMonthLabel.text
             //  self.monthLabel.transform = CGAffineTransformIdentity
             //  self.monthLabel.alpha = 1
             self.title = updatedMonthLabel.text
             updatedMonthLabel.removeFromSuperview()
             }
             
             
             
             // self.view.insertSubview(updatedMonthLabel, aboveSubview: self.title)
             */
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return false
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = 0
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
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

extension DoctorViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension DoctorViewController {
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

extension DoctorViewController {
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