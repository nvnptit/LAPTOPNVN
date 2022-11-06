//
//  AccountViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
import NVActivityIndicatorView
import DropDown

class AccountViewController: UIViewController {
    
    @IBOutlet weak var chatBot: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var dropdownStatus: UIView!
    @IBOutlet weak var status: UILabel!
    var maStatus = 0
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewAccount: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var info: UIView!
    
    @IBOutlet var history: UIView!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var lb7: UILabel!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
    @IBOutlet weak var tfCMND: UITextField!
    @IBOutlet weak var btnThayDoi: UIButton!
    @IBOutlet weak var btnDangXuat: UIButton!
    
    
    
    var isCancel:Bool = false
    var statusDrop = DropDown()
    let statusValues: [String] = ["Chờ duyệt","Đang giao hàng","Đã giao hàng","Đã huỷ"]
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let cmnd = UserService.shared.cmnd
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    let datePicker = UIDatePicker()
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        viewAccount.addGestureRecognizer(gesture)
        
        setupKeyboard()
        setupDropDown()
        self.status.text = "Chờ duyệt"
        setupStatus()
        let cmnd = UserService.shared.cmnd
        if (cmnd == ""){
            let loginVC = NoLoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            showhide(true)
        }else {
            showhide(false)
            loadData()
        }
        info.isHidden = false
        history.isHidden = true
        
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
        //        loadDataHistory()
        
        setupAnimation()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryOrderTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        self.navigationController?.isNavigationBarHidden = true
        loadDataHistory()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataHistory(){
        loading.startAnimating()
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        
        
        let params = HistoryModel(status: self.maStatus, cmnd: UserService.shared.cmnd, dateFrom: from, dateTo: to).convertToDictionary()
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self , self.cmnd != "" else { return }
            
            APIService.getHistoryOrder1(with: .getHistoryOrder, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        self.dataHistory = data
                    }
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
            //            self.maStatus = statusValues.firstIndex(where: {$0 == item})!
            self.maStatus = index
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
    
    func showhide(_ sh: Bool){
        lb1.isHidden = sh
        lb2.isHidden = sh
        lb3.isHidden = sh
        lb4.isHidden = sh
        lb5.isHidden = sh
        lb6.isHidden = sh
        lb7.isHidden = sh
        btnThayDoi.isHidden = sh
        btnDangXuat.isHidden = sh
        
        tfName.isHidden  = sh
        tfBirthday.isHidden  = sh
        tfEmail.isHidden  = sh
        tfPhone.isHidden  = sh
        tfAddress.isHidden  = sh
        tfCMND.isHidden = sh
        segment.isHidden = sh
    }
    func loadData(){
        guard let info =  UserService.shared.infoProfile else {return}
        tfName.text  = info.ten
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = info.ngaysinh?.prefix(10)
        let dateFromString = dateFormatter.date(from: String(day!))
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: dateFromString!)
        let date1 = Date().convertDateSQLToView(String(day!))
        
        tfBirthday.text  = date
        tfEmail.text  = info.email
        tfPhone.text  = info.sdt
        tfAddress.text  = info.diachi
        tfCMND.text = info.cmnd
    }
    
