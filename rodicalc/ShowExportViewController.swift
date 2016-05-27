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
        loadExportImages()
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadExportImages()
    {
        
     //  var image = UIImageView(image: <#T##UIImage?#>)
        
       // CurrentScrollView.addSubview(image)
        
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
