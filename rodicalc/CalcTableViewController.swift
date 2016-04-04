//
//  CalcTableViewController.swift
//  rodicalc
//
//  Created by deck on 24.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class Zodiac: NSObject {
    var name: String
    var element: String
    var about: String
    init(name: String, element: String, about: String) {
        self.name = name
        self.element = element
        self.about = about
        super.init()
    }
}

class CalcViewController: UIViewController {

    var zodiacs = [Zodiac]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkWithJSON()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func WorkWithJSON(){
        if let path = NSBundle.mainBundle().pathForResource("zodiacs", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let zodiac : [NSDictionary] = jsonResult["Знаки"] as? [NSDictionary] {
                        for Zodiacs: NSDictionary in zodiac {
                            var name = Zodiacs.valueForKey("Знак")
                            name!.dataUsingEncoding(NSUTF8StringEncoding)
                            if let d = name {
                                //points.append(Points(city: "\(Point.valueForKey("city"))",address: d as! String,trade_point: "\(Point.valueForKey("trade_point")!)",phone: "\(Point.valueForKey("phone")!)",longitude: (Point.valueForKey("coord_last_latitude") as? Double)! ,latitude:(Point.valueForKey("coord_first_longtitude") as? Double)!))
                                zodiacs.append(Zodiac(name: d as! String, element: "\(Zodiacs.valueForKey("Стихия"))", about: "\(Zodiacs.valueForKey("Описание"))"))
                            }
                        }
                    }
                } catch {}
            } catch {}
        }
    }


}
