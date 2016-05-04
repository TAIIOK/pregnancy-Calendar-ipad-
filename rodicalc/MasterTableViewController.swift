//
//  MenuTableViewController.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    //var items: [String] = ["РАСЧЕТ ДАТЫ РОДОВ", "СПРАВОЧНИК ИМЕН", "СЧЕТЧИК СХВАТОК", "ГРАФИК НАБОРА ВЕСА","ФОТОАЛЬБОМ","ВИДЕОТЕКА","ЗАМЕТКИ","ФОРУМ","ПОЛЕЗНЫЙ ОПЫТ","КАЛЕНДАРЬ","БЛИЖАЙШИЕ МАГАЗИНЫ", "ЭКСПОРТ" ]
    
    
    @IBOutlet var table: UITableView!

    @IBOutlet weak var cellLogo: UITableViewCell!
    @IBOutlet weak var cell0: UITableViewCell!
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    @IBOutlet weak var cell7: UITableViewCell!
    @IBOutlet weak var cell8: UITableViewCell!
    @IBOutlet weak var cell9: UITableViewCell!
    @IBOutlet weak var cell10: UITableViewCell!
    @IBOutlet weak var cell11: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        table.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.Middle)

        self.tableView(table, willSelectRowAtIndexPath: rowToSelect)
        table.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        table.backgroundColor = .clearColor()
        cellLogo.backgroundColor = .clearColor()
        cell0.backgroundColor = .clearColor()
        cell1.backgroundColor = .clearColor()
        cell2.backgroundColor = .clearColor()
        cell3.backgroundColor = .clearColor()
        cell4.backgroundColor = .clearColor()
        cell5.backgroundColor = .clearColor()
        cell6.backgroundColor = .clearColor()
        cell7.backgroundColor = .clearColor()
        cell8.backgroundColor = .clearColor()
        cell9.backgroundColor = .clearColor()
        cell10.backgroundColor = .clearColor()
        cell11.backgroundColor = .clearColor()
        cell0.setHighlighted(true, animated: false)
        cell0.setSelected(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell11.backgroundColor = .clearColor()
    }*/
    
    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor=StrawBerryColor
        return BackgroundView
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) != cell0 && cell0.highlighted == true{
            cell0.setHighlighted(false, animated: false)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.row>0){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell!.selectedBackgroundView=getCustomBackgroundView()
        }
        return indexPath
    }
}
