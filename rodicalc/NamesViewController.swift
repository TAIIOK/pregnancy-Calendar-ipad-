//
//  NamesTableViewController.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var man = [Names]()
var woman = [Names]()

var choosedName = NSIndexPath() // index of name
var choosedSegmentNames = true // true: boys, false: girls

class Names: NSObject {
    var name: String
    var value: String
    var about: String
    init(name: String, value: String, about: String) {
        self.name = name
        self.value = value
        self.about = about
        super.init()
    }
}

var sections : [(index: Int, length :Int, title: String)] = Array()
var sectionsGirl : [(index: Int, length :Int, title: String)] = Array()

class NamesTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var changer: UISegmentedControl!
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    
    private func reloadTable(index: Bool) {
        choosedSegmentNames = index
        choosedName = NSIndexPath(forRow: 0, inSection: 0)
        self.table.reloadData()
        self.table.scrollToRowAtIndexPath(choosedName, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadNameTable:", name:"LoadNameTable", object: nil)
        table.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        table.backgroundColor = .clearColor()
        //WorkWithJSON()

    }
    
    


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return choosedSegmentNames ? sections.count : sectionsGirl.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return choosedSegmentNames ? sections[section].length : sectionsGirl[section].length
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        choosedName = indexPath
       // self.navigationController?.pushViewController(nameViewControlle, animated: true)
    }
    
    @IBAction func returnToFirstViewController(segue:UIStoryboardSegue) {
        print("This is called after  modal is dismissed by menu button on Siri Remote")
        self.dismissViewControllerAnimated(true, completion: nil)
        Update()
    }

    /*private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor=StrawBerryColor
        return BackgroundView
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        cell?.textLabel?.highlightedTextColor = UIColor.whiteColor()
        return indexPath
    }*/
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)        
        cell.textLabel?.text = choosedSegmentNames ? man[sections[indexPath.section].index + indexPath.row].name : woman[sectionsGirl[indexPath.section].index + indexPath.row].name
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var returnedView = UIView() //set these values as necessary
        returnedView.backgroundColor = StrawBerryColor
        
        var label = UILabel(frame: CGRectMake(18, 7, 18, 18))
        label.text = choosedSegmentNames ? sections[section].title : sectionsGirl[section].title
        label.textColor = UIColor.whiteColor()
        returnedView.addSubview(label)
        
        return returnedView
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return choosedSegmentNames ? sections[section].title : sectionsGirl[section].title
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return choosedSegmentNames ? sections.map { $0.title } : sectionsGirl.map {$0.title}
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    override func viewDidAppear(animated: Bool) {
        choosedSegmentNames = true
    }
    
    func Update(){
        dispatch_async(dispatch_get_main_queue(), {
        if choosedSegmentNames {
            self.changer.selectedSegmentIndex = 0
        } else{
            self.changer.selectedSegmentIndex = 1
        }
        self.table.reloadData()
        self.table.scrollToRowAtIndexPath(choosedName, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        })
    }
    
    func LoadNameTable(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), {
            self.table.reloadData()
            return
        })
    }
}
