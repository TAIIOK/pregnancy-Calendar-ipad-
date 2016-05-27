//
//  ShowExportViewController.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 27.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class ShowExportViewController: UIViewController , UIScrollViewDelegate  {

    @IBOutlet weak var CurrentScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CurrentScrollView.delegate = self
        CurrentScrollView.userInteractionEnabled = true
        CurrentScrollView.scrollEnabled = true
        loadExportImages()
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadExportImages()
    {
        
        CurrentScrollView.contentSize = CGSizeMake(700 , 620 * 2)

       var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
        image.image = CreateTextOnlyBlue("sss", CenterText: "sss")
        var image1 = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
        image1.image = CreateTextOnlyBlue("sss", CenterText: "sss")
        CurrentScrollView.addSubview(image)
        image1.frame.origin.y += image.frame.height + 20
        CurrentScrollView.addSubview(image1)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
