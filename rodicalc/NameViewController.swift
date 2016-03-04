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
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var changer: UISegmentedControl!
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        self.reloadTable(sender.selectedSegmentIndex == 1 ? false : true)
    }
    
    @IBAction func toBack(sender: UIBarButtonItem) {
        self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func reloadTable(index: Bool) {
        choosedSegment = index
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.delegate = self
        table.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackOpaque
        //self.navigationItem.title = choosedSegment ? boyNames[choosedName] : girlNames[choosedName]
        //self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor=StrawBerryColor
        return BackgroundView
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        cell?.textLabel?.highlightedTextColor = UIColor.whiteColor()
        return indexPath
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  choosedSegment ? boyNames.count : girlNames.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        choosedName = indexPath.row
        info.text = choosedSegment ? boyNames[choosedName] : girlNames[choosedName]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = choosedSegment ? boyNames[indexPath.row] : girlNames[indexPath.row]
        if(indexPath.row == choosedName){
            info.text = choosedSegment ? boyNames[choosedName] : girlNames[choosedName]}
        return cell
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
