//
//  NotifiListTableViewController.swift
//  Календарь беременности
//
//  Created by deck on 12.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class NotifiListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {


    
    @IBOutlet weak var table: UITableView!
    var remind = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Notification.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notifiCell", forIndexPath: indexPath) as! NotifiCell
        cell.textLbl.text = Notification[indexPath.row]
        return cell
    }
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Save(sender: UIBarButtonItem) {
        print("save")
        doctors[currentRec].remindType = (table.indexPathForSelectedRow?.row)!
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
