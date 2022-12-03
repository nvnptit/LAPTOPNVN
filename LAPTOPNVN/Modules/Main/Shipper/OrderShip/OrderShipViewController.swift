//
//  OrderShipViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 08/08/2022.
//

import UIKit
import DropDown
import NVActivityIndicatorView
import CoreLocation

class OrderShipViewController: UIViewController {
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfFrom: UITextField!
    
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var dropdownStatus: UIView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbMap: UIButton!
    
    var maStatus = 1
    var statusDrop = DropDown()
    let statusValues: [String] = ["Đang giao hàng","Đã giao hàng"]
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var dataHistory: [HistoryOrder1] = []
    var dataSorted: [HistoryOrderSorted] = []
    
    func addDataSorted(item: HistoryOrder1?, km: Float){
        guard let item = item else {return}
        dataSorted.append(HistoryOrderSorted(iddonhang: item.iddonhang, ngaylapdonhang: item.ngaylapdonhang, ngaydukien: item.ngaydukien, tonggiatri: item.tonggiatri, tentrangthai: item.tentrangthai, nvgiao: item.nvgiao, sdtnvg: item.sdtnvg, nvduyet: item.nvduyet, nguoinhan: item.nguoinhan, diachi: item.diachi, sdt: item.sdt, email: item.email, ngaynhan: item.ngaynhan, phuongthuc: item.phuongthuc, thanhtoan: item.thanhtoan, km: km))
//        dataSorted.sort{
//            return ($0.km ?? 0 ) < ($1.km ?? 0)  // tăng dần theo số km
////            return ($0.km ?? 0 ) > ($1.km ?? 0)  // giảm dần theo số km
//        }
        dataSorted.sort{
            let dateFormat = "dd-MM-yyyy"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let currentDate = Date()
            let current = "\(currentDate)".prefix(10)
            let curr = dateFormatter.date(from: Date().convertDateSQLToView(String(current)))
            let startDate = dateFormatter.date(from: Date().convertDateTimeSQLToView(date: $0.ngaydukien!, format: "dd-MM-yyyy"))
            let endDate = dateFormatter.date(from: Date().convertDateTimeSQLToView(date: $1.ngaydukien!, format: "dd-MM-yyyy"))

            return ( (startDate == curr) || (endDate == curr) ) && ($0.km ?? 0 ) < ($1.km ?? 0)  || (startDate! < endDate!)
        }
//        dataSorted.sort{
//            let dateFormat = "dd-MM-yyyy"
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = dateFormat
//            let currentDate = Date()
//            let current = "\(currentDate)".prefix(10)
//            let curr = dateFormatter.date(from: Date().convertDateSQLToView(String(current)))
//            let startDate = dateFormatter.date(from: Date().convertDateTimeSQLToView(date: $0.ngaydukien!, format: "dd-MM-yyyy"))
//            let endDate = dateFormatter.date(from: Date().convertDateTimeSQLToView(date: $1.ngaydukien!, format: "dd-MM-yyyy"))
//            return (startDate == curr) && (endDate == startDate)  && ($0.km ?? 0 ) < ($1.km ?? 0)
//        }
//
    }
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
    
    func changeCorner(_ btn: UIButton!){
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeCorner(btnLogout)
        changeCorner(lbMap)
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
    
    
    
    @IBAction func tapMap(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = MapsViewController()
        vc.dataHistory = self.dataHistory
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadDataHistory(){
        self.dataSorted.removeAll()
        loading.startAnimating()
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        var to1: String?
        if (to != nil){
            to1 = to! + " 23:59:59"
        }
        guard let maNV = UserService.shared.infoNV?.manv else {return}
        let params = ShipperModel(manv: maNV, dateFrom: from, dateTo: to1, status: self.maStatus).convertToDictionary()
        print(params)
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getOrderShipper(with: .getOrderShipper, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        if data.isEmpty{
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.tableView.reloadData()
                                self.loading.stopAnimating()
                            }
                        } else {
                            self.dataHistory = data
                            for  it in data{
                                guard let diachi = it.diachi else {return}
                                // Hien thi khoang cach
                                LocationManager.shared.forwardGeocoding(address: diachi.lowercased(), completion: {
                                    success,coordinate in
                                    if success {
                                        guard let lat = coordinate?.latitude,
                                              let long = coordinate?.longitude else {return}
                                        
                                        let mySourceLocation = CLLocation(latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
                                        let myDestinationLocation = CLLocation(latitude: lat, longitude: long)
                                        let distance = mySourceLocation.distance(from: myDestinationLocation)
                                        self.addDataSorted(item: it, km: Float(String(format: "%.01f", distance)) ?? 0.0)
                                    } else {
                                        self.addDataSorted(item: it, km: -1)
                                        print("error sth went wrong")
                                    }
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        self.tableView.reloadData()
                                        self.loading.stopAnimating()
                                    }
                                })
                            }
                        }
                        
                        
                    }
                    
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
            if (item == "Đang giao hàng"){
                lbMap.isHidden = false
            }
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
//        return 1
        return dataSorted.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return dataHistory.count
//        return dataSorted.count
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255
    }
    // Space devide row
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderTableViewCell", for: indexPath) as! HistoryOrderTableViewCell
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
//        cell.clipsToBounds = false
        
//        let item = dataSorted[indexPath.item]
        let item = dataSorted[indexPath.section]
        let dateReceive = item.ngaynhan ?? ""
        if let ngaylapdonhang = item.ngaylapdonhang,
           let tentrangthai = item.tentrangthai,
           let nguoinhan = item.nguoinhan,
           let diachi = item.diachi,
           let sdt = item.sdt,
           let datePlan = item.ngaydukien,
           let idGH = item.iddonhang,
           let method = item.phuongthuc
            
        {
            cell.date.text = Date().convertDateTimeSQLToView(date: ngaylapdonhang, format: "dd-MM-yyyy HH:mm:ss")
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
                cell.dateReceive.text = ""
            }
            if (tentrangthai == "Đang giao hàng"){
                cell.lbDistance.isHidden = false
                cell.distance.isHidden = false
                lbMap.isHidden = false
            }
            else{
                cell.lbDistance.isHidden = true
                cell.distance.isHidden = true
                lbMap.isHidden = true
            }
            let distance = item.km ?? 0.0
            if (distance == -1.0){
                cell.distance.text = "Không xác định"
            }else
            if (distance/1000>1){
                cell.distance.text = String(format: "%.01fkm", distance/1000)
            }else {
                cell.distance.text =  String(format: "%.0fm", distance)
            }
            
            // Hien thi khoang cach
            //            LocationManager.shared.forwardGeocoding(address: diachi.lowercased(), completion: {
            //                success,coordinate in
            //                if success {
            //                    guard let lat = coordinate?.latitude,
            //                          let long = coordinate?.longitude else {return}
            //                         // Do sth with your coordinates
            //
            //                    let mySourceLocation = CLLocation(latitude: LocationManager.shared.lat, longitude: LocationManager.shared.long)
            //                    let myDestinationLocation = CLLocation(latitude: lat, longitude: long)
            //                    let distance = mySourceLocation.distance(from: myDestinationLocation)
            //                    if (distance/1000>1){
            //                        cell.distance.text = String(format: "%.01f km", distance/1000)
            //                    }
            //                    else {
            //
            //                        cell.distance.text = String(format: "%.0f m", distance)
            //                    }
            ////                    //render
            ////                    self.mapThis (destinationCord: coordinate!)
            //                     } else {
            //                         print("error sth went wrong")
            //                     }
            //            })
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = dataHistory[indexPath.item]
        let item = dataHistory[indexPath.section]
        let detailOrderViewController = DetailOrderViewController()
        detailOrderViewController.KEY = "SHIPPER"
        detailOrderViewController.order = item
        self.navigationController?.pushViewController(detailOrderViewController, animated: true)
    }
}

