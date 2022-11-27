//
//  BarChartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 26/11/2022.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTo: UITextField!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    var sum: Int = 0
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var data: [DoanhThuResponse] = []
    var allDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "Bạn cần chọn khung thời gian cần để hiển thị biểu đồ"
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupChart(){
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.animate(yAxisDuration: 3.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = true
//        barChartView.chartDescription.text = "NVN"
        
        
        // Setup X axis
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = 90
        xAxis.valueFormatter = IndexAxisValueFormatter(values:  data.map { "\($0.thang!)/\($0.nam!)" })
        xAxis.axisLineColor = .chartLineColour
        xAxis.labelTextColor = .chartLineColour

        // Setup left axis
        let leftAxis = barChartView.leftAxis
        leftAxis.drawTopYLabelEntryEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        leftAxis.granularity = 1
        leftAxis.axisLineColor = .chartLineColour
        leftAxis.labelTextColor = .chartLineColour
//        leftAxis.setLabelCount(5, force: false)
//        leftAxis.axisMinimum = 0.0
//        leftAxis.axisMaximum = 2.5

        // Remove right axis
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false
    }
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
}
extension BarChartViewController{
    func loadDataDoanhThu(){
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        
        var data1: [DoanhThuResponse] = []
        let params = DoanhThuModel(dateFrom: from, dateTo: to).convertToDictionary()
        
        DispatchQueue.init(label: "DoanhThuVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getDoanhThu(with: .getDoanhThu, params: params, headers: nil, completion:
                 {  base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let dateStart = from , let dateEnd = to {
                        self.allDates = self.getMonthAndYearBetween(from: dateStart, to: dateEnd)
                    }
                    for i in self.allDates {
                        data1.append(DoanhThuResponse(thang: Int(i.prefix(2)), nam: Int(i.suffix(4)) , doanhthu: 0))                    }
                    
                    if let data = base.data {
                      self.data = data
                        self.sum = 0
                        for i in data {
                            if let money = i.doanhthu{
                                self.sum = self.sum + money
                            }
                            data1 = data1.map {  $0.thang == i.thang && $0.nam == i.nam ? i : $0}
                        }
                        self.data = data1
                        print("AAA\n")
                        print(self.data)
                        print("\nAAA")
                        var dataChart: [String] = []
                        var valueChart: [Double] = []
                        for item in data1{
                            dataChart.append("\(String(describing: item.thang)) / \(String(describing: item.nam))")
                            valueChart.append(Float64(item.doanhthu ?? 0))
                        }
                        print(dataChart)
                        print(valueChart)
                        self.setupChart()
                        self.setChart(dataPoints: dataChart, values: valueChart.map { Double($0) })
                    }
                   // TONG DOANH THU: CurrencyVN.toVND(self.sum)
                } else {
                    print("ERROR: \(base.success)")
                }
            })
            
            
        }
        
    }
    
}

extension BarChartViewController{
    //MARK: - Setup keyboard, user
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height + 70
//        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}

extension BarChartViewController{
    //MARK: - Datepicker
    private func createToolbar(_ datePickerView: UIDatePicker) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapOnView))
        switch (datePickerView){
            case datePicker1:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker1))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            case datePicker2:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker2))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            default: break
                
        }
        
        return toolbar
    }
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker1.preferredDatePickerStyle = .wheels
        datePicker2.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker1.preferredDatePickerStyle = .inline
            datePicker2.preferredDatePickerStyle = .inline
        }
        
        datePicker1.datePickerMode = .date
        tfFrom.inputView = datePicker1
        tfFrom.inputAccessoryView = createToolbar(datePicker1)
        
        datePicker2.datePickerMode = .date
        tfTo.inputView = datePicker2
        tfTo.inputAccessoryView = createToolbar(datePicker2)
    }
    
    @objc func donedatePicker1() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfFrom.text =  dateFormatter.string(from: datePicker1.date)
        view.endEditing(true)
        loadDataDoanhThu()
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfTo.text =  dateFormatter.string(from: datePicker2.date)
        view.endEditing(true)
        loadDataDoanhThu()
    }
}



extension BarChartViewController{
    func getMonthAndYearBetween(from start: String, to end: String) -> [String] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"

        guard let startDate = format.date(from: start),
            let endDate = format.date(from: end) else {
                return []
        }

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(Set([.month]), from: startDate, to: endDate)

        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MM-yyyy"

        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: startDate) else {
            continue
            }

            let formattedDate = dateRangeFormatter.string(from: date)
            allDates += [formattedDate]
        }
        return allDates
    }
}



extension UIColor {
    static let chartBarColour = #colorLiteral(red: 1, green: 0.831372549, blue: 0.3764705882, alpha: 1)
    static let chartLineColour = #colorLiteral(red: 0.1764705882, green: 0.2509803922, blue: 0.3490196078, alpha: 1)
    static let chartReplacementColour = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3333333333, alpha: 1)
    static let chartAverageColour = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3333333333, alpha: 1)
    static let chartBarValueColour = #colorLiteral(red: 0.9411764706, green: 0.4823529412, blue: 0.2470588235, alpha: 1)
    static let chartHightlightColour = #colorLiteral(red: 0.9411764706, green: 0.4823529412, blue: 0.2470588235, alpha: 1)
}
