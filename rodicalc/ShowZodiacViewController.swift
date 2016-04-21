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
        birthDate.text = "\(selectedDay.date.day).\(selectedDay.date.month).\(selectedDay.date.year)"
        let zodiac = searchZodiac(selectedDay.date.convertedDate()!)
        zodiacName.text = zodiacs[zodiac].name
        zodiacElement.text = zodiacs[zodiac].element
        zodiacAbout.text = zodiacs[zodiac].about
        zodiacIcon.image = UIImage(named: "0.jpg")
        var str = String()
        print(zodiacs[0].name.characters.indexOf("(")!)
        /*for var j = zodiacs[0].name.characters.indexOf("("); j < zodiacs[0].name.characters.indexOf(")"); j += 1
        {
            str.append(zodiacs[0].name[j!])
        }
        print(str)*/
        // Do any additional setup after loading the view.
    }

    func searchZodiac(date: NSDate) -> Int{
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        if((month==3 && day>=21) || (month==4 && day<=19)){
        return 0;
        }
        if((month==4 && day>=20) || (month==5 && day<=21)){
            return 1;
        }
        if((month==5 && day>=22) || (month==6 && day<=21)){
            return 2;
        }
        if((month==6 && day>=22) || (month==7 && day<=22)){
            return 3;
        }
        if((month==8 && day>=23) || (month==7 && day<=22)){
            return 4;
        }
        if((month==8 && day>=23) || (month==9 && day<=22)){
            return 5;
        }
        if((month==9 && day>=23) || (month==10 && day<=22)){
            return 6;
        }
        if((month==10 && day>=23) || (month==11 && day<=22)){
            return 7;
        }
        if((month==11 && day>=23) || (month==12 && day<=22)){
            return 8;
        }
        if((month==12 && day>=22) || (month==1 && day<=20)){
            return 9;
        }
        if((month==1 && day>=21) || (month==2 && day<=18)){
            return 10;
        }
        if((month==2 && day>=19) || (month==3 && day<=20)){
            return 11;
        }
        
        
        
        return 1;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEditDate(sender: AnyObject) {
        Back = true
        let date = self.storyboard?.instantiateViewControllerWithIdentifier("BirthDate")
        if #available(iOS 8.0, *) {
            self.splitViewController?.showDetailViewController(date!, sender: self)
        } else {
            // Fallback on earlier versions
        }
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
