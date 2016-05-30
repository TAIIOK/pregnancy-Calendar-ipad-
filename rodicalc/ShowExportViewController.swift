//
//  ShowExportViewController.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 27.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var segmenttype = true

class ShowExportViewController: UIViewController , UIScrollViewDelegate  {

    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var CurrentScrollView: UIScrollView!
    
    @IBAction func SegmentAction(sender: AnyObject) {
        segmenttype = segmenttype ? false : true

        loadExportImages()
    
    }
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
        CurrentScrollView.removeAllSubviews()
        print(CurrentScrollView.subviews.count)
        let height =  CGFloat(integerLiteral:  620 * AllExportNotes.count + 1)
         CurrentScrollView.contentSize = CGSizeMake(700 , height)
        
        var y = CGFloat(integerLiteral: 0)
        
        if(segmenttype){
            CurrentScrollView.addSubview(CreateTitleBlue())}
        else{
            CurrentScrollView.addSubview(CreateTitlePink())}
        
        y += 20
        
        for( var i = 0;i < AllExportNotes.count ; i++)
        {
            if(!AllExportNotes[i].photos.isEmpty && AllExportNotes[i].notes.isEmpty && AllExportNotes[i].notifi.isEmpty)
            {
                var photos = AllExportNotes[i].photos
                
                            if(photos.count >= 2 )
                            {
                                var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                                
                                if(segmenttype){
                                image.image = CreateTwoPhotosBlue(photos[0], right: photos[1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                else{
                                image.image = CreateTwoPhotosPink(photos[0], right: photos[1], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                print(CurrentScrollView.subviews.count)
                                if(CurrentScrollView.subviews.count > 0)
                                {
                                image.frame.origin.y = image.frame.height + y
                                y += image.frame.height
                                }
                                CurrentScrollView.addSubview(image)
                                y += 20
                                
                            }
                            
                            else if (photos.count < 2 )  {
                                var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                                if(segmenttype){
                                image.image = CreateTwoPhotosBlue(photos[0], right: photos[0], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                else{
                                image.image = CreateTwoPhotosPink(photos[0], right: photos[0], title: String(AllExportNotes[i].date) , leftText: "", rightText: "")
                                }
                                // Добавить шаблон для 1 фотографии 
                                
                                if(CurrentScrollView.subviews.count > 0)
                                {
                                    image.frame.origin.y = image.frame.height + y
                                     y += image.frame.height
                                }
                                CurrentScrollView.addSubview(image)
                                y += 20
                            }

            }
            else if(!AllExportNotes[i].photos.isEmpty && !AllExportNotes[i].notes.isEmpty || !AllExportNotes[i].notifi.isEmpty){
                
                var photos = AllExportNotes[i].photos
                var notes = AllExportNotes[i].notes
                var notifi = AllExportNotes[i].notifi
                var Text = ""
                var Textnotifi = ""
                
                    if(photos.count >= 2 )
                    {
                        
                        var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                        Text.removeAll()
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            Text.appendContentsOf(notes[n].typeS)
                            Text.appendContentsOf(":  ")
                            Text.appendContentsOf(notes[n].text)
                        }
                        Textnotifi.removeAll()
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            Textnotifi.appendContentsOf(notifi[n].typeS)
                            Textnotifi.appendContentsOf(":  ")
                            Textnotifi.appendContentsOf(notifi[n].text)
                        }
                        
                        if(segmenttype){

                            image.image = CreateTextWithTwoPhotosBlue(photos[0], UpText: "", DownPhoto: photos[1], DownText: "", Title: String(AllExportNotes[i].date), CenterText: String(Text + "\n" + Textnotifi))
                            
                        }
                        else{
                            image.image = CreateTextWithTwoPhotosPink(photos[0], UpText: "", DownPhoto: photos[1], DownText: "", Title: String(AllExportNotes[i].date), CenterText: String(Text + "\n" + Textnotifi))
                        }
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                            y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        y += 20
                    }
                        
                    else if (photos.count < 2  && photos.count != 0)  {
                        
                        var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                        Text.removeAll()
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            Text.appendContentsOf(notes[n].typeS)
                            Text.appendContentsOf(":  ")
                            Text.appendContentsOf(notes[n].text)
                        }
                        Textnotifi.removeAll()
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            Textnotifi.appendContentsOf(notifi[n].typeS)
                            Textnotifi.appendContentsOf(":  ")
                            Textnotifi.appendContentsOf(notifi[n].text)
                        }
                        
                        if(segmenttype){
                            
                            image.image = CreateTextWithTwoPhotosBlue(photos[0], UpText: "", DownPhoto: photos[0], DownText: "", Title: String(AllExportNotes[i].date), CenterText: String(Text + "\n" + Textnotifi))
                            
                        }
                        else{
                            image.image = CreateTextWithTwoPhotosPink(photos[0], UpText: "", DownPhoto: photos[0], DownText: "", Title: String(AllExportNotes[i].date), CenterText: String(Text + "\n" + Textnotifi))
                        }
                        
                        // Добавить шаблон для 1 фотографии
                        
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                             y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        y += 20
                    }
                
                else if (photos.count == 0)
                    {
                        
                        var notes = AllExportNotes[i].notes
                        var notifi = AllExportNotes[i].notifi
                        var Text = ""
                        var Textnotifi = ""
                        
                        Text.removeAll()
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            Text.appendContentsOf(notes[n].typeS)
                            Text.appendContentsOf(":  ")
                            Text.appendContentsOf(notes[n].text)
                        }
                        Textnotifi.removeAll()
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            Textnotifi.appendContentsOf(notifi[n].typeS)
                            Textnotifi.appendContentsOf(":  ")
                            Textnotifi.appendContentsOf(notifi[n].text)
                        }
                        
                        var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                        
                        if(segmenttype){
                            image.image = CreateTextOnlyBlue(String(AllExportNotes[i].date) , CenterText: Text + "\n" + Textnotifi)
                        }
                        else{
                            image.image = CreateTextOnlyPink(String(AllExportNotes[i].date) , CenterText: Text + "\n" + Textnotifi)
                        }
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                             y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        y += 20
                        
                }

            
            }
            
            else if(AllExportNotes[i].photos.isEmpty && !AllExportNotes[i].notes.isEmpty || !AllExportNotes[i].notifi.isEmpty){
                
                var notes = AllExportNotes[i].notes
                var notifi = AllExportNotes[i].notifi
                var Text = ""
                var Textnotifi = ""

                Text.removeAll()
                for(var n = 0 ; n < notes.count ; n++)
                {
                    Text.appendContentsOf(notes[n].typeS)
                    Text.appendContentsOf(":  ")
                    Text.appendContentsOf(notes[n].text)
                }
                Textnotifi.removeAll()
                for(var n = 0 ; n < notifi.count ; n++)
                {
                    Textnotifi.appendContentsOf(notifi[n].typeS)
                    Textnotifi.appendContentsOf(":  ")
                    Textnotifi.appendContentsOf(notifi[n].text)
                }

                    var image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                
                    if(segmenttype){
                        image.image = CreateTextOnlyBlue(String(AllExportNotes[i].date) , CenterText: Text + "\n" + Textnotifi)
                    }
                    else{
                        image.image = CreateTextOnlyPink(String(AllExportNotes[i].date) , CenterText: Text + "\n" + Textnotifi)
                    }
                    if(CurrentScrollView.subviews.count >  0)
                    {
                        image.frame.origin.y = image.frame.height + y
                         y += image.frame.height
                    }
                    CurrentScrollView.addSubview(image)
                    y += 20
   
            }
        print(CurrentScrollView.subviews.count)
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
