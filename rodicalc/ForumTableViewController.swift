//
//  ForumTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
var items: [String] = ["Общие","Скидки, подарки, конкурсы","Планирование беременности","Традиционные религии России","Беременность","Поступки мужчин","Ваш возраст при беременности","Роды","После родов","Клуб МАМА-ФЭСТ","Комментарии пользователей"]

var urls: [String] = ["http://www.aist-k.com/forum/forum8/","http://www.aist-k.com/forum/group2/","http://www.aist-k.com/forum/group4/","http://www.aist-k.com/forum/group10/","http://www.aist-k.com/forum/group5/","http://www.aist-k.com/forum/group9/","http://www.aist-k.com/forum/group3/","http://www.aist-k.com/forum/group7/","http://www.aist-k.com/forum/group8/","http://www.aist-k.com/forum/group6/","http://www.aist-k.com/forum/group1/"]
var id=0
class ForumTableViewController: UITableViewController {
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ForumCell", forIndexPath: indexPath)
        cell.textLabel?.text=items[indexPath.row]
        cell.textLabel?.textColor=UIColor.blueColor()
        cell.selectionStyle=UITableViewCellSelectionStyle.None
        cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //print(indexPath.row)
        let websViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebsViewController") as? WebsViewController
        self.navigationController?.pushViewController(websViewController!, animated: true)
        id=indexPath.row
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
