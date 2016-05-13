//
//  NotesTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

import SwiftyVK

var selectedNoteDay:DayView!
var NoteType = Int()
var notes = ["Моё самочувствие","Как ведет себя малыш","Посещения врачей","Мой вес","Принимаемые лекарства","Приятное воспоминание дня","Важные события","Моё меню на сегодня","Мой \"лист желаний\""]


class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tbl: UITableView!
    var shouldShowDaysOut = true
    var animationFinished = true
    //var db = try! Connection()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.backgroundColor = .clearColor()
        self.presentedDateUpdated(CVDate(date: NSDate()))
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = btnBack

  

        
        //WorkWithDB()
    }
    

    
    func WorkWithDB(){
    
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, false
            ).first!
        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let destinationPath = (doumentDirectoryPath as NSString).stringByAppendingPathComponent("db.sqlite")
        db = try! Connection(destinationPath)
        let id = Expression<Int64>("_id")
        let articles = Table("article")

        //for art in try! db.prepare(articles) {
          //  print("id: \(art[id])")}
        let count = try db.scalar(articles.count)
        print(count)
    }
    
    func returnTableCount(tableName: String, type: Int, date: NSDate) -> Int{
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, false
            ).first!
        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let destinationPath = (doumentDirectoryPath as NSString).stringByAppendingPathComponent("db.sqlite")
        let db = try! Connection(destinationPath)
        let table = Table(tableName)
        var count = 0
        
        if tableName == "TextNote"{
            let Type = Expression<Int64>("Type")
            let Date = Expression<String>("Date")
            switch type {
            case 0:
                count = try db.scalar(table.filter(Date == "\(date)" && Type == 0).count)
                break
            case 1:
                count = try db.scalar(table.filter(Date == "\(date)" && Type == 1).count)
                break
            case 3:
                count = try db.scalar(table.filter(Date == "\(date)" && Type == 3).count)
                break
            case 5:
                count = try db.scalar(table.filter(Date == "\(date)" && Type == 5).count)
                break
            case 6:
                count = try db.scalar(table.filter(Date == "\(date)" && Type == 6).count)
                break
            default: break
            }
        }
        return count
    }
    
    func returnTableText(tableName: String, type: Int, date: NSDate) -> String{
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, false
            ).first!
        var doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        let destinationPath = (doumentDirectoryPath as NSString).stringByAppendingPathComponent("db.sqlite")
        let db = try! Connection(destinationPath)
        let table = Table(tableName)
        var str = ""
        
        if tableName == "TextNote"{
            let Type = Expression<Int64>("Type")
            let Date = Expression<String>("Date")
            let text = Expression<String>("NoteText")

            for tmp in try! db.prepare(table.select(text).filter(Date == "\(date)" && Type == Int64(type))){
                str = tmp[text]}
                
        }else if tableName == "WeightNote"{
            let table = Table("WeightNote")
            let Date = Expression<String>("Date")
            let WeightKg = Expression<Int64>("WeightKg")
            let WeightGr = Expression<Int64>("WeightGr")
   
            for tmp in try! db.prepare(table.select(WeightKg, WeightGr).filter(Date == "\(date)")){
                str = "\(tmp[WeightKg]) кг \(tmp[WeightGr]) г"
            }
        }else if tableName == "DoctorVisit"{
            var table = Table("DoctorVisit")
            let name = Expression<String>("Name")
            let Date = Expression<String>("Date")
            let isRemind = Expression<Bool>("isRemind")
            let remindType = Expression<Int>("RemindType")
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            var count = 0
            
            for i in try! db.prepare(table.select(Date)) {
                let b = i[Date]
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                let componentsCurrent = calendar.components([.Day , .Month , .Year], fromDate: dateFormatter.dateFromString(b)!)
                if components.day == componentsCurrent.day && components.month == componentsCurrent.month && components.year == componentsCurrent.year {
                    count += 1
                }
            }
            str = "\(count) заметок"
        }
        return str
    }

    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return   notes.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        //cell.detailTextLabel?.text = "нет заметок"
        var text = String()
        var date = NSDate()
        if selectedNoteDay != nil{
            date = selectedNoteDay.date.convertedDate()!
        }
        switch indexPath.row {
        case 0: //мое самочувствие - тестовая
            text = returnTableText("TextNote", type: 0, date: date)
            
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 1: //как ведет сеья малыш - текстовая
            text = returnTableText("TextNote", type: 1, date: date)
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 2: //посещение врачей - список с напоминаниеями
            text = returnTableText("DoctorVisit", type: 2, date: date)
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 3: //мой вес - текстовая
            text = returnTableText("WeightNote", type: 3, date: date)
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 4: //принимаемые лекарства - список с напоминаниями
            cell.detailTextLabel?.text = "Нет заметок"
            break
        case 5: //приятное воспоминание дня - тестовая
            text = returnTableText("TextNote", type: 5, date: date)
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 6: //важные события - текстовая
            text = returnTableText("TextNote", type: 6, date: date)
            if  text  != "" {
                cell.detailTextLabel?.text = String(text)
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 7: //мое меню на сегодня - несколько списков
            if returnFoodCount(date) > 0 {
                cell.detailTextLabel?.text = "\(returnFoodCount(date)) желаний"
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
        case 8: //мой "лист желаний" - список - не превязаны ко дню
            if returnDesireCount() > 0 {
                cell.detailTextLabel?.text = "\(returnDesireCount()) желаний"
            }else{
                cell.detailTextLabel?.text = "Нет заметок"
            }
            break
            default: break
        }
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    func returnDesireCount()->Int{
        let table = Table("DesireList")
        return try! db.scalar(table.count)
    }
    
    func returnFoodCount(date: NSDate)->Int{
        let table = Table("Food")
        let Date = Expression<String>("Date")
        return try! db.scalar(table.filter(Date == "\(date)").count)
    }
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor = UIColor.whiteColor()
        return BackgroundView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NoteType = indexPath.row
        switch indexPath.row {
        case 0:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("textNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 1:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("textNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 2:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Doctor")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            
            break
        case 3:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WeightNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 4:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Drugs")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 5:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("textNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 6:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("textNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 7:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FoodNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 8:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("desireNote")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break

        default: break
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        cell!.textLabel?.highlightedTextColor = StrawBerryColor
        cell!.detailTextLabel?.highlightedTextColor = StrawBerryColor
        return indexPath
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        calendarView.backgroundColor = StrawBerryColor
        menuView.backgroundColor = StrawBerryColor
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        
        
        // calendarView.changeMode(.WeekView)
    
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

extension NotesViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = 3
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
        return true
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

extension NotesViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension NotesViewController {
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

extension NotesViewController {
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