//
//  CalcTableViewController.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData

var Back = false
var selectedDay:DayView!
var dateType = -1
var BirthDate = NSDate()

class CalcViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let txt = ["По дате зачатия","По дате последней менструации","По дате, указанной врачем"]


    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var calendarView: CVCalendarView!
    var shouldShowDaysOut = true
    var animationFinished = true
    var DateisLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = .clearColor()
        loadDate()

        self.presentedDateUpdated(CVDate(date: NSDate()))

        if !Back && DateisLoaded{
            Cancel()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.backgroundColor = StrawBerryColor
        menuView.backgroundColor = StrawBerryColor
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        // calendarView.changeMode(.WeekView)
    }
    
    func addDaystoGivenDate(baseDate: NSDate, NumberOfDaysToAdd: Int) -> NSDate
    {
        let dateComponents = NSDateComponents()
        let CurrentCalendar = NSCalendar.currentCalendar()
        let CalendarOption = NSCalendarOptions()
        
        dateComponents.day = NumberOfDaysToAdd
        
        let newDate = CurrentCalendar.dateByAddingComponents(dateComponents, toDate: baseDate, options: CalendarOption)
        return newDate!
    }
    
    func Cancel(){
        let zodiac = self.storyboard?.instantiateViewControllerWithIdentifier("ShowZodiac")
        //self.navigationController?.pushViewController(zodiac!, animated: false)
        
        if #available(iOS 8.0, *) {
            self.splitViewController?.showDetailViewController(zodiac!, sender: self)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func OK(sender: AnyObject) {
        saveDate(selectedDay.date.convertedDate()!, type: dateType)
        BirthDate = selectedDay.date.convertedDate()!
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return txt.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateTableViewCell
        cell.textLabel?.text = txt[indexPath.row]
    
        if indexPath.row == dateType && selectedDay != nil{
            var date = selectedDay.date.convertedDate()!
            if dateType == 0{
               // date = addDaystoGivenDate(date, NumberOfDaysToAdd: 7*38)
            }
            else if dateType == 1{
               // date = addDaystoGivenDate(date, NumberOfDaysToAdd: 7*40)
            }
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            var string = ""
            if(components.month<10)
            {
                string = "0\(components.month)"
            }
            else
            {
                string = "\(components.month)"
            }
            
            var stringday = ""
            if(components.day<10)
            {
                stringday = "0\(components.day)"
            }
            else
            {
                stringday = "\(components.day)"
            }
            
            cell.detailTextLabel?.text = "\(stringday).\(string).\(components.year)"
            //cell.detailTextLabel?.text = "\(selectedDay.date.day).\(selectedDay.date.month).\(selectedDay.date.year)"
            cell.setHighlighted(true, animated: false)
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
        else{
            cell.detailTextLabel?.text = "не выбрано"
        }
        cell.backgroundColor = .clearColor()
        cell.tintColor = UIColor.lightGrayColor()
        cell.detailTextLabel?.tintColor = UIColor.lightGrayColor()
        return cell
    }
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor = UIColor.whiteColor()
        return BackgroundView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let a = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text
        dateType = indexPath.row//print("type: \(indexPath.row), date: \(a!)")
        /*if selectedDay != nil{
            BirthDate = selectedDay.date.convertedDate()!
            if dateType == 0{
                BirthDate = addDaystoGivenDate(BirthDate, NumberOfDaysToAdd: 7*38)
            }
            else if dateType == 1{
                BirthDate = addDaystoGivenDate(BirthDate, NumberOfDaysToAdd: 7*40)
            }
        }*/
        tableView.reloadData()

        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DateTableViewCell
        cell.selectedBackgroundView=getCustomBackgroundView()
        cell.textLabel?.highlightedTextColor = StrawBerryColor
        cell.detailTextLabel?.highlightedTextColor = StrawBerryColor
        return indexPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func viewWillDisappear(animated: Bool) {
        Back = false
    }
    
    func saveDate(date: NSDate, type: Int){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("BirthDate", inManagedObjectContext: managedContext)
            
        let BD = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
        BD.setValue(date, forKey: "date")
        BD.setValue(type, forKey: "type")
        do {
            try BD.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    func loadDate(){
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("BirthDate", inManagedObjectContext:managedContext)
        
        fetchRequest.entity = entityDescription
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for i in result {
                    let date = i as! NSManagedObject
                    let dte = date.valueForKey("date") as! NSDate
                    dateType = date.valueForKey("type") as! Int
                    calendarView.toggleViewWithDate(dte)
                    BirthDate = dte
                    DateisLoaded = true
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        

            let  date = CVDate(date: BirthDate)
            let controller = calendarView.contentController as! CVCalendarMonthContentViewController
            controller.selectDayViewWithDay(date.day, inMonthView: controller.presentedMonthView)
        
        
    }
    
    
    
}

extension CalcViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
    
    func shouldAutoSelectDayOnMonthChange() -> Bool
    {
        return false
    }
    
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
        if dateType != -1{
            if !Back{
                //self.Cancel()
            }
            let index = self.tbl.indexPathForSelectedRow
            self.tbl.reloadData()
            self.tbl.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
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
                self.navigationController?.parentViewController?.title = "Январь,\(date.year)"
                self.title = "Январь,\(date.year)"
                break
            case 2:
                self.navigationController?.parentViewController?.title = "Февраль,\(date.year)"
                self.title = "Февраль,\(date.year)"
                break
            case 3:
                self.navigationController?.parentViewController?.title = "Март,\(date.year)"
                self.title = "Март,\(date.year)"
                break
            case 4:
                self.navigationController?.parentViewController?.title = "Апрель,\(date.year)"
                self.title = "Апрель,\(date.year)"
                break
            case 5:
                self.navigationController?.parentViewController?.title = "Май,\(date.year)"
                self.title = "Май,\(date.year)"
                break
            case 6:
                self.navigationController?.parentViewController?.title = "Июнь,\(date.year)"
                self.title = "Июнь,\(date.year)"
                break
            case 7:
                self.navigationController?.parentViewController?.title = "Июль,\(date.year)"
                self.title = "Июль,\(date.year)"
                break
            case 8:
                self.navigationController?.parentViewController?.title = "Август,\(date.year)"
                self.title = "Август,\(date.year)"
                break
            case 9:
                self.navigationController?.parentViewController?.title = "Сентябрь,\(date.year)"
                self.title = "Сентябрь,\(date.year)"
                break
            case 10:
                self.navigationController?.parentViewController?.title = "Октябрь,\(date.year)"
                self.title = "Октябрь,\(date.year)"
                break
            case 11:
                self.navigationController?.parentViewController?.title = "Ноябрь,\(date.year)"
                self.title = "Ноябрь,\(date.year)"
                break
            case 12:
                self.navigationController?.parentViewController?.title = "Декабрь,\(date.year)"
                self.title = "Декабрь,\(date.year)"
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

extension CalcViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension CalcViewController {
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

extension CalcViewController {
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


