//
//  NamesTableViewController.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
// names test
let boyNames = ["Александр", "Алексей", "Тимофей", "Тимофей", "Юрий", "Хуита"]
let girlNames = ["Дарья", "Света", "Софья"]

var choosedName = 0 // index of name
var choosedSegmentNames = true // true: boys, false: girls

class NamesTableViewController: UITableViewController {
    
    let lettersOfManIndexes = "А Б В Г Д Е И К Л М Н О П Р С Т Ю Я"
    let lettersOfWomanIndexes = "А В Г Д Е Ж З И К Л М Н О П С Т Ю"
    var manIndexes: [String] = []
    var womanIndexes: [String] = []
    var sections : [(index: Int, length :Int, title: String)] = Array()
    var sectionsGirl : [(index: Int, length :Int, title: String)] = Array()
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }

    private func reloadTable(index: Bool) {
        choosedSegmentNames = index
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let rowToSelect:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        //self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
        

        /*var first = String()
        var second = String()
        for ( var i = 0; i < boyNames.count; i += 1 ){
            
            let string = boyNames[i].uppercaseString;
            let firstCharacter = string[string.startIndex]
            first = "\(firstCharacter)"
            
            if i+1 == boyNames.count {
                let newSection = (index: i, length: 1, title: first)
                sections.append(newSection)
            }
            
            for ( var j = i+1; j < boyNames.count; j += 1 ){
                let s = boyNames[j].uppercaseString;
                let fc = s[s.startIndex]
                second = "\(fc)"
                
                if first != second {
                    let newSection = (index: i, length: j - i, title: first)
                    sections.append(newSection)
                    i = j-1
                    j = boyNames.count
                }
                if first == second && j+1 == boyNames.count {
                    let newSection = (index: i, length: j - i + 1, title: first)
                    sections.append(newSection)
                }
            }
        }*/
        sections = AddSect(boyNames)
        sectionsGirl = AddSect(girlNames)

        //self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func AddSect(names: [String]) -> [(index: Int, length :Int, title: String)] {
        var sect: [(index: Int, length :Int, title: String)] = Array()
        var first = String()
        var second = String()
        var appended = [String]()
        for ( var i = 0; i < names.count; i += 1 ){
            
            let string = names[i].uppercaseString;
            let firstCharacter = string[string.startIndex]
            first = "\(firstCharacter)"
            
            if !appended.contains(first) && i+1 == names.count {
                let newSection = (index: i, length: 1, title: first)
                sect.append(newSection)
                appended.append(first)
            }
            
            for ( var j = i+1; j < names.count; j += 1 ){
                let s = names[j].uppercaseString;
                let fc = s[s.startIndex]
                second = "\(fc)"
                
                if !appended.contains(first) && first != second {
                    let newSection = (index: i, length: j - i, title: first)
                    sect.append(newSection)
                    i = j-1
                    j = names.count
                    appended.append(first)
                }
                if !appended.contains(first) && first == second && j+1 == names.count {
                    let newSection = (index: i, length: j - i + 1, title: first)
                    sect.append(newSection)
                    appended.append(first)
                }
            }
        }
        return sect
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
        choosedName = indexPath.row
        //let nameViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NameViewController") as? NameViewController
        //self.navigationController?.pushViewController(nameViewController!, animated: true)
    }
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor=StrawBerryColor
        return BackgroundView
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        cell?.textLabel?.highlightedTextColor = UIColor.whiteColor()
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //cell.textLabel?.text = choosedSegmentNames ? boyNames[indexPath.row] : girlNames[indexPath.row]
        
        cell.textLabel?.text = choosedSegmentNames ? boyNames[sections[indexPath.section].index + indexPath.row] : girlNames[sectionsGirl[indexPath.section].index + indexPath.row]
        return cell
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
