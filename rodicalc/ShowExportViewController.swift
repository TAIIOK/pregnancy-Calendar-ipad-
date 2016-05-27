//
//  ShowExportViewController.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 27.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var segmenttype = false

class ShowExportViewController: UIViewController , UIScrollViewDelegate  {

    @IBOutlet weak var CurrentScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       CurrentScrollView.delegate = self
        CurrentScrollView.userInteractionEnabled = true
        CurrentScrollView.scrollEnabled = true
        CurrentScrollView.contentSize = CGSizeMake(1000 , 1000)
        loadExportImages()
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadExportImages()
    {
        
        let height =  CGFloat(integerLiteral: 620 * AllExportNotes.count)
         CurrentScrollView.contentSize = CGSizeMake(700 , height)
        
        var y = CGFloat(integerLiteral: 0)
        
        for( var i = 0;i < AllExportNotes.count ; i++)
        {
            if(!AllExportNotes[i].photos.isEmpty && AllExportNotes[i].notes.isEmpty && AllExportNotes[i].notifi.isEmpty)
            {
                var photos = AllExportNotes[i].photos
                    for(var f = 0 ; f < photos.count  ; )
                           {
                            if(photos.count >= 2 )
                            {
                                
                                var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                                
                                if(segmenttype){
                                image.image = CreateTwoPhotosBlue(photos[f], right: photos[f+1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                else{
                                image.image = CreateTwoPhotosPink(photos[f], right: photos[f+1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                print(CurrentScrollView.subviews.count)
                                if(CurrentScrollView.subviews.count > 2)
                                {
                                image.frame.origin.y = image.frame.height + y
                                }
                                CurrentScrollView.addSubview(image)
                                y += 20
                                f += 2
                                
                            }
                            
                            else if (photos.count < 2 )  {
                                var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                                if(segmenttype){
                                image.image = CreateTwoPhotosBlue(photos[f], right: photos[f+1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                else{
                                image.image = CreateTwoPhotosPink(photos[f], right: photos[f+1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                // Добавить шаблон для 1 фотографии 
                                
                                if(CurrentScrollView.subviews.count > 0)
                                {
                                    image.frame.origin.y = image.frame.height + y
                                }
                                CurrentScrollView.addSubview(image)
                                y += 20
                                f += 1
                            }
                            
                     
                            
                }


            }
            else if(AllExportNotes[i].photos.isEmpty && AllExportNotes[i].notes.isEmpty || !AllExportNotes[i].notifi.isEmpty){
            
            
            }
            
            else if(AllExportNotes[i].photos.isEmpty && !AllExportNotes[i].notes.isEmpty || AllExportNotes[i].notifi.isEmpty){
                
                
            }
            
        
        }
    
        
        
        
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
