//
//  ExportTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var selectonDateType = -1

class ExportViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {


    @IBOutlet weak var DateTable: UITableView!
    @IBOutlet weak var NotesTable: UITableView!
    @IBOutlet weak var PhotoCollectionVIew: UICollectionView!
    @IBOutlet weak var NotifiTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateTable.delegate = self
        DateTable.dataSource = self
        DateTable.backgroundColor = .clearColor()
        NotesTable.delegate = self
        NotesTable.dataSource = self
        NotesTable.backgroundColor = .clearColor()
        NotifiTable.delegate = self
        NotifiTable.dataSource = self
        NotifiTable.backgroundColor = .clearColor()
    
        if self.splitViewController?.viewControllers[0].restorationIdentifier == "ExportNav"{
            let img = UIImage(named: "Row-32")
            //self.navigationItem.setLeftBarButtonItem(,animated: false)
            self.title = ""
            let btn = UIBarButtonItem(image: img , style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(ExportViewController.FallBack))
            self.navigationItem.leftBarButtonItem = btn
            print("!!!!\(selectonDateType)!!!!")
        }

    }
    func FallBack(){
        print("fall back!!!")
        MasterViewSelectedRow = 12
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ExportNav")
        let vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("MasterView")
        self.splitViewController?.showDetailViewController(vc!, sender: self)
        self.splitViewController?.viewControllers[0] = vc1!
    }

    @IBAction func Show(sender: UIButton) {
        print("показать")
    }
    
    //TABLE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == DateTable{
            return 2
        }else if tableView == NotesTable{
            return 10
        }else{
           return 1
        }
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == DateTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("DateExpCell", forIndexPath: indexPath) as! DateTableViewCell
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Выбранные дни"
                cell.detailTextLabel?.text = "не выбрано"
            case 1:
                cell.textLabel?.text = "Недели беременности"
                cell.detailTextLabel?.text = "не выбрано"
            default:
                cell.textLabel?.text = ""
            }
            if indexPath.row == selectonDateType{
                cell.setHighlighted(true, animated: false)
                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
            
            cell.selectedBackgroundView?.backgroundColor = .clearColor()
            cell.backgroundColor = .clearColor()
            return cell
        }else if tableView == NotesTable{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteExpCell", forIndexPath: indexPath) as! DateTableViewCell
            cell.textLabel?.text = "\(indexPath.row) cell"
            cell.backgroundColor = .clearColor()
            cell.selectedBackgroundView?.backgroundColor = .clearColor()
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("NotifiExpCell", forIndexPath: indexPath) as! DateTableViewCell
            cell.detailTextLabel?.text = "0 уведомлений"
            cell.backgroundColor = .clearColor()
            cell.selectedBackgroundView?.backgroundColor = .clearColor()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == DateTable{
            selectonDateType = indexPath.row
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ExportNav")
            let vc1 = self.storyboard?.instantiateViewControllerWithIdentifier("CalendarNav")
            self.splitViewController?.viewControllers[0] = vc!
            self.splitViewController?.showDetailViewController(vc1!, sender: self)
        }else if tableView == NotesTable{

        }else{

        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UISplitViewController {
    var xx_primaryViewController: UIViewController? {
        get {
            return self.viewControllers[0] as? UIViewController
        }
    }
    
    var xx_secondaryViewController: UIViewController? {
        get {
            if self.viewControllers.count > 1 {
                return self.viewControllers[1] as? UIViewController
            }
            return nil
        }
    }
}
