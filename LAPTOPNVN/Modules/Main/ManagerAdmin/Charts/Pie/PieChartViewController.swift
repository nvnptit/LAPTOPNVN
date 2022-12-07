//
//  PieChartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 26/11/2022.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var sld: UILabel!
    @IBOutlet weak var slg: UILabel!
    @IBOutlet weak var sldg: UILabel!
    @IBOutlet weak var slh: UILabel!
    
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTo: UITextField!
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    func initDataStatusOrder(){
              self.sld.text = "0"
              self.sldg.text = "0"
              self.slg.text = "0"
              self.slh.text = "0"
    }
    @IBOutlet weak var pieChartView: PieChartView!
    var dataPie: [DataPieResponse] = []
    override func viewDidLoad() {
      super.viewDidLoad()
        self.title = "Biểu đồ trạng thái đơn hàng"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tfFrom.text = Date().toDate(format: "dd-MM-yyyy")
            self.tfTo.text = Date().toDate(format: "dd-MM-yyyy")
            self.getDataPie()
        }
        
        setupKeyboard()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
//        pieChartView.centerText = "SỐ LIỆU ĐƠN HÀNG"
      
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
      
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
        format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      
      // 4. Assign it to the chart's data
      pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}

struct DateChartModel : Encodable{
    let dateFrom: String?
    let dateTo: String?
}
extension PieChartViewController{
        private func getDataPie(){
            initDataStatusOrder()
            let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
            let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
            var to1: String?
            if (to != nil){
                to1 = to! + " 23:59:59"
            }
            let params = DateChartModel(dateFrom: from, dateTo: to1).convertToDictionary()
            print(params)
            
            APIService.fetchAllStatusOrder(with: .getAllStatusOrderByDate, params: params, headers: nil, completion: {
                base, error in
                guard let base = base else { return }
                if base.success == true {
                    self.dataPie = base.data ?? []
                    var  sum = 0
//                    let statusValues: [String] = ["Chờ duyệt","Đang giao hàng","Đã giao hàng","Đã huỷ"]
                        for it in self.dataPie {
                            switch (it.tentrangthai){
                                case "Chờ duyệt":
                                    self.sld.text = "\(it.soluong ?? 0) "
                                case "Đang giao hàng":
                                    self.sldg.text = "\(it.soluong ?? 0)"
                                case "Đã giao hàng":
                                    self.slg.text = "\(it.soluong ?? 0)"
                                case "Đã huỷ":
                                    self.slh.text = "\(it.soluong ?? 0)"
                                case .none:
                                    continue
                                case .some(_):
                                    continue
                            }
                            
                            sum = sum + (it.soluong ?? 0)
                            
                    }
                    var dataChart: [String] = []
                    var valueChart: [Double] = []
                    for item in self.dataPie {
                        dataChart.append(item.tentrangthai ?? "")
                        valueChart.append(Float64(item.soluong ?? 0)/Double(sum)*100) //
                    }
                    self.customizeChart(dataPoints: dataChart, values: valueChart.map{ Double($0) })
                } else {
                    let alert = UIAlertController(title:"Lỗi get data pie", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
            })
        }
}

extension PieChartViewController{
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
        getDataPie()
        view.endEditing(true)
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfTo.text =  dateFormatter.string(from: datePicker2.date)
        getDataPie()
        view.endEditing(true)
    }
}

extension PieChartViewController{
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
