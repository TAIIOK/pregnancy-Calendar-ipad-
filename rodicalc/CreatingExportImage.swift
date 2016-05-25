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

func loltest(){
    
    let exportView = photo(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    
    let image = exportView.screenshot
    
    print(image)
    
    ImageViewTest.image = exportView.screenshot
    
}