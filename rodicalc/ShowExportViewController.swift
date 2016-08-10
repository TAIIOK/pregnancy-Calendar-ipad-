//
//  ShowExportViewController.swift
//  Календарь беременности
//
//  Created by Roman Efimov on 27.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

var segmenttype = true
var PDF = NSData()
class ShowExportViewController: UIViewController , UIScrollViewDelegate  {

    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var CurrentScrollView: UIScrollView!
    
    @IBAction func SegmentAction(sender: AnyObject) {
        segmenttype = segmenttype ? false : true
        self.view.makeToastActivityWithMessage(message: "Пожалуйста, подождите.", addOverlay: true)
        dispatch_async(dispatch_get_main_queue(), {
            self.loadExportImages()
            self.view.hideToastActivity()
            return
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //addControls()
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        if segmenttype {
            Segment.selectedSegmentIndex = 0
        }else{
            Segment.selectedSegmentIndex = 1
        }
        
        CurrentScrollView.delegate = self
        CurrentScrollView.userInteractionEnabled = true
        CurrentScrollView.scrollEnabled = true
        //loadExportImages()
        sharingExportVk = true
        self.view.makeToastActivityWithMessage(message: "Пожалуйста, подождите.", addOverlay: true)
        dispatch_async(dispatch_get_main_queue(), {
            self.loadExportImages()
            self.view.hideToastActivity()
            return
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        sharingExportVk  = false
        PDF = NSData()
    }
    
    func loadExportImages()
    {
        selectedImages.removeAll()
        CurrentScrollView.removeAllSubviews()
        
        let height =  CGFloat(integerLiteral:  620 * AllExportNotes.count + 620 )
         CurrentScrollView.contentSize = CGSizeMake(700 , height)
        
        var y = CGFloat(integerLiteral: 0)
        
        if(segmenttype){
            CurrentScrollView.addSubview(CreateTitleBlue())
            selectedImages.append(CreateTitleBlue().image!)}
        else{
            CurrentScrollView.addSubview(CreateTitlePink())
            selectedImages.append(CreateTitlePink().image!)}
        
        y += 20
        
        for( var i = 0;i < AllExportNotes.count ; i++)
        {

            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: AllExportNotes[i].date)
            
            var string = ""
            if(components.month<10)
            {
                string = "0\(components.month)"
            }
            else
            {
                string = "\(components.month)"
            }
            
            var stringday = ""
            if(components.day<10)
            {
                stringday = "0\(components.day)"
            }
            else
            {
                stringday = "\(components.day)"
            }
            
            
            let dateString = "\(stringday).\(string).\(components.year)"
            
            if(!AllExportNotes[i].photos.isEmpty && AllExportNotes[i].notes.isEmpty && AllExportNotes[i].notifi.isEmpty)
            {
                var photos = AllExportNotes[i].photos
                let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                if(photos.count >= 2 ){
                if(segmenttype){
                image.image = CreateTwoPhotosBlue(photos[0].image, right: photos[1].image, title: dateString , leftText: photos[0].text, rightText: photos[1].text)
                }
                else{
                image.image = CreateTwoPhotosPink(photos[0].image, right: photos[1].image, title: dateString , leftText: photos[0].text, rightText: photos[1].text)
                      }
                            }
                            
                            else if (photos.count < 2 )  {
                                if(segmenttype){
                                image.image = CreateTwoPhotosBlue(photos[0].image, right: photos[0].image, title: dateString , leftText: photos[0].text, rightText: photos[0].text)
                                }
                                else{
                                image.image = CreateTwoPhotosPink(photos[0].image, right: photos[0].image, title: dateString , leftText: photos[0].text, rightText: photos[0].text)
                                }
                            }
                
                if(CurrentScrollView.subviews.count > 0)
                {
                    image.frame.origin.y = image.frame.height + y
                    y += image.frame.height
                }
                CurrentScrollView.addSubview(image)
                y += 20
                selectedImages.append(image.image!)

            }
            else if(!AllExportNotes[i].photos.isEmpty && !AllExportNotes[i].notes.isEmpty || !AllExportNotes[i].notifi.isEmpty){
                
                var photos = AllExportNotes[i].photos
                var notes = AllExportNotes[i].notes
                var notifi = AllExportNotes[i].notifi
                var attrText = NSMutableAttributedString()
                var attrTextnotifi = NSMutableAttributedString()
                let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                    if(photos.count >= 2 )
                    {
                        var mas = [Int]()
                        attrText.deleteCharactersInRange(NSRange(location: 0,length: attrText.length))
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            if notes[n].typeS == "Посещения врачей" && !mas.contains(0){
                                mas.append(0)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Принимаемые лекарства" && !mas.contains(1){
                                mas.append(1)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Моё меню на сегодня" && !mas.contains(2){
                                mas.append(2)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS != "Посещения врачей" && notes[n].typeS != "Принимаемые лекарства" && notes[n].typeS != "Моё меню на сегодня"{
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ": "))
                            }else{
                                attrText.appendAttributedString(NSMutableAttributedString(string: "\t- "))
                            }
                            var tmp = NSMutableAttributedString(string: notes[n].text)
                            attrText.appendAttributedString(tmp)
                            attrText.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        mas.removeAll()
                        attrTextnotifi.deleteCharactersInRange(NSRange(location: 0,length: attrTextnotifi.length))
                        
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            var tmp = NSMutableAttributedString(string: notifi[n].typeS)
                            tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: ": "))
                            tmp = NSMutableAttributedString(string: notifi[n].text)
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        
                        var centertext = NSMutableAttributedString()
                        attrText.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrText.length))
                        attrTextnotifi.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrTextnotifi.length))
                        centertext.appendAttributedString(attrText)
                        if notifi.count > 0{
                            let uved = NSMutableAttributedString(string: "Уведомления\n\n", attributes: [NSForegroundColorAttributeName: BiruzaColor1])
                            uved.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: uved.length))
                            centertext.appendAttributedString(uved)
                        }
                        centertext.appendAttributedString(attrTextnotifi)
                        if(segmenttype){
                            image.image = CreateTextWithTwoPhotosBlue(photos[0].image, UpText: photos[0].text, DownPhoto: photos[1].image, DownText: photos[1].text, Title: dateString, CenterText: centertext)
                        }
                        else{
                            image.image = CreateTextWithTwoPhotosPink(photos[0].image, UpText: photos[0].text, DownPhoto: photos[1].image, DownText: photos[1].text, Title: dateString, CenterText: centertext)
                        }
                        
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                            y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        selectedImages.append(image.image!)
                        y += 20
                    }
                        
                    else if (photos.count < 2  && photos.count != 0)  {
                        
                        let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                        var mas = [Int]()
                        attrText.deleteCharactersInRange(NSRange(location: 0,length: attrText.length))
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            if notes[n].typeS == "Посещения врачей" && !mas.contains(0){
                                mas.append(0)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Принимаемые лекарства" && !mas.contains(1){
                                mas.append(1)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Моё меню на сегодня" && !mas.contains(2){
                                mas.append(2)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS != "Посещения врачей" && notes[n].typeS != "Принимаемые лекарства" && notes[n].typeS != "Моё меню на сегодня"{
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ": "))
                            }else{
                                attrText.appendAttributedString(NSMutableAttributedString(string: "\t- "))
                            }
                            var tmp = NSMutableAttributedString(string: notes[n].text)
                            attrText.appendAttributedString(tmp)
                            attrText.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        mas.removeAll()
                        attrTextnotifi.deleteCharactersInRange(NSRange(location: 0,length: attrTextnotifi.length))
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            var tmp = NSMutableAttributedString(string: notifi[n].typeS)
                            tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: ": "))
                            tmp = NSMutableAttributedString(string: notifi[n].text)
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        var centertext = NSMutableAttributedString()
                        attrText.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrText.length))
                        attrTextnotifi.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrTextnotifi.length))
                        centertext.appendAttributedString(attrText)
                        if notifi.count > 0{
                            let uved = NSMutableAttributedString(string: "Уведомления\n\n", attributes: [NSForegroundColorAttributeName: BiruzaColor1])
                            uved.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: uved.length))
                            centertext.appendAttributedString(uved)
                        }
                        centertext.appendAttributedString(attrTextnotifi)
                        if(segmenttype){
                            image.image = CreateTextWithTwoPhotosBlue(photos[0].image, UpText: photos[0].text, DownPhoto: photos[0].image, DownText: photos[0].text, Title: dateString , CenterText: centertext)
                        }
                        else{
                            image.image = CreateTextWithTwoPhotosPink(photos[0].image, UpText: photos[0].text, DownPhoto: photos[0].image, DownText: photos[0].text, Title: dateString , CenterText: centertext)
                        }
                        
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                             y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        selectedImages.append(image.image!)
                        y += 20
                    }
                
                else if (photos.count == 0)
                    {
                        let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                        var notes = AllExportNotes[i].notes
                        var notifi = AllExportNotes[i].notifi
                        var attrText = NSMutableAttributedString()
                        var attrTextnotifi = NSMutableAttributedString()
                        var mas = [Int]()
                        attrText.deleteCharactersInRange(NSRange(location: 0,length: attrText.length))
                        for(var n = 0 ; n < notes.count ; n++)
                        {
                            if notes[n].typeS == "Посещения врачей" && !mas.contains(0){
                                mas.append(0)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Принимаемые лекарства" && !mas.contains(1){
                                mas.append(1)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS == "Моё меню на сегодня" && !mas.contains(2){
                                mas.append(2)
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                            }
                            if notes[n].typeS != "Посещения врачей" && notes[n].typeS != "Принимаемые лекарства" && notes[n].typeS != "Моё меню на сегодня"{
                                var tmp = NSMutableAttributedString(string: notes[n].typeS)
                                tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                                attrText.appendAttributedString(tmp)
                                attrText.appendAttributedString(NSMutableAttributedString(string: ": "))
                            }else{
                                attrText.appendAttributedString(NSMutableAttributedString(string: "\t- "))
                            }
                            var tmp = NSMutableAttributedString(string: notes[n].text)
                            attrText.appendAttributedString(tmp)
                            attrText.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        mas.removeAll()
                        attrTextnotifi.deleteCharactersInRange(NSRange(location: 0,length: attrTextnotifi.length))
                        for(var n = 0 ; n < notifi.count ; n++)
                        {
                            var tmp = NSMutableAttributedString(string: notifi[n].typeS)
                            tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: ": "))
                            tmp = NSMutableAttributedString(string: notifi[n].text)
                            attrTextnotifi.appendAttributedString(tmp)
                            attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                        }
                        var centertext = NSMutableAttributedString()
                        attrText.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrText.length))
                        attrTextnotifi.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrTextnotifi.length))
                        centertext.appendAttributedString(attrText)
                        if notifi.count > 0{
                            let uved = NSMutableAttributedString(string: "Уведомления\n\n", attributes: [NSForegroundColorAttributeName: BiruzaColor1])
                            uved.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: uved.length))
                            centertext.appendAttributedString(uved)
                        }
                        centertext.appendAttributedString(attrTextnotifi)

                        if(segmenttype){
                            image.image = CreateTextOnlyBlue(dateString , CenterText: centertext)
                        }
                        else{
                            image.image = CreateTextOnlyPink(dateString , CenterText: centertext)
                        }
                        if(CurrentScrollView.subviews.count > 0)
                        {
                            image.frame.origin.y = image.frame.height + y
                             y += image.frame.height
                        }
                        CurrentScrollView.addSubview(image)
                        selectedImages.append(image.image!)
                        y += 20
                        
                }

            
            }
            
            else if(AllExportNotes[i].photos.isEmpty && !AllExportNotes[i].notes.isEmpty || !AllExportNotes[i].notifi.isEmpty){
                let image = UIImageView(frame: CGRect(x: 0, y: 0 , width: 700, height: 600))
                var notes = AllExportNotes[i].notes
                var notifi = AllExportNotes[i].notifi
                var attrText = NSMutableAttributedString()
                var attrTextnotifi = NSMutableAttributedString()

                var mas = [Int]()
                attrText.deleteCharactersInRange(NSRange(location: 0,length: attrText.length))
                for(var n = 0 ; n < notes.count ; n++)
                {
                    if notes[n].typeS == "Посещения врачей" && !mas.contains(0){
                        mas.append(0)
                        var tmp = NSMutableAttributedString(string: notes[n].typeS)
                        tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                        attrText.appendAttributedString(tmp)
                        attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                    }
                    if notes[n].typeS == "Принимаемые лекарства" && !mas.contains(1){
                        mas.append(1)
                        var tmp = NSMutableAttributedString(string: notes[n].typeS)
                        tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                        attrText.appendAttributedString(tmp)
                        attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                    }
                    if notes[n].typeS == "Моё меню на сегодня" && !mas.contains(2){
                        mas.append(2)
                        var tmp = NSMutableAttributedString(string: notes[n].typeS)
                        tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                        attrText.appendAttributedString(tmp)
                        attrText.appendAttributedString(NSMutableAttributedString(string: ":\n"))
                    }
                    if notes[n].typeS != "Посещения врачей" && notes[n].typeS != "Принимаемые лекарства" && notes[n].typeS != "Моё меню на сегодня"{
                        var tmp = NSMutableAttributedString(string: notes[n].typeS)
                        tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                        attrText.appendAttributedString(tmp)
                        attrText.appendAttributedString(NSMutableAttributedString(string: ": "))
                    }else{
                        attrText.appendAttributedString(NSMutableAttributedString(string: "\t- "))
                    }
                    var tmp = NSMutableAttributedString(string: notes[n].text)
                    attrText.appendAttributedString(tmp)
                    attrText.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                }
                mas.removeAll()
                attrTextnotifi.deleteCharactersInRange(NSRange(location: 0,length: attrTextnotifi.length))
                for(var n = 0 ; n < notifi.count ; n++)
                {
                    var tmp = NSMutableAttributedString(string: notifi[n].typeS)
                    tmp.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: tmp.length))
                    attrTextnotifi.appendAttributedString(tmp)
                    attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: ": "))
                    tmp = NSMutableAttributedString(string: notifi[n].text)
                    attrTextnotifi.appendAttributedString(tmp)
                    attrTextnotifi.appendAttributedString(NSMutableAttributedString(string: "\n\n"))
                }
                var centertext = NSMutableAttributedString()
                attrText.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrText.length))
                attrTextnotifi.addAttributes([NSForegroundColorAttributeName: BiruzaColor1], range: NSRange(location: 0,length: attrTextnotifi.length))
                centertext.appendAttributedString(attrText)
                if notifi.count > 0{
                    let uved = NSMutableAttributedString(string: "Уведомления\n\n", attributes: [NSForegroundColorAttributeName: BiruzaColor1])
                    uved.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(13)], range: NSRange(location: 0,length: uved.length))
                    centertext.appendAttributedString(uved)
                }
                centertext.appendAttributedString(attrTextnotifi)


                    if(segmenttype){
                        image.image = CreateTextOnlyBlue(dateString, CenterText: centertext)
                    }
                    else{
                        image.image = CreateTextOnlyPink(dateString , CenterText: centertext)
                    }
                    if(CurrentScrollView.subviews.count >  0)
                    {
                        image.frame.origin.y = image.frame.height + y
                         y += image.frame.height
                    }
                    CurrentScrollView.addSubview(image)
                    selectedImages.append(image.image!)
                    y += 20
   
            }
            else {
                CurrentScrollView.contentSize = CGSizeMake(700 , CurrentScrollView.contentSize.height -  620)
            }
            PDF = toPDF(CurrentScrollView.subviews)!
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
