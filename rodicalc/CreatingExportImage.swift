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
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    
    exportView.xibFirstSetup(left, right: right, title: title, leftText: leftText, rightText: rightText)
    
    return exportView.screenshot
}

func CreateTextWithTwoPhotosBlue() -> UIImage{
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    
    exportView.xibSecondSetup()
    
    return exportView.screenshot
}

func CreateTextOnlyBlue() -> UIImage{
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    
    exportView.xibThirdSetup()
    
    return exportView.screenshot
}

