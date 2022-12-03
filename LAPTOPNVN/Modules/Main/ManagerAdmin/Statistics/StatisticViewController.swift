//
//  StatisticViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import UIKit
import NVActivityIndicatorView

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tongDoanhThu: UILabel!
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    var sum: Int = 0
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var data: [DoanhThuResponse] = []
    var allDates: [String] = []
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thống kê doanh thu"
        setupAnimation()
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "StatTableViewCell", bundle: nil), forCellReuseIdentifier: "StatTableViewCell")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool = false) {
//        loadDataDoanhThu()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataDoanhThu(){
        loading.startAnimating()
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        var to1: String?
        if (to != nil){
            to1 = to! + " 23:59:59"
        }
        var data1: [DoanhThuResponse] = []
        let params = DoanhThuModel(dateFrom: from, dateTo: to1).convertToDictionary()
        
        DispatchQueue.init(label: "DoanhThuVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getDoanhThu(with: .getDoanhThu, params: params, headers: nil, completion:
                 {  base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let dateStart = from , let dateEnd = to {
                        self.allDates = self.getMonthAndYearBetween(from: dateStart, to: dateEnd)
                    }
                    for i in self.allDates {
                        data1.append(DoanhThuResponse(thang: Int(i.prefix(2)), nam: Int(i.suffix(4)) , doanhthu: 0))
                    }
                    
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
                    }
                    self.tongDoanhThu.text = CurrencyVN.toVND(self.sum)
                } else {
                    print("ERROR: \(base.success)")
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.loading.stopAnimating()
                }
            })
        }
        
    }
    
    @IBAction func tapPieChart(_ sender: UIButton, forEvent event: UIEvent) {
            let vc = PieChartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapBarChart(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = BarChartViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension StatisticViewController{
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
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 70
        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}

// History

extension StatisticViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatTableViewCell", for: indexPath) as! StatTableViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let item = data[indexPath.item]
        cell.date.text = "\(item.thang!)-\(item.nam!)"
        cell.money.text = "\(CurrencyVN.toVND(item.doanhthu!))"
        cell.selectionStyle = .none
        return cell
    }
}


extension StatisticViewController{
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

extension Date {
    func startOfMonth(dat: Date) -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: dat)))!
    }
    
    func endOfMonth(dat: Date) -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(dat: dat))!
    }
}


extension StatisticViewController{
    func getMonthAndYearBetween(from start: String, to end: String) -> [String] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"

        guard let startDate = format.date(from: start),
            let endDate = format.date(from: end) else {
                return []
        }
        
//        let startOfMonth = startDate.beginning(of: .month)
//        let endOfMonth = endDate.end(of: .month)
        let startOfMonth = Date().startOfMonth(dat:startDate)
        let endOfMonth =  Date().endOfMonth(dat:endDate)
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(Set([.month]), from: startOfMonth, to: endOfMonth)

        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MM-yyyy"
        
        guard startDate < endDate else { return allDates }
    
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
