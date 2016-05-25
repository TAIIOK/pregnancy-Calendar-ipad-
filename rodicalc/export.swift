//
//  export.swift
//  rodicalc
//
//  Created by Roman Efimov on 26.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class image1: UIView{
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    
    func setContent(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String){
    
        leftImage.image = left
        rightImage.image = right
        titleLabel.text = title
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    
}
class photo: UIView{
    
   // var view = UIView()
    
    // Outlets
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
     //  xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
       // xibSetup()
    }
            
        
        func xibFirstSetup(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String) {
           var view1 = loadViewFromNib("photo") as! image1
            
            
            view1.setContent(left, right: right, title: title, leftText: leftText, rightText: rightText)
            
        
            view1.frame = CGRectMake(0 , 0, self.frame.width, self.frame.height)

            // use bounds not frame or it'll be offset
            view1.frame = bounds
            
            // Make the view stretch with containing view
            view1.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            // Adding custom subview on top of our view (over any custom drawing > see note below)
            addSubview(view1)

        }
    
    func xibSecondSetup() {
        var view1 = loadViewFromNib("photo") as! image1
        
        view1.frame = CGRectMake(0 , 0, self.frame.width, self.frame.height)
        
        // use bounds not frame or it'll be offset
        view1.frame = bounds
        
        // Make the view stretch with containing view
        view1.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view1)
        
    }
    
    func xibThirdSetup() {
        var view1 = loadViewFromNib("photo") as! image1
        
        view1.frame = CGRectMake(0 , 0, self.frame.width, self.frame.height)
        
        // use bounds not frame or it'll be offset
        view1.frame = bounds
        
        // Make the view stretch with containing view
        view1.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view1)
        
    }
    

    func loadViewFromNib(nibString : String) -> UIView {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: nibString, bundle: bundle)
            
            // Assumes UIView is top level and only object in CustomView.xib file
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            return view
        }
        
        
}