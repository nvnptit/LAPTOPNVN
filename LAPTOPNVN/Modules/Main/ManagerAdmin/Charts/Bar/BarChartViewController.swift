//
//  BarChartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 26/11/2022.
//

import UIKit
import Charts
import DropDown

class BarChartViewController: UIViewController {
    
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var dropDownYear: UIView!
    @IBOutlet weak var lbYear: UILabel!
    var yearValues: [String] = []
    var dropYear = DropDown()
    
    var year: String = ""
    
    @IBOutlet weak var barChartView: BarChartView!
    
    
    var sum: Int = 0
    var data: [DoanhThuResponse] = []
    var allDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Biểu đồ doanh thu theo năm"
        setupDropDown()
        barChartView.noDataText = "Bạn cần chọn khung thời gian cần để hiển thị biểu đồ"
        barChartView.maxVisibleCount = 20
        lbYear.text = Date().toDate(format: "yyyy")
        getDataYears()
        dropYear.selectRows(at: [yearValues.endIndex - 1] )
        loadDataDoanhThu()
    }
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    func setupChart(){
        barChartView.noDataText = "You need to provide data for the chart."
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartView.marker = marker
        
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
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelCount = 12
        xAxis.granularity = 1
        
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
//        xAxis.labelRotationAngle = 90
        
        xAxis.valueFormatter = IndexAxisValueFormatter(values:  data.map { "\($0.thang!)" })
        xAxis.axisLineColor = .chartLineColour
        xAxis.labelTextColor = .chartLineColour

        // Setup left axis
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.numberStyle = .currencyAccounting
        leftAxisFormatter.negativeSuffix = " VND"
        leftAxisFormatter.positiveSuffix = " VND"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        
        leftAxis.drawTopYLabelEntryEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
//        leftAxis.granularityEnabled = true
        leftAxis.granularity = 1
        leftAxis.axisLineColor = .chartLineColour
        leftAxis.labelTextColor = .chartLineColour
//        leftAxis.axisMinimum = 0
//        leftAxis.axisMaximum = 1

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
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Biểu đồ doanh thu các tháng trong năm")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
}
extension BarChartViewController{
    func loadDataDoanhThu(){
        self.lbTitle.text = "BIỂU ĐỒ DOANH THU NĂM \(self.lbYear.text!)"
        let from =  self.lbYear.text! + "-01-01"
        let to = self.lbYear.text! + "-12-31"
        let to1 = to + " 23:59:59"
        
        var data1: [DoanhThuResponse] = []
        let params = DoanhThuModel(dateFrom: from, dateTo: to1 ).convertToDictionary()
        print(params)
        DispatchQueue.init(label: "DoanhThuVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getDoanhThu(with: .getDoanhThu, params: params, headers: nil, completion:
                 {  base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.allDates = self.getMonthAndYearBetween(from: from, to: to)
                    print("allDates: \(self.allDates)")
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
                            print("DATA__1: \(data1)")
                        }
                        self.data = data1
                        print("AAA\n")
                        print(self.data)
                        print("\nAAA")
                        var dataChart: [String] = []
                        var valueChart: [Double] = []
                        for item in data1{
//                            dataChart.append("\(String(describing: item.thang)) / \(String(describing: item.nam))")
                            dataChart.append("\(String(describing: item.thang))")
                            valueChart.append(Float64(item.doanhthu ?? 0))
                        }
                        print(dataChart)
                        print(valueChart)
                        self.setupChart()
                        self.setChart(dataPoints: dataChart, values: valueChart.map { Double($0) })
                    }
                   // TONG DOANH THU: CurrencyVN.toVND(self.sum)
                } else {
                    print("ERROR: loaddatadoanhthu")
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

extension BarChartViewController{
    private func setupYear() {
        dropYear.anchorView = dropDownYear
        dropYear.dataSource = yearValues
        dropYear.bottomOffset = CGPoint(x: 0, y:(dropYear.anchorView?.plainView.bounds.height)! + 5)
        dropYear.direction = .bottom
        dropYear.selectionAction = { [unowned self] (index: Int, item: String) in
            self.year = item
            lbYear.text = item
            loadDataDoanhThu()
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didYear))
        dropDownYear.addGestureRecognizer(gestureClock)
        dropDownYear.layer.borderWidth = 1
        dropDownYear.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didYear() {
        dropYear.show()
    }
    
    private func getDataYears(){
       let currentYear = Date().toDate(format: "yyyy")
        for item in 2010...Int(currentYear)! {
            yearValues.append("\(item)")
        }
        self.setupYear()
        print("YEARVALUÉ:\n \(yearValues)")
    }
}       
