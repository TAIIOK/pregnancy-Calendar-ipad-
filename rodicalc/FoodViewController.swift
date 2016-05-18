//
//  FoodViewController.swift
//  Календарь беременности
//
//  Created by deck on 29.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var FoodTable: UITableView!
    @IBOutlet weak var PreferencesTable: UITableView!
    @IBOutlet weak var RestrictionsTable: UITableView!
    
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var Food = [String]()
    var Preferences = [String]()
    var Restrictions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = CVDate(date: NSDate()).globalDescription
        if selectedNoteDay != nil {
            self.calendarView.toggleViewWithDate(selectedNoteDay.date.convertedDate()!)
        }else{
            let date = NSDate()
            self.calendarView.toggleViewWithDate(date)
        }
        self.presentedDateUpdated(CVDate(date: NSDate()))
        
        
        FoodTable.delegate = self
        FoodTable.dataSource = self
        FoodTable.backgroundColor = .clearColor()
        PreferencesTable.delegate = self
        PreferencesTable.dataSource = self
        PreferencesTable.backgroundColor = .clearColor()
        RestrictionsTable.delegate = self
        RestrictionsTable.dataSource = self
        RestrictionsTable.backgroundColor = .clearColor()
        loadData()
        if Food.count == 0 {
            Food.append("")
        }
        if Preferences.count == 0 {
            Preferences.append("")
        }
        if Restrictions.count == 0 {
            Restrictions.append("")
        }
    }

    func loadData(){
        Food.removeAll()
        var table = Table("Food")
        var text = Expression<String>("Text")
        let date = Expression<String>("Date")
        for i in try! db.prepare(table.filter(date == "\(selectedNoteDay.date.convertedDate()!)")) {
            Food.append(i[text])
        }
        
        Preferences.removeAll()
        table = Table("Preferences")
        text = Expression<String>("Text")

        for i in try! db.prepare(table) {
            Preferences.append(i[text])
        }
        
        Restrictions.removeAll()
        table = Table("Restrictions")
        text = Expression<String>("Text")
        for i in try! db.prepare(table) {
            Restrictions.append(i[text])
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == FoodTable{
            return Food.count+1
        }else if tableView == PreferencesTable{
            return Preferences.count+1
        }else{
            return Restrictions.count+1
        }
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == FoodTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("FoodCell", forIndexPath: indexPath) as! FoodTableViewCell
            if indexPath.row == Food.count{
                cell.textField.hidden = true
            }else{
                cell.textField.hidden = false
                cell.textField.text = Food[indexPath.row]}
            cell.backgroundColor = .clearColor()
            return cell
        }else if tableView == PreferencesTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("PreferencesCell", forIndexPath: indexPath) as! PreferencesTableViewCell
            if indexPath.row == Preferences.count{
                cell.textField.hidden = true
            }else{
                cell.textField.hidden = false
                cell.textField.text = Preferences[indexPath.row]}
            cell.backgroundColor = .clearColor()
            return cell

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("RestrictionsCell", forIndexPath: indexPath) as! RestrictionsTableViewCell
            if indexPath.row == Restrictions.count{
                cell.textField.hidden = true
            }else{
                cell.textField.hidden = false
                cell.textField.text = Restrictions[indexPath.row]}
            cell.backgroundColor = .clearColor()
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == FoodTable{
            if indexPath.row == Food.count{
                fromTableFoodInArray()
                Food.append("")
                self.FoodTable.reloadData()
                fromTablePreferencesInArray()
                fromTableRestrictionsInArray()
            }
        }else if tableView == PreferencesTable{
            if indexPath.row == Preferences.count{
                fromTablePreferencesInArray()
                Preferences.append("")
                self.PreferencesTable.reloadData()
                fromTableFoodInArray()
                fromTableRestrictionsInArray()
            }
        }else{
            if indexPath.row == Restrictions.count{
                fromTableRestrictionsInArray()
                Restrictions.append("")
                self.RestrictionsTable.reloadData()
                fromTableFoodInArray()
                fromTablePreferencesInArray()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        fromTableFoodInArray()
        var table = Table("Food")
        var text = Expression<String>("Text")
        let date = Expression<String>("Date")
        
        var count = try! db.scalar(table.filter(date == "\(selectedNoteDay.date.convertedDate()!)").count)
        if count > 0{
            try! db.run(table.filter(date == "\(selectedNoteDay.date.convertedDate()!)").delete())
        }
        for var i in Food{
            if i.characters.count > 0{
                try! db.run(table.insert(text <- "\(i)", date <- "\(selectedNoteDay.date.convertedDate()!)"))}
        }

        fromTablePreferencesInArray()
        table = Table("Preferences")
        count = try! db.scalar(table.count)
        if count > 0{
            try! db.run(table.delete())
        }
        for var i in Preferences{
            if i.characters.count > 0{
                try! db.run(table.insert(text <- "\(i)"))}
        }
        
        fromTableRestrictionsInArray()
        table = Table("Restrictions")
        count = try! db.scalar(table.count)
        if count > 0{
            try! db.run(table.delete())
        }
        for var i in Restrictions{
            if i.characters.count > 0{
                try! db.run(table.insert(text <- "\(i)"))}
        }
    }
    
    func fromTableFoodInArray(){
        let int = self.FoodTable.numberOfRowsInSection(0)-1
        for var i = NSIndexPath(forRow: 0, inSection: 0); i.row < int; i = NSIndexPath(forRow: i.row+1, inSection: 0){
            let cell = self.FoodTable.cellForRowAtIndexPath(i) as! FoodTableViewCell
            Food[i.row] = cell.textField.text!
        }
    }
    
    func fromTablePreferencesInArray(){
        let int = self.PreferencesTable.numberOfRowsInSection(0)-1
        for var i = NSIndexPath(forRow: 0, inSection: 0); i.row < int; i = NSIndexPath(forRow: i.row+1, inSection: 0){
            let cell = self.PreferencesTable.cellForRowAtIndexPath(i) as! PreferencesTableViewCell
            Preferences[i.row] = cell.textField.text!
        }
    }
    
    func fromTableRestrictionsInArray(){
        let int = self.RestrictionsTable.numberOfRowsInSection(0)-1
        for var i = NSIndexPath(forRow: 0, inSection: 0); i.row < int; i = NSIndexPath(forRow: i.row+1, inSection: 0){
            let cell = self.RestrictionsTable.cellForRowAtIndexPath(i) as! RestrictionsTableViewCell
            Restrictions[i.row] = cell.textField.text!
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

extension FoodViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        var res = ImageFromCalendar.ShowCalendarImages(dayView.date.convertedDate()!)
        if (res.0 || res.1 || res.2)
        {
            return true
        }
        
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        var numberOfDots = 0
        
        let day = dayView.date.day
        var res = ImageFromCalendar.ShowCalendarImages(dayView.date.convertedDate()!)
        if (res.0 )
        {
            numberOfDots += 1
        }
        if (res.1 )
        {
            numberOfDots += 1
        }
        if (res.2 )
        {
            numberOfDots += 1
        }
        
        
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

extension FoodViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension FoodViewController {
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

extension FoodViewController {
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