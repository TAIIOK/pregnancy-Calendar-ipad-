//
//  ShowZodiacViewController.swift
//  rodicalc
//
//  Created by deck on 04.04.16.
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


class ShowZodiacViewController: UIViewController {

    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var zodiacName: UILabel!
    @IBOutlet weak var zodiacElement: UILabel!
    @IBOutlet weak var zodiacAbout: UITextView!
    @IBOutlet weak var zodiacIcon: UIImageView!
    
    var zodiacs = [Zodiac]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WorkWithJSON()
        birthDate.text = "66 ИЮНЯ 6666 ГОДА"
        zodiacName.text = zodiacs[0].name
        zodiacElement.text = zodiacs[0].element
        zodiacAbout.text = zodiacs[0].about
        zodiacIcon.image = UIImage(named: "0.jpg")
        // Do any additional setup after loading the view.
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
                                zodiacs.append(Zodiac(name: d as! String, element: "\(Zodiacs.valueForKey("Стихия")!)", about: "\(Zodiacs.valueForKey("Описание")!)"))
                            }
                        }
                    }
                } catch {}
            } catch {}
        }
    }
}
