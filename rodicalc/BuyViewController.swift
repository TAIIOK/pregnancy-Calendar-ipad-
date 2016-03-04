//
//  BuyTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import MapKit


class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate {
    
    
    let mags = ["ТРЦ \"Пирамида\", 2 этаж","м-н \"40 недель\""]
    let mags0 = ["Адрес: ул. Краснознаменская, 9","Адрес: ул. Ленина, 19"]
    
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MagCell")
            
        tbl.delegate = self
        tbl.dataSource = self
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
        return mags.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "MagCell")
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
        cell.textLabel?.text = mags[indexPath.row]
        cell.detailTextLabel?.text=mags0[indexPath.row]
        return cell
    }
}
