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

class photo: UIView{
    
    @IBOutlet weak var LeftImageView: UIImageView!
    @IBOutlet weak var RightImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LeftImageLabel: UILabel!
    @IBOutlet weak var RightImageLabel: UILabel!
    
    func setContent(LeftImage : UIImage,RightImage : UIImage, Tittle: String,LeftLabel : String, RightLabel: String)
    {
        LeftImageView.image = LeftImage
        RightImageView.image = RightImage
        TitleLabel.text = Tittle
        LeftImageLabel.text = LeftLabel
        RightImageLabel.text = RightLabel
        
        M_PI_4
    }
    
}