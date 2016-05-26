//
//  CreatingExportImage.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 25.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import Foundation


extension UIView{
    
    var screenshot: UIImage{
        
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.renderInContext(context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot
    }
}

func CreateTwoPhotosBlue(left: UIImage,right: UIImage, title: String,leftText : String, rightText: String) -> UIImage{
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 1000, height: 700))
    
    exportView.xibFirstSetup(left, right: right, title: title, leftText: leftText, rightText: rightText)
    
    return exportView.screenshot
}

func CreateTextWithTwoPhotosBlue(UpPhoto:UIImage,UpText :String, DownPhoto : UIImage,DownText : String, Title: String,CenterText :String) -> UIImage{
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 1000, height: 700))
    
    exportView.xibSecondSetup(UpPhoto, UpText: UpText, DownPhoto: DownPhoto, DownText: DownText, Title: Title, CenterText: CenterText)
    
    return exportView.screenshot
}

func CreateTextOnlyBlue(Title : String, CenterText: String) -> UIImage{
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 1000, height: 700))
    
    exportView.xibThirdSetup(Title, CenterText: CenterText)
    
    return exportView.screenshot
}