    func isValidPhone(phone: String) -> Bool {
        let regexPhone =  "(84|0){1}(3|5|7|8|9){1}+([0-9]{8})"
        let phoneTest = NSPredicate(format: "SELF MATCHES%@", regexPhone)
//        print(phoneTest.evaluate(with: phone))
        return phoneTest.evaluate(with: phone)
    }
    func isValidEmail( email:String)->Bool{
        let regexEmail = "^[\\w-\\.\\+]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let passwordTest=NSPredicate(format:"SELF MATCHES%@",regexEmail)
//        print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
    
    func checkFill() -> Bool{
        
        let emailE = chuanHoa(tfEmail.text)
        let nameE = chuanHoa(tfName.text)
        let addressE = chuanHoa(tfAddress.text)
        let dayE = chuanHoa(tfBirthday.text)
        let phoneE = chuanHoa(tfPhone.text)
        
        if (emailE.isEmpty || nameE.isEmpty || addressE.isEmpty || dayE.isEmpty || phoneE.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (!Date().checkDate18(date: dayE)){
            let alert = UIAlertController(title: "Ngày sinh không hợp lệ cần đủ 18 tuổi", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (!isValidEmail(email: emailE)){
            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (!isValidPhone(phone: phoneE)){
            let alert = UIAlertController(title: "Số điện thoại không hợp lệ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    @IBAction func tapChangeInfo(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnThayDoi.currentTitle == "THAY ĐỔI THÔNG TIN"){
            tfName.backgroundColor = .none
            tfBirthday.backgroundColor = .none
            tfEmail.backgroundColor = .none
            tfPhone.backgroundColor = .none
            tfAddress.backgroundColor = .none
            
            tfName.isEnabled = true
            tfBirthday.isEnabled = true
            tfEmail.isEnabled = true
            tfPhone.isEnabled = true
            tfAddress.isEnabled = true
            
            btnThayDoi.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
            if (checkFill()){
                
                tfName.backgroundColor = .lightGray
                tfBirthday.backgroundColor = .lightGray
                tfEmail.backgroundColor = .lightGray
                tfPhone.backgroundColor = .lightGray
                tfAddress.backgroundColor = .lightGray
                
                tfName.isEnabled = false
                tfBirthday.isEnabled = false
                tfEmail.isEnabled = false
                tfPhone.isEnabled = false
                tfAddress.isEnabled = false
                let emailE = chuanHoa(tfEmail.text)
                let nameE = chuanHoa(tfName.text)
                let addressE = chuanHoa(tfAddress.text)
                let dayE = chuanHoa(tfBirthday.text)
                
                let dateSql = Date().convertDateViewToSQL(dayE)
                let phoneE = chuanHoa(tfPhone.text)
                
                tfEmail.text = emailE
                tfName.text = nameE
                tfAddress.text = addressE
                tfBirthday.text = dayE
                tfPhone.text = phoneE
                
                let params = UserEdit(cmnd: tfCMND.text, email: emailE, ten: nameE, diachi: addressE, ngaysinh: dateSql, sdt: phoneE).convertToDictionary()
                updateUserKH(params: params)
                
                btnThayDoi.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
                
            }
        }
    }
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    
    @IBAction func tapLogout(_ sender: UIButton, forEvent event: UIEvent) {
        UserService.shared.removeAll()
        UserService.shared.removeAllGH2()
        UserService.shared.removeAllNV()
        UserService.shared.removeAllQuyen()
        let vc = MainTabBarController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func switchView(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if segment.selectedSegmentIndex == 0 {
            info.isHidden = false
            history.isHidden = true
        } else {
            history.isHidden = false
            info.isHidden = true
        }
    }
    @IBAction func tapChatBot(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = ChatBotViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
} 

extension AccountViewController{
    //MARK: - Datepicker
    
    private func createToolbar(_ datePickerView: UIDatePicker) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapOnView))
        switch (datePickerView){
            case datePicker:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
                
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
        datePicker.preferredDatePickerStyle = .wheels
        datePicker1.preferredDatePickerStyle = .wheels
        datePicker2.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
            datePicker1.preferredDatePickerStyle = .inline
            datePicker2.preferredDatePickerStyle = .inline
        }
        
        datePicker.datePickerMode = .date
        tfBirthday.inputView = datePicker
        tfBirthday.inputAccessoryView = createToolbar(datePicker)
        
        datePicker1.datePickerMode = .date
        tfFrom.inputView = datePicker1
        tfFrom.inputAccessoryView = createToolbar(datePicker1)
        
        datePicker2.datePickerMode = .date
        tfTo.inputView = datePicker2
        tfTo.inputAccessoryView = createToolbar(datePicker2)
    }
    
    @objc func donedatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfBirthday.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
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

extension AccountViewController{
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

extension AccountViewController {
    func updateUserKH(params: [String : Any]?){
        APIService.updateUserKH(with: .updateUserKH, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                let emailE = self.chuanHoa(self.tfEmail.text)
                let nameE = self.chuanHoa(self.tfName.text)
                let addressE = self.chuanHoa(self.tfAddress.text)
                let dayE = self.chuanHoa(self.tfBirthday.text)
                let phoneE = self.chuanHoa(self.tfPhone.text)
                let model = LoginResponse(cmnd: self.tfCMND.text, email: emailE, ten: nameE, diachi: addressE, ngaysinh: dayE, sdt: phoneE, tendangnhap: UserService.shared.infoProfile?.tendangnhap)
                UserService.shared.setInfo(with: model)
                let alert = UIAlertController(title: "Cập nhật thông tin thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else {
                fatalError()
            }
        })
    }
}
// History

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return 497
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
                cell.dateReceive.text = ""
            }
            cell.lbDistance.isHidden = true
            cell.distance.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataHistory[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryOrderTableViewCell else { return }
        let vc = DetailHistoryViewController()
        vc.id = item.idgiohang
        vc.order = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



