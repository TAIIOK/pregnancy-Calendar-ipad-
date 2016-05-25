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
    
    func setImage(left: UIImage){
    
        leftImage.image = left
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
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
        func setContent(LeftImage : UIImage,RightImage : UIImage, Tittle: String,LeftLabel : String, RightLabel: String)
        {

        }
        
        
        func xibSetup() {
           var view1 = loadViewFromNib() as! image1
            
        
            view1.frame = CGRectMake(0 , 0, self.frame.width, self.frame.height)

            
            view1.tag = 911
          
            view1.setImage(UIImage(named: "1z.jpg")!)
            // use bounds not frame or it'll be offset
            view1.frame = bounds
            
            // Make the view stretch with containing view
            view1.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            
            // Adding custom subview on top of our view (over any custom drawing > see note below)
            addSubview(view1)

        }
        
   
        
        
        func loadViewFromNib() -> UIView {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: "photo", bundle: bundle)
            
            // Assumes UIView is top level and only object in CustomView.xib file
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            return view
        }
        
        
}