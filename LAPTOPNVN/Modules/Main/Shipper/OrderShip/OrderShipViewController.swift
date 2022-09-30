//
//  OrderShipViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 08/08/2022.
//

import UIKit
import DropDown
import NVActivityIndicatorView

class OrderShipViewController: UIViewController {
    
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfFrom: UITextField!
    
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var dropdownStatus: UIView!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var maStatus = 1
    var statusDrop = DropDown()
    let statusValues: [String] = ["Đang giao hàng","Đã giao hàng"]
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var dataHistory: [HistoryOrder1] = []
    
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
        if let name = UserService.shared.infoNV?.ten{
            lbWelcome.text = "Chào mừng bạn,\(name)"
        }
        setupDropDown()
        setupStatus()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        setupAnimation()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryOrderTableViewCell")
        status.text = "Đang giao hàng"
    }
    
    
    override func viewDidAppear(_ animated: Bool = false) {
        //        self.navigationController?.isNavigationBarHidden = true
        loadDataHistory()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func tapLogout(_ sender: UIButton, forEvent event: UIEvent) {
        UserService.shared.removeAllNV()
        let vc = LoginViewController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func loadDataHistory(){
        loading.startAnimating()
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        guard let maNV = UserService.shared.infoNV?.manv else {return}
        let params = ShipperModel(manv: maNV, dateFrom: from, dateTo: to, status: self.maStatus).convertToDictionary()
        print(params)
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getOrderShipper(with: .getOrderShipper, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        self.dataHistory = data
                    }
                } else {
                    print(base.success)
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.loading.stopAnimating()
                }
            })
        }
        
    }
    
    
    // BEGIN STATUS
    
    private func setupStatus() {
        statusDrop.anchorView = dropdownStatus
        statusDrop.dataSource = statusValues
        statusDrop.bottomOffset = CGPoint(x: 0, y:(statusDrop.anchorView?.plainView.bounds.height)! + 5)
        statusDrop.direction = .bottom
        statusDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.status.text = item
            self.maStatus = index+1
            loadDataHistory()
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapStatus))
        dropdownStatus.addGestureRecognizer(gestureClock)
        dropdownStatus.layer.borderWidth = 1
        dropdownStatus.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapStatus() {
        statusDrop.show()
    }
    
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    // END STATUS
    
}

extension OrderShipViewController{
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
        loadDataHistory()
        view.endEditing(true)
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfTo.text =  dateFormatter.string(from: datePicker2.date)
        loadDataHistory()
        view.endEditing(true)
    }
}

extension OrderShipViewController{
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
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}

// History

extension OrderShipViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderTableViewCell", for: indexPath) as! HistoryOrderTableViewCell
        let item = dataHistory[indexPath.item]
        let dateReceive = item.ngaynhan ?? ""
        if let ngaylapgiohang = item.ngaylapgiohang,
           let tentrangthai = item.tentrangthai,
           let nguoinhan = item.nguoinhan,
           let diachi = item.diachi,
           let sdt = item.sdt,
           let datePlan = item.ngaydukien,
           let idGH = item.idgiohang,
           let method = item.phuongthuc
            
        {
            cell.date.text = Date().convertDateTimeSQLToView(date: ngaylapgiohang, format: "dd-MM-yyyy HH:mm:ss")
            cell.status.text = tentrangthai
            cell.status.textColor = .orange
            cell.receiver.text = nguoinhan
            cell.address.text = diachi
            cell.phone.text = sdt
            cell.datePlan.text = Date().convertDateSQLToView(String(datePlan.prefix(10)))
            cell.idGH.text = "\(idGH)"
            cell.method.text = "\(method)"
            if dateReceive != "" {
                cell.dateReceive.text = Date().convertDateTimeSQLToView(date: dateReceive, format: "dd-MM-yyyy HH:mm:ss")
            }else {
                cell.dateReceive.text = ""}
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataHistory[indexPath.item]
        let detailOrderViewController = DetailOrderViewController()
        detailOrderViewController.KEY = "SHIPPER"
        detailOrderViewController.order = item
        self.navigationController?.pushViewController(detailOrderViewController, animated: true)
    }
}



