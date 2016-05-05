//
//  DoctorViewController.swift
//  rodicalc
//
//  Created by deck on 27.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
var but = UIButton()
var notifiview = UIView()

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

class DoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var NoteTitle: UILabel!
    
    @IBOutlet weak var tbl: UITableView!
    /*var sectionTitleArray : NSMutableArray = NSMutableArray()
    var sectionContentDict : NSMutableDictionary = NSMutableDictionary()
    var arrayForBool : NSMutableArray = NSMutableArray()
    */
    var doctors = [Doctor]()

    var shouldShowDaysOut = true
    var animationFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = .clearColor()
        
        /*let nibName = UINib(nibName: "DoctorViewCell", bundle:nil)
        self.tbl.registerNib(nibName, forCellReuseIdentifier: "DoctorViewCell")
        */
        self.title = CVDate(date: NSDate()).globalDescription
        NoteTitle.text = notes[NoteType]
        if selectedNoteDay != nil {
            self.calendarView.toggleViewWithDate(selectedNoteDay.date.convertedDate()!)
        }else{
            let date = NSDate()
            self.calendarView.toggleViewWithDate(date)
        }
        
        //arrayForBool = ["0","0","0"]
        //sectionTitleArray = ["Pool A","Pool B"]
        
        self.presentedDateUpdated(CVDate(date: NSDate()))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        print(doctors.count+1)
        return doctors.count+1
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("DoctorAddCell", forIndexPath: indexPath)
            cell.backgroundColor = .clearColor()
            return cell
        }else if doctors[indexPath.row-1].cellType == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("DoctorTestCell", forIndexPath: indexPath) as! DoctorTestCell
            cell.name.text = doctors[indexPath.row-1].name
            cell.time.text = String(doctors[indexPath.row-1].date)
            
            cell.bell.userInteractionEnabled = true
            let Selector1 : Selector = "imageTapped:"
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector1)
            tapGesture.numberOfTapsRequired = 1
            cell.bell.addGestureRecognizer(tapGesture)
            
            if (doctors[indexPath.row-1].isRemind == true){
                
                cell.bell.highlighted = true
                
            }
            

            cell.backgroundColor = .clearColor()
            
       cell.selectionStyle = .None
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("DoctorSettingCell", forIndexPath: indexPath) as! DoctorSettingCell
            cell.backgroundColor = .clearColor()
            cell.nameText.hidden = false
            cell.nameField.hidden = true
            
            if (doctors[indexPath.row-1].name.isEmpty)
            {
             
                cell.nameField.text = "Название врача"
                cell.nameText.text = "Название врача"
                
            }
            else{
            cell.nameField.text = doctors[indexPath.row-1].name
            cell.nameText.text = doctors[indexPath.row-1].name
            }
            
            cell.bell.userInteractionEnabled = true
            var tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
            tapGesture.numberOfTapsRequired = 1
            cell.bell.addGestureRecognizer(tapGesture)
            
            if (doctors[indexPath.row-1].isRemind == true){
                
                cell.bell.highlighted = true
                
            }

            
            
            
            cell.nameText.userInteractionEnabled = true
            tapGesture = UITapGestureRecognizer(target: self, action: "lblTapped:")
            tapGesture.numberOfTapsRequired = 1
            cell.nameText.addGestureRecognizer(tapGesture)
            
            cell.nameText.tag = indexPath.row
            cell.tag = indexPath.row
            
            
            cell.btnSetRemind.userInteractionEnabled = true
            tapGesture = UITapGestureRecognizer(target: self, action: "btnTapped:")
            tapGesture.numberOfTapsRequired = 1
            cell.btnSetRemind.addGestureRecognizer(tapGesture)

        
            
            
           cell.selectionStyle = .None

            return cell
        }
        
    }
    
    func imageTapped (recognizer: UITapGestureRecognizer){
        
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorSettingCell {
                if (swipedCell.bell.highlighted == true )
                {
                    swipedCell.bell.highlighted = false
                }
                else{
                    swipedCell.bell.highlighted = true
                }
            }
            
            else {
                if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorTestCell {
                    if (swipedCell.bell.highlighted == true )
                    {
                        swipedCell.bell.highlighted = false
                    }
                    else{
                        swipedCell.bell.highlighted = true
                    }
                }

            
            }
        }
    }
    
    
    func lblTapped(recognizer: UITapGestureRecognizer){
       
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorSettingCell {
                swipedCell.nameText.hidden = true
                swipedCell.nameField.hidden = false
                swipedCell.nameField.text = swipedCell.nameText.text
                
            }
        }
    }
    
    
    func btnTapped(recognizer: UITapGestureRecognizer){
        
        
        let swipeLocation = recognizer.locationInView(self.tbl)
        if let swipedIndexPath = tbl.indexPathForRowAtPoint(swipeLocation) {
            if let swipedCell = self.tbl.cellForRowAtIndexPath(swipedIndexPath) as? DoctorSettingCell {

                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("NotifiTable") as! UIViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                vc.preferredContentSize =  CGSizeMake(340,300)
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                
                var location = recognizer.locationInView(recognizer.view)
                popover.permittedArrowDirections = .Right
                popover.delegate = self
                
                
                popover.sourceView = swipedCell.btnSetRemind
                
                popover.sourceRect = CGRect(
                    x: location.x,
                    y: location.y,
                    width: 1,
                    height: 1)
                
                presentViewController(vc, animated: true, completion:nil)
                
                
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row != 0 && doctors.count >= indexPath.row && doctors[indexPath.row-1].cellType == 1{
           return CGFloat(100)
        }else{
            return CGFloat(44)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if indexPath.row == 0 {
            doctors.append(Doctor(date: selectedNoteDay.date.convertedDate()!, name: "", isRemind: false, remindType: 0, cellType: 1))
            tbl.reloadData()
        }
        

        for (var i = 0 ; i<doctors.count   ; i += 1  ){
            
            let index = NSIndexPath(forItem: i+1, inSection: 0)
            
            let cell = tableView.cellForRowAtIndexPath(index) as? DoctorSettingCell
            
            if (((cell?.nameField.text)?.isEmpty) != nil)
            {
            doctors[i].name = (cell?.nameField.text)!
            doctors[i].date = NSDate()
            if(cell?.bell.highlighted == true)
            {
             doctors[i].isRemind = true
            }
            else{
             doctors[i].isRemind = false
            }
            }
        }
        
        
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.reuseIdentifier! == "DoctorTestCell"{
            doctors[indexPath.row-1].cellType = 1
            tbl.reloadData()
        }
        if cell?.reuseIdentifier! == "DoctorSettingCell"{
            let curcell = tableView.dequeueReusableCellWithIdentifier("DoctorSettingCell", forIndexPath: indexPath) as! DoctorSettingCell
            doctors[indexPath.row-1].cellType = 0
         tbl.reloadData()
        }
 
        for i in doctors{
            print(i.name)
        }
    }

    
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(arrayForBool .objectAtIndex(section).boolValue == true)
        {
            return 1
        }
        return doctors.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
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
        
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        
        var view = DoctorHeader(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        
        
        view.setupView(section, doctor: "Here doctors name", time: "time")
        
        headerView.tag = section
        
        let timestring = UILabel(frame: CGRect(x: 10, y: 10, width: 45, height: 30)) as UILabel
        timestring.text = "10:11"   // sectionTitleArray.objectAtIndex(section) as? String
        headerView.addSubview(timestring)
        
        let doctorname  = UILabel(frame: CGRect(x: 65, y: 10, width: 90, height: 30)) as UILabel
        doctorname.text = "Гениколог"   // sectionTitleArray.objectAtIndex(section) as? String
        headerView.addSubview(doctorname)
        
        var image: UIImage = UIImage(named: "Bell-30_1")!
        var bgImage = UIImageView()
        bgImage.image = image
        bgImage.highlightedImage = UIImage(named: "Bell-30")!
        bgImage.frame = CGRectMake(tableView.frame.size.width - 40,10,30,30)
        bgImage.userInteractionEnabled = true
        
        headerView.addSubview(bgImage)
        
        //bgImage.image = bgImage.highlightedImage
        
        
        
        
        let imageTapped = UITapGestureRecognizer (target: self, action:"enablenotification:")
        view.imageView.addGestureRecognizer(imageTapped)
        
        
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        view.addGestureRecognizer(headerTapped)
        
        return view
    }
    
    func enablenotification(recognizer: UITapGestureRecognizer) {
        
        var header = self.tbl.headerViewForSection((recognizer.view?.tag)!) as? DoctorHeader
        print("notification")
        /*
         Сохранение изменений в массив и перезагрузка таблицы
         
         self.tableView.reloadData()
         */
        
        
    }
    
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        print("Tapping working")
        print(recognizer.view?.tag)
        
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            
            var collapsed = arrayForBool .objectAtIndex(indexPath.section).boolValue
            collapsed       = !collapsed;
            
            arrayForBool .replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            self.tbl.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
        }
        
    }
    
    func loadnotifilist(recognizer: UITapGestureRecognizer){
        
        print("загружено")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NotifiTable") as! UIViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.preferredContentSize =  CGSizeMake(340,300)
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        
        var location = recognizer.locationInView(recognizer.view)
        popover.permittedArrowDirections = .Any
        popover.delegate = self
        
        
        popover.sourceView = but
        
        popover.sourceRect = CGRect(
            x: location.x,
            y: location.y,
            width: 1,
            height: 1)
        
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DoctorViewCell", forIndexPath: indexPath) as! DoctorViewCell
        
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
            cell.time.text = "lol"
        }
        else{
     //       let content = sectionContentDict .valueForKey(sectionTitleArray.objectAtIndex(indexPath.section) as! String) as! NSArray
            
            cell.time.text = "ssssss"
            
            but = cell.notifibutton
            let notifiTapped = UITapGestureRecognizer (target: self, action:"loadnotifilist:")
            cell.notifibutton.addGestureRecognizer(notifiTapped)
            cell.backgroundColor = .clearColor()
            
            
        }
        
        return cell
    }*/
        

    
    override func viewDidDisappear(animated: Bool) {

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