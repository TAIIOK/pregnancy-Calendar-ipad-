//
//  export.swift
//  rodicalc
//
//  Created by Roman Efimov on 26.04.16.
//  Copyright © 2016 deck. All rights reserved.
//

import Foundation
import UIKit


class TwoPhotoBlue: UIView{
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    
    func setContent(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String){
        rotateViews()
        leftImage.image = left
        rightImage.image = right
        titleLabel.text = title
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    func rotateViews(){
        leftImage.rotate(degrees: 10)
        rightImage.rotate(degrees: 10)
        titleLabel.rotate(degrees: 10)
        leftLabel.rotate(degrees: 10)
        rightLabel.rotate(degrees: 10)
    
    }
    
}

class TextWithTwoPhotoBlue: UIView{
    
    @IBOutlet weak var UpPhotoView: UIImageView!
    @IBOutlet weak var UpLabel: UILabel!
    @IBOutlet weak var DownPhotoView: UIImageView!
    @IBOutlet weak var DownLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var CenterTextView: UITextView!
    
    func setContent(UpPhoto:UIImage,UpText :String, DownPhoto : UIImage,DownText : String, Title: String,CenterText :String ){
        
        rotateViews()
        UpPhotoView.image = UpPhoto
        UpLabel.text = UpText
        DownPhotoView.image = DownPhoto
        DownLabel.text = DownText
        TitleLabel.text = Title
        CenterTextView.text = CenterText

    }
    
    func rotateViews(){
        UpPhotoView.rotate(degrees: 10)
        UpLabel.rotate(degrees: 10)
        DownPhotoView.rotate(degrees: 10)
        DownLabel.rotate(degrees: 10)
    }

}


class TextOnlyBlue: UIView{
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var CenterTextView: UITextView!
    func setContent(Title : String, CenterText: String){
        TitleLabel.text = Title
        CenterTextView.text = CenterText
    }
    
}

class TwoPhotoPink: UIView{
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!

    @IBOutlet weak var leftLabel: UILabel!
    func setContent(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String){
        rotateViews()
        leftImage.image = left
        rightImage.image = right
        titleLabel.text = title
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
    
    func rotateViews(){
        leftImage.rotate(degrees: 10)
        rightImage.rotate(degrees: 10)
        titleLabel.rotate(degrees: 10)
        leftLabel.rotate(degrees: 10)
        rightLabel.rotate(degrees: 10)
        
    }
    
}

class TextWithTwoPhotoPink: UIView{
    
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var CenterTextView: UITextView!
    
    
    @IBOutlet weak var UpPhotoView: UIImageView!
    
    @IBOutlet weak var UpLabel: UILabel!
    
    @IBOutlet weak var DownPhotoView: UIImageView!
    
    @IBOutlet weak var DownLabel: UILabel!
    func setContent(UpPhoto:UIImage,UpText :String, DownPhoto : UIImage,DownText : String, Title: String,CenterText :String ){
        
        rotateViews()
        UpPhotoView.image = UpPhoto
        UpLabel.text = UpText
        DownPhotoView.image = DownPhoto
        DownLabel.text = DownText
        TitleLabel.text = Title
        CenterTextView.text = CenterText
        
    }
    
    func rotateViews(){
        UpPhotoView.rotate(degrees: 10)
        UpLabel.rotate(degrees: 10)
        DownPhotoView.rotate(degrees: 10)
        DownLabel.rotate(degrees: 10)
    }
    
}


class TextOnlyPink: UIView{
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var CenterTextView: UITextView!
    func setContent(Title : String, CenterText: String){
        TitleLabel.text = Title
        CenterTextView.text = CenterText
    }
    
}



class photo: UIView{
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
    }
            
        
        func xibFirstSetupBlue(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String) {
           var view1 = loadViewFromNib("TwoPhotoBlue") as! TwoPhotoBlue
            
            view1.setContent(left, right: right, title: title, leftText: leftText, rightText: rightText)
            
            frameSetup(view1)

        }
    
    func xibSecondSetupBlue(UpPhoto:UIImage,UpText :String, DownPhoto : UIImage,DownText : String, Title: String,CenterText :String) {
        var view1 = loadViewFromNib("TextWithTwoPhotosBlue") as! TextWithTwoPhotoBlue
        
        view1.setContent(UpPhoto, UpText: UpText, DownPhoto: DownPhoto, DownText: DownText, Title: Title, CenterText: CenterText)
        
        frameSetup(view1)
        
    }
    
    func xibThirdSetupBlue(Title : String, CenterText: String) {
        var view1 = loadViewFromNib("TextOnlyBlue") as! TextOnlyBlue
        
        view1.setContent(Title, CenterText: CenterText)
        
        frameSetup(view1)
        
    }
    
    func xibFirstSetupPink(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String) {
        var view1 = loadViewFromNib("TwoPhotoPink") as! TwoPhotoBlue
        
        view1.setContent(left, right: right, title: title, leftText: leftText, rightText: rightText)
        
        frameSetup(view1)
        
    }
    
    func xibSecondSetupPink(UpPhoto:UIImage,UpText :String, DownPhoto : UIImage,DownText : String, Title: String,CenterText :String) {
        var view1 = loadViewFromNib("TextWithTwoPhotosPink") as! TextWithTwoPhotoBlue
        
        view1.setContent(UpPhoto, UpText: UpText, DownPhoto: DownPhoto, DownText: DownText, Title: Title, CenterText: CenterText)
        
        frameSetup(view1)
        
    }
    
    func xibThirdSetupPink(Title : String, CenterText: String) {
        var view1 = loadViewFromNib("TextOnlyPink") as! TextOnlyBlue
        
        view1.setContent(Title, CenterText: CenterText)
        
        frameSetup(view1)
        
    }
    
    func frameSetup(view : UIView)
    {
        view.frame = CGRectMake(0 , 0, self.frame.width, self.frame.height)
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)

    }

    func loadViewFromNib(nibString : String) -> UIView {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: nibString, bundle: bundle)
            
            // Assumes UIView is top level and only object in CustomView.xib file
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            return view
        }
        
    
}