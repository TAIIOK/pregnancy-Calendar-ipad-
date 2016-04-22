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
    @IBOutlet weak var cell0: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        let rowToSelect:NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        table.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.Middle)

        self.tableView(table, willSelectRowAtIndexPath: rowToSelect)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func getCustomBackgroundView() -> UIView{
        let BackgroundView = UIView()
        BackgroundView.backgroundColor=StrawBerryColor
        return BackgroundView
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.row>0){
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell!.selectedBackgroundView=getCustomBackgroundView()
        }
        return indexPath
    }
}
