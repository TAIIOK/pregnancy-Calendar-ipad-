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
    
    
    @IBOutlet weak var cell0: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        //cell0.setSelected(true, animated: true)
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.selectedBackgroundView=getCustomBackgroundView()
        return indexPath
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/


}
