//
//  DoctorHeader.swift
//  AccordionMenu
//
//  Created by Roman Efimov on 04.05.16.
//  Copyright © 2016 Zaeem Solutions. All rights reserved.
//

import UIKit

class DoctorHeader: UIView {


    var doctor:String
    var time:String
    var imageView:UIImageView

    
    
    override init (frame : CGRect) {
        self.doctor = "Гениколог"
        self.time = "10:10"
        self.imageView = UIImageView()
        self.imageView.image = UIImage(named: "Bell-30_1")!
        self.imageView.highlightedImage = UIImage(named: "Bell-30")!
        self.imageView.frame =  CGRectMake(frame.width - 40,10,30,30)
        self.imageView.userInteractionEnabled = true
        self.imageView.tag = 99
        super.init(frame : frame)
    }
    
    func  setupView(tag: Int, doctor: String, time: String ){
        self.tag = tag
        self.doctor = doctor
        self.time = time
        
        //self.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        
        
        self.frame = CGRectMake(0, 0, frame.width , 40)
        
        //let headerView = UIView(frame: CGRectMake(0, 0, 300, 40))
        
        self.tag = tag
        
        let timestring = UILabel(frame: CGRect(x: 10, y: 10, width: 45, height: 30)) as UILabel
        timestring.text = self.time  // sectionTitleArray.objectAtIndex(section) as? String
        self.addSubview(timestring)
        
        let doctorname  = UILabel(frame: CGRect(x: 65, y: 10, width: 90, height: 30)) as UILabel
        doctorname.text = self.doctor  // sectionTitleArray.objectAtIndex(section) as? String
        self.addSubview(doctorname)
        
        self.addSubview(imageView)
    }
    
    func changeImage() {
    
        if (imageView.image == UIImage(named: "Bell-30_1")!)
        {
            imageView.image = imageView.highlightedImage
        }
        else {
          imageView.image = UIImage(named: "Bell-30_1")!
        }
        
        if let viewWithTag = self.viewWithTag(99) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        self.addSubview(imageView)
    
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
