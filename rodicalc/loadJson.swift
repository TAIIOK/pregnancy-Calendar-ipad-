//
//  loadJson.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 03.06.16.
//  Copyright © 2016 deck. All rights reserved.
//

import Foundation


func NamesJSON(){
    if let path = NSBundle.mainBundle().pathForResource("names", ofType: "json") {
        do {
            let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            do {
                let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if let Man : [NSDictionary] = jsonResult["мужские"] as? [NSDictionary] {
                    for mans: NSDictionary in Man {
                        var name = mans.valueForKey("имя")
                        name!.dataUsingEncoding(NSUTF8StringEncoding)
                        if let d = name {
                            man.append(Names(name: d as! String, value: "\(mans.valueForKey("значение")!)", about: "\(mans.valueForKey("описание")!)"))
                            NSNotificationCenter.defaultCenter().postNotificationName("LoadNameTable", object: nil)                        }
                    }
                }
                if let Man : [NSDictionary] = jsonResult["женские"] as? [NSDictionary] {
                    for mans: NSDictionary in Man {
                        var name = mans.valueForKey("имя")
                        name!.dataUsingEncoding(NSUTF8StringEncoding)
                        if let d = name {
                            woman.append(Names(name: d as! String, value: "\(mans.valueForKey("значение")!)", about: "\(mans.valueForKey("описание")!)"))
                             NSNotificationCenter.defaultCenter().postNotificationName("LoadNameTable", object: nil)  
                        }
                    }
                }
                
            } catch {}
        } catch {}
    }
}

func AddSect(names: [Names]) -> [(index: Int, length :Int, title: String)] {
    var sect: [(index: Int, length :Int, title: String)] = Array()
    var first = String()
    var second = String()
    var appended = [String]()
    for ( var i = 0; i < names.count; i += 1 ){
        
        let string = names[i].name.uppercaseString;
        let firstCharacter = string[string.startIndex]
        first = "\(firstCharacter)"
        
        if !appended.contains(first) && i+1 == names.count {
            let newSection = (index: i, length: 1, title: first)
            sect.append(newSection)
            appended.append(first)
        }
        
        for ( var j = i+1; j < names.count; j += 1 ){
            let s = names[j].name.uppercaseString;
            let fc = s[s.startIndex]
            second = "\(fc)"
            
            if !appended.contains(first) && first != second {
                let newSection = (index: i, length: j - i, title: first)
                sect.append(newSection)
                i = j-1
                j = names.count
                appended.append(first)
            }
            if !appended.contains(first) && first == second && j+1 == names.count {
                let newSection = (index: i, length: j - i + 1, title: first)
                sect.append(newSection)
                appended.append(first)
            }
        }
    }
    return sect
}