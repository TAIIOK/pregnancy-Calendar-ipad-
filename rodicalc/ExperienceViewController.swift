//
//  ExperienceTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import CoreData

var not = [notifi]()

var articles = ["Для чего нужен до-и послеродовой бандаж","Для чего нужен до-и послеродовой бюстгальтер"]
var artticlessub = ["По материалам многоцентрового проспективного наблюдательного исследования Российского общества акушеров-гинекологов","По материалам многоцентрового проспективного наблюдательного исследования Российского общества акушеров-гинекологов"]

var articletype = 0

class notifi: NSObject {
    var day: String
    var generalInformation: String
    var healthMother: String
    var healthBaby: String
    var food: String
    var important: String
    var HidenAdvertisment : String
    var advertisment : String
    var reflectionsPregnant : String
    
    init(day: String, generalInformation: String , healthMother: String , healthBaby: String , food: String ,important: String , HidenAdvertisment : String , advertisment : String , reflectionsPregnant : String) {
        self.day = day
        self.generalInformation = generalInformation
        self.healthMother = healthMother
        self.healthBaby = healthBaby
        self.food = food
        self.important = important
        self.HidenAdvertisment = HidenAdvertisment
        self.advertisment = advertisment
        self.reflectionsPregnant = reflectionsPregnant
        super.init()
    }
}

class note: NSObject {
    var name: String
    var text: String
    
    init(name: String, text: String) {
        self.name = name
        self.text = text
        super.init()
    }
}

class ExperienceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    var shouldShowDaysOut = true
    var animationFinished = true
    
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var tbl: UITableView!
    
    var day: Int = 0
    var choosedSegmentNotes = true // true: статьи, false: уведомления
    var BirthDate = NSDate()

    var mas = [note]()

    @IBAction func segmentChanger(sender: UISegmentedControl) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    
    private func reloadTable(index: Bool) {
        choosedSegmentNotes = index
        //let choosedNote = NSIndexPath(forRow: 0, inSection: 0)
        self.tbl.reloadData()
        //self.tbl.scrollToRowAtIndexPath(choosedNote, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func WorkWithJSON(){
        if not.count == 0{
        if let path = NSBundle.mainBundle().pathForResource("notifi", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let Man : [NSDictionary] = jsonResult["reminder"] as? [NSDictionary] {
                        for mans: NSDictionary in Man {
                            var day = mans.valueForKey("день")
                            day!.dataUsingEncoding(NSUTF8StringEncoding)
                            if let d = day {
                                not.append(notifi(day: d as! String, generalInformation: "\(mans.valueForKey("Общая информация")!)", healthMother: "\(mans.valueForKey("Здоровье мамы")!)", healthBaby: "\(mans.valueForKey("Здоровье малыша")!)", food: "\(mans.valueForKey("питание")!)", important: "\(mans.valueForKey("Это важно!")!)", HidenAdvertisment: "\(mans.valueForKey("Скрытая реклама")!)", advertisment: "\(mans.valueForKey("реклама ФЭСТ")!)", reflectionsPregnant: "\(mans.valueForKey("размышления беременной")!)"))
                            }
                        }
                    }
                } catch {}
            } catch {}
        }
        }
    }
    
    
    func setupNavigation(date : CVDate){
    
    
        let customView = UIView(frame: CGRectMake(0, 0, 100, 44))
        customView.backgroundColor = StrawBerryColor
        
        
        let label = UILabel(frame: CGRectMake(0, 0,100, 44))
        
        switch date.month {
        case 1:
            label.text = "Январь"
            break
        case 2:
            label.text = "Февраль"
            break
        case 3:
            label.text = "Март"
            break
        case 4:
            label.text = "Апрель"
            break
        case 5:
            label.text = "Май"
            break
        case 6:
            label.text = "Июнь"
            break
        case 7:
            label.text = "Июль"
            break
        case 8:
            label.text =  "Август"
            break
        case 9:
            label.text =  "Сентябрь"
            break
        case 10:
            label.text =  "Октябрь"
            break
        case 11:
            label.text = "Ноябрь"
            break
        case 12:
            label.text = "Декабрь"
            break
        default:
            break
        }


        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Right
        label.backgroundColor = StrawBerryColor
        customView.addSubview(label)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.backgroundColor = .clearColor()
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = btnBack
        

        setupNavigation(CVDate(date: NSDate()))
        tbl.delegate = self
        tbl.dataSource = self
        WorkWithJSON()
        loadDate()
        //leftbutt![0] = leftButton
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return choosedSegmentNotes ? 1 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if choosedSegmentNotes == false{
        notesperday()
        }
        return choosedSegmentNotes ? articles.count : mas.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotesCell", forIndexPath: indexPath)
        if choosedSegmentNotes == false && mas.count > 0 {
            cell.textLabel?.text = mas[indexPath.row].name
            cell.detailTextLabel?.text = mas[indexPath.row].text
        }
        if choosedSegmentNotes == true && articles.count > 0 {
            cell.textLabel?.text = articles[indexPath.row]
            cell.detailTextLabel?.text = artticlessub[indexPath.row]
        }
        cell.backgroundColor = .clearColor()
        cell.textLabel?.textColor = StrawBerryColor
        cell.detailTextLabel?.textColor = BiruzaColor
        return cell
    }
    
    private func notesperday(){
        day = 300 - BirthDate.daysFrom(selectedDay.date.convertedDate()!)
        mas.removeAll()
        for var i in not{
            let d = Int(i.day)
            if d == day{
                if i.generalInformation != ""{
                    mas.append(note(name: "Общая информация",  text: "\(i.generalInformation)"))
                }
                if i.healthMother != ""{
                    mas.append(note(name: "Здоровье мамы", text: "\(i.healthMother)"))
                }
                if i.healthBaby != ""{
                    mas.append(note(name: "Здоровье малыша", text: "\(i.healthBaby)"))
                }
                if i.food != ""{
                    mas.append(note(name: "Питание", text: "\(i.food)"))
                }
                if i.important != ""{
                    mas.append(note(name: "Это важно!", text: "\(i.important)"))
                }
                if i.HidenAdvertisment != ""{
                    mas.append(note(name: "Полезно знать каждой", text: "\(i.HidenAdvertisment)"))
                }
                if i.advertisment != ""{
                    mas.append(note(name: "Полезно знать каждой", text: "\(i.advertisment)"))
                }
                if i.reflectionsPregnant != ""{
                    mas.append(note(name: "Размышление беременной", text: "\(i.reflectionsPregnant)"))
                }
            }
        }
    }
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor = UIColor.whiteColor()
        return BackgroundView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(choosedSegmentNotes != false)
        {
        articletype = indexPath.row
        switch indexPath.row {
        case 0:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webarticle")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
        case 1:
            let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("webarticle")
            self.navigationController?.pushViewController(destinationViewController!, animated: true)
            break
            
        default: break
            }
        }else{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell?.textLabel?.text == "Полезно знать каждой"{
                let destinationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("advertising")
                self.navigationController?.pushViewController(destinationViewController!, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        //cell!.selectedBackgroundView=getCustomBackgroundView()
        //cell!.textLabel?.highlightedTextColor = StrawBerryColor
        //cell!.detailTextLabel?.highlightedTextColor = StrawBerryColor
        cell?.selectedBackgroundView?.backgroundColor = .clearColor()
        return indexPath
    }
    

    override func shouldAutorotate() -> Bool {
        return false
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
                    BirthDate = dte
                    if dateType == 0{
                        BirthDate = addDaystoGivenDate(BirthDate, NumberOfDaysToAdd: 7*38)
                    }
                    else if dateType == 1{
                        BirthDate = addDaystoGivenDate(BirthDate, NumberOfDaysToAdd: 7*40)
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = selectedNoteDay.date
        let controller = calendarView.contentController as! CVCalendarMonthContentViewController
        controller.selectDayViewWithDay(date.day, inMonthView: controller.presentedMonthView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        mas.removeAll()
        tbl.reloadData()
    }
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

extension ExperienceViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        selectedDay = dayView
        notesperday()
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
            
            setupNavigation(date)
            
            
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

extension ExperienceViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension ExperienceViewController {
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

extension ExperienceViewController {
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


