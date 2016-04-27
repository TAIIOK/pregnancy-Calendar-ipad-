//
//  WeightDiagramTableViewController.swift
//  rodicalc
//
//  Created by deck on 25.02.16.
//  Copyright © 2016 deck. All rights reserved.
//

import UIKit
import Charts

class WeightDiagramViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var growth = 0
    var mass = 60
    var firstComponent = [0, 1, 2]
    var secondComponent = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var thirdComponent = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var lineChart: LineChart!
    //var label = UILabel()
    //var label1 = UILabel()
    var views: [String: AnyObject] = [:]

    @IBOutlet weak var lbl: UILabel!
    let IMT0: [Double] = [0.5,0.9,1.4,1.6,1.8,2.0,2.7,3.2,4.5,5.4,6.8,7.7,8.6,9.8,10.2,11.3,12.5,13.6,14.5,15.2]
    let IMT1: [Double] = [0.5,0.7,1.0,1.2,1.3,1.5,1.9,2.3,3.6,4.8,5.7,6.4,7.7,8.2,9.1,10.0,10.9,11.9,12.7,13.6]
    let IMT2: [Double] = [0.5,0.5,0.6,0.7,0.8,0.9,1.0,1.4,2.3,2.9,3.4,3.9,5.0,5.4,5.9,6.4,7.3,7.9,8.6,9.1]
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerViewTextField: UITextField!
    @IBOutlet weak var growthButton: UIBarButtonItem!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        growth = loadGrowthFromCoreData()
        self.navigationItem.rightBarButtonItem?.title = growth == 0 ? "Ваш рост" : "\(growth) см"
        setupGrowthPickerView()
        setupGrowthPickerViewToolbar()
        setupGraphSettings()
        if (growth > 0){
            //lbl.hidden = true
            drawGraph()
            //drawDataDots(StrawBerryColor, X: 80 ,Y: 100)
            //drawDataDots(UIColor.blueColor(), X: 280 ,Y: 100)
        }
        else{
            //lbl.hidden = false
        }
    }

    /**
     * Line chart delegate method.
    */
    /*func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        //label.text = "x: \(x)     y: \(yValues)"
    }
    
    private func drawDataDots(color: UIColor, X: CGFloat, Y: CGFloat) {
        let dotLayer = DotCALayer()
        dotLayer.dotInnerColor = color
        dotLayer.innerRadius = 16
        
        dotLayer.frame = CGRect(x: X, y: Y, width: 16, height: 16)
        self.view.layer.addSublayer(dotLayer)
    }*/
    private func setupGraphSettings() {
        // общие настройки
        self.lineChartView.descriptionText = "КГ"
        self.lineChartView.descriptionTextPosition = CGPoint(x: 20, y: 60)
        self.lineChartView.noDataText = "Для отображения графика"
        self.lineChartView.noDataTextDescription = "необходимо указать рост"
        self.lineChartView.infoFont = .systemFontOfSize(18)
        self.lineChartView.infoTextColor = UIColor.cyanColor()
        self.lineChartView.scaleXEnabled = true
        self.lineChartView.scaleYEnabled = false
        self.lineChartView.pinchZoomEnabled = true
        self.lineChartView.rightAxis.enabled = false
        
        self.lineChartView.legend.form = .Circle
        self.lineChartView.xAxis.labelPosition = .Bottom
        self.lineChartView.legend.position = .AboveChartLeft
        self.lineChartView.legend.font = .systemFontOfSize(14)
        
        // оси
        self.lineChartView.xAxis.spaceBetweenLabels = 2
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = false
        self.lineChartView.leftAxis.drawGridLinesEnabled = false
    }
    
    private func drawGraph(){
        // сначала очистить график
        self.lineChartView.clear()
        
        // графики
        // нарисовать условно-рекомендуемый график
        let dataEntries = self.getChartDataEntriesForRecommend(Double(50))
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Условно-рекомендуемая норма")
        self.setRecommendSetStyle(lineChartDataSet)
        // нарисовать график фактического веса
        let weight = Double(mass)
        let growth_ = Double(growth)
        let dataEntriesSecond = self.getChartDataEntriesForFact(weight, growth: growth_)
        let lineChartDataSetSecond = LineChartDataSet(yVals: dataEntriesSecond, label: "Фактический вес")
        self.setFactSetStyle(lineChartDataSetSecond)
        
        // подписать недели
        var dataPoints: [String] = []
        for i in 0...40 {
            dataPoints.append("\(i)")
        }
        
        // готово
        let dataSets = [lineChartDataSetSecond, lineChartDataSet]
        self.lineChartView.data = LineChartData(xVals: dataPoints, dataSets: dataSets)
      }
    
    private func setRecommendSetStyle(lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.setColor(.cyanColor())
        lineChartDataSet.fillColor = .cyanColor()
        lineChartDataSet.setCircleColor(.cyanColor())
        lineChartDataSet.circleHoleColor = .cyanColor()
        lineChartDataSet.lineWidth = 1
        lineChartDataSet.circleRadius = 6
        lineChartDataSet.valueFont = .systemFontOfSize(0)
    }
    private func setFactSetStyle(lineChartDataSet: LineChartDataSet) {
        lineChartDataSet.setColor(StrawBerryColor)
        lineChartDataSet.fillColor = StrawBerryColor
        lineChartDataSet.setCircleColor(StrawBerryColor)
        lineChartDataSet.circleHoleColor = StrawBerryColor
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.circleRadius = 6
        lineChartDataSet.valueFont = .systemFontOfSize(0)
    }
    private func getChartDataEntriesForRecommend(weight: Double) -> [ChartDataEntry] {
        let weeks = self.getWeeks()
        var dataEntries: [ChartDataEntry] = []
        
        let dataEntry = ChartDataEntry(value: weight, xIndex: weeks[0])
        dataEntries.append(dataEntry)
        
        for i in 1..<weeks.count {
            let dataEntry = ChartDataEntry(value: weight + self.IMT2[i-1], xIndex: weeks[i])
            dataEntries.append(dataEntry)
        }

        return dataEntries
    }
    private func getChartDataEntriesForFact(weight: Double, growth: Double) -> [ChartDataEntry] {
        let weeks = self.getWeeks()
        var dataEntries: [ChartDataEntry] = []
        
        var imt=weight*10000.0
        let x: Double = growth*growth
        
        if(x>0){
            imt = imt/x}
        else{
            imt = 0
        }
        let dataEntry = ChartDataEntry(value: weight, xIndex: weeks[0])
        dataEntries.append(dataEntry)
        for i in 1..<weeks.count {
            if(weight==0){
                let dataEntry = ChartDataEntry(value: 0, xIndex: weeks[i])
                dataEntries.append(dataEntry)
            }
            else{
                if(imt < 18.5){
                    let dataEntry = ChartDataEntry(value: weight + self.IMT0[i-1], xIndex: weeks[i])
                    dataEntries.append(dataEntry)
                }
                else if (imt >= 25){
                    let dataEntry = ChartDataEntry(value: weight + self.IMT1[i-1], xIndex: weeks[i])
                    dataEntries.append(dataEntry)
                }
                else{
                    let dataEntry = ChartDataEntry(value: weight + self.IMT2[i-1], xIndex: weeks[i])
                    dataEntries.append(dataEntry)
                }
            }
        }
        
        return dataEntries
    }
    private func getWeeks() -> [Int] {
        var weeks: [Int] = []
        
        for var i = 0; i <= 40; i += 2 {
            weeks.append(i)
        }
        
        return weeks
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
    
    func doneButtonTouched() {
        self.pickerViewTextField.resignFirstResponder()
        growth = getGrowthFromPickerView()

        self.navigationItem.rightBarButtonItem?.title = "\(growth) см"
        saveGrowthToPlist(growth)
        setupPickerViewValues()
        
        //Create the AlertController
        if #available(iOS 8.0, *) {
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Теперь укажите свой вес в заметках, чтобы построить фактический график набора веса и отслеживать отклонения", preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .Cancel) { action -> Void in
            //Do some stuff
                let graph = self.storyboard?.instantiateViewControllerWithIdentifier("Graph")
                self.splitViewController?.showDetailViewController(graph!, sender: self)
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
        } else {
            // Fallback on earlier versions
        }

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
}
