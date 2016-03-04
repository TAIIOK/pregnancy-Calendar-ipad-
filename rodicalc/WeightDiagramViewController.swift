//
//  WeightDiagramTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit

class WeightDiagramViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,LineChartDelegate {
    
    var growth = 0
    var mass = 60
    var firstComponent = [0, 1, 2]
    var secondComponent = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var thirdComponent = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var lineChart: LineChart!
    var label = UILabel()
    var label1 = UILabel()
    
    let IMT0: [CGFloat] = [0.5,0.9,1.4,1.6,1.8,2.0,2.7,3.2,4.5,5.4,6.8,7.7,8.6,9.8,10.2,11.3,12.5,13.6,14.5,15.2]
    let IMT1: [CGFloat] = [0.5,0.7,1.0,1.2,1.3,1.5,1.9,2.3,3.6,4.8,5.7,6.4,7.7,8.2,9.1,10.0,10.9,11.9,12.7,13.6]
    let IMT2: [CGFloat] = [0.5,0.5,0.6,0.7,0.8,0.9,1.0,1.4,2.3,2.9,3.4,3.9,5.0,5.4,5.9,6.4,7.3,7.9,8.6,9.1]
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerViewTextField: UITextField!
    @IBOutlet weak var growthButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        growth = loadGrowthFromCoreData()
        self.navigationItem.rightBarButtonItem?.title = growth == 0 ? "Ваш рост" : "\(growth) см"
        setupGrowthPickerView()
        setupGrowthPickerViewToolbar()
        if (growth > 0){
            drawGraph()
        }
        else{
            var lbl = UILabel()
            let text = "Для отображения графика необходимо указать рост"
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = text
            lbl.textColor=UIColor.blueColor()
            lbl.textAlignment = NSTextAlignment.Center
            self.view.addSubview(lbl)
            var views: [String: AnyObject] = [:]
            views["label"] = lbl
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-300-[label]", options: [], metrics: nil, views: views))
        }
    }

    /**
     * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        //label.text = "x: \(x)     y: \(yValues)"
    }
    
    func drawGraph(){
        var views: [String: AnyObject] = [:]
        
        label.text = "                  Фактический вес"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Left
        label.textColor=StrawBerryColor
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-100-[label]", options: [], metrics: nil, views: views))
        
        label1.text = "                 Условно-рекомендуемая норма"
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.textAlignment = NSTextAlignment.Center
        label1.textColor=UIColor.blueColor()
        self.view.addSubview(label1)
        views["label1"] = label1
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-100-[label1]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-100-[label1]", options: [], metrics: nil, views: views))
        
        // simple arrays
        let ves = Double(mass)
        let rost = Double(growth)
        let a = CGFloat(51)
        
        var data: [CGFloat] = [51]
        
        let b = CGFloat(ves)
        var data1 : [CGFloat] = [b]
        
        var imt=ves*1000.0
        let x: Double = rost*rost
        imt = imt/x
        //var yLabels: [String] = ["\(rost)"]
        for (var i=0; i<20;i++){
            if(mass==0){data1.append(0)
            }
            else{
                if(imt < 18.5){
                    data1.append(b+IMT0[i])
                }
                else if (imt>=25){
                    data.append(b+IMT0[i])
                }
                else{
                    data1.append(b+IMT0[i])
                }
            }
            data.append(a+IMT2[i])
            //yLabels.append("\(data[i])")
        }
        
        // simple line with custom x axis labels
        let xLabels: [String] = ["0","2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36", "38", "40"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.x.labels.visible = true
        lineChart.y.labels.visible = true
        lineChart.x.grid.count = 21
        lineChart.y.grid.count = 21
        lineChart.x.labels.values = xLabels
        lineChart.x.axis.visible = true
        lineChart.x.axis.color = UIColor.blueColor()
        lineChart.addLine(data)
        lineChart.addLine(data1)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==500)]", options: [], metrics: nil, views: views))
    }
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    

    @IBAction func setHeight(sender: UIBarButtonItem) {
        self.pickerViewTextField.becomeFirstResponder()
    }
    
    private func setupGrowthPickerView()  {
        self.pickerViewTextField = UITextField(frame: CGRectZero)
        self.view.addSubview(self.pickerViewTextField)
        self.pickerView = UIPickerView(frame: CGRectMake(0, 0, 0, 0))
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = .whiteColor()
        self.pickerViewTextField.inputView = pickerView
        setupPickerViewValues()
    }
    
    private func setupPickerViewValues() {
        var rowIndex = growth
        self.pickerView.selectRow(rowIndex % 10, inComponent: 2, animated: true)
        rowIndex /= 10
        self.pickerView.selectRow(rowIndex % 10, inComponent: 1, animated: true)
        rowIndex /= 10
        self.pickerView.selectRow(rowIndex % 10, inComponent: 0, animated: true)
    }
    
    private func setupGrowthPickerViewToolbar() {
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, 320, 40))
        toolBar.tintColor = StrawBerryColor
        toolBar.barTintColor = .whiteColor()
        let doneButton = UIBarButtonItem(title: "Готово", style: .Plain, target: self, action: Selector("doneButtonTouched"))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .Plain, target: self, action: Selector("cancelButtonTouched"))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        self.pickerViewTextField.inputAccessoryView = toolBar
    }
    
    private func getGrowthFromPickerView() -> Int {
        return firstComponent[self.pickerView.selectedRowInComponent(0)]*100 + secondComponent[self.pickerView.selectedRowInComponent(1)]*10 + thirdComponent[self.pickerView.selectedRowInComponent(2)]
    }
    
    @available(iOS 8.0, *)
    func doneButtonTouched() {
        self.pickerViewTextField.resignFirstResponder()
        growth = getGrowthFromPickerView()
        self.navigationItem.rightBarButtonItem?.title = "\(growth) см"
        saveGrowthToPlist(growth)
        setupPickerViewValues()
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Теперь укажите свой вес в заметках, чтобы построить фактический график набора веса и отслеживать отклонения", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Заметки", style: .Default) { action -> Void in
            //Do some other stuff
            let notes = self.storyboard?.instantiateViewControllerWithIdentifier("NotesNavigator")
            self.splitViewController?.showDetailViewController(notes!, sender: self)
        }
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func cancelButtonTouched() {
        self.pickerViewTextField.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // save to plist
    private func saveGrowthToPlist(growth: Int) {
        if let plist = Plist(fileName: "userInfo") {
            let dict = plist.getMutablePlistFile()!
            dict[userGrowth] = growth
            
            do {
                try plist.addValuesToPlistFile(dict)
            } catch {
                print(error)
            }
        }
    }
    
    // load from plist
    private func loadGrowthFromCoreData() -> Int {
        if let plist = Plist(fileName: "userInfo") {
            let dict = plist.getValuesFromPlistFile()
            return (dict![userGrowth] as? Int)!
        } else {
            return 0
        }
    }
    
    // MARK: - UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return firstComponent.count
        } else if component == 1 {
            return secondComponent.count
        } else {
            return thirdComponent.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(firstComponent[row])"
        } else if component == 1 {
            return "\(secondComponent[row])"
        } else {
            return "\(thirdComponent[row])"
        }
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
