//
//  NameViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class NameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var changer: UISegmentedControl!
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    
    @IBAction func toBack(sender: UIBarButtonItem) {
                
        self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: complete)
    }
    
    func complete(){
        self.performSegueWithIdentifier("YourUnwindSegueIdentifier", sender: nil)
    }
    
    private func reloadTable(index: Bool) {
        choosedSegmentNames = index
        choosedName = NSIndexPath(forRow: 0, inSection: 0)
        self.table.reloadData()
        self.table.scrollToRowAtIndexPath(choosedName, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if choosedSegmentNames {
            changer.selectedSegmentIndex = 0
        }else{
            changer.selectedSegmentIndex = 1
        }
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.backgroundColor = .clearColor()
        table.delegate = self
        table.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackOpaque
        self.table.scrollToRowAtIndexPath(choosedName, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return choosedSegmentNames ? sections.count : sectionsGirl.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return choosedSegmentNames ? sections[section].length : sectionsGirl[section].length
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        choosedName = indexPath
        info.text = choosedSegmentNames ? (man[sections[indexPath.section].index + indexPath.row].name + "\n\n" + man[sections[indexPath.section].index + indexPath.row].value + "\n\n" + man[sections[indexPath.section].index + indexPath.row].about) : (woman[sectionsGirl[indexPath.section].index + indexPath.row].name + "\n\n" + woman[sectionsGirl[indexPath.section].index + indexPath.row].value + "\n\n" + woman[sectionsGirl[indexPath.section].index + indexPath.row].about)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = choosedSegmentNames ? man[sections[indexPath.section].index + indexPath.row].name : woman[sectionsGirl[indexPath.section].index + indexPath.row].name
        if(indexPath == choosedName){
            
            info.text = choosedSegmentNames ? (man[sections[indexPath.section].index + indexPath.row].name + "\n\n" + man[sections[indexPath.section].index + indexPath.row].value + "\n\n" + man[sections[indexPath.section].index + indexPath.row].about) : (woman[sectionsGirl[indexPath.section].index + indexPath.row].name + "\n\n" + woman[sectionsGirl[indexPath.section].index + indexPath.row].value + "\n\n" + woman[sectionsGirl[indexPath.section].index + indexPath.row].about)
        }
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView() //set these values as necessary
        returnedView.backgroundColor = StrawBerryColor
        
        let label = UILabel(frame: CGRectMake(18, 7, 18, 18))
        label.text = choosedSegmentNames ? sections[section].title : sectionsGirl[section].title
        label.textColor = UIColor.whiteColor()
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return choosedSegmentNames ? sections[section].title : sectionsGirl[section].title
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return choosedSegmentNames ? sections.map { $0.title } : sectionsGirl.map {$0.title}
    }
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor = UIColor.clearColor()
        return BackgroundView
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        return indexPath
    }
}
