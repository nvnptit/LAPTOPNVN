//
//  AccountViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
import NVActivityIndicatorView


class AccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    
    @IBOutlet weak var tfFrom: UITextField!
    
    @IBOutlet weak var tfTo: UITextField!
    
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let Host = "http://192.168.1.74"
    
    let cmnd = UserService.shared.cmnd
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var dataHistory: [HistoryOrder] = []
    
    
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
        let cmnd = UserService.shared.cmnd
        if (cmnd == ""){
            let loginVC = LoginViewController()
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
        
        loadDataHistory()
        
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
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self , self.cmnd != "" else { return }
            
            let params = HistoryModel(cmnd: self.cmnd, dateFrom: "2022-07-20", dateTo: "2022-07-28").convertToDictionary()
            APIService.getHistoryOrder(with: .getHistoryOrder, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        self.dataHistory = data
                    }
                } else {
                    fatalError()
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.loading.stopAnimating()
                }
            })
        }
        
    }
    
    
    
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
        
        
        tfBirthday.text  = date
        tfEmail.text  = info.email
        tfPhone.text  = info.sdt
        tfAddress.text  = info.diachi
        tfCMND.text = info.cmnd
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateFromString = dateFormatter.date(from: dayE)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateSql = dateFormatter.string(from: dateFromString!)
            let phoneE = chuanHoa(tfPhone.text)
            
            tfEmail.text = emailE
            tfName.text = nameE
            tfAddress.text = addressE
            tfBirthday.text = dayE
            tfPhone.text = phoneE
            
            
            let params = UserEdit(cmnd: tfCMND.text, email: emailE, ten: nameE, diachi: addressE, ngaysinh: dateSql, sdt: phoneE).convertToDictionary()
            updateUser(params: params)
            
            btnThayDoi.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
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
    
}

extension AccountViewController{
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
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfTo.text =  dateFormatter.string(from: datePicker2.date)
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

extension AccountViewController {
    func updateUser(params: [String : Any]?){
        APIService.updateUser(with: .updateUser, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                let emailE = self.chuanHoa(self.tfEmail.text)
                let nameE = self.chuanHoa(self.tfName.text)
                let addressE = self.chuanHoa(self.tfAddress.text)
                let dayE = self.chuanHoa(self.tfBirthday.text)
                let phoneE = self.chuanHoa(self.tfPhone.text)
                let model = LoginResponse(cmnd: self.tfCMND.text, email: emailE, ten: nameE, diachi: addressE, ngaysinh: dayE, sdt: phoneE, tendangnhap: UserService.shared.infoProfile?.tendangnhap)
                UserService.shared.setInfo(with: model)
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
        return 153
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderTableViewCell", for: indexPath) as! HistoryOrderTableViewCell
        let item = dataHistory[indexPath.item]
        if let ngaylapgiohang = item.ngaylapgiohang,
            let tonggiatri = item.tonggiatri,
            let tentrangthai = item.tentrangthai,
            let nvgiao = item.nvgiao,
            let nvduyet = item.nvduyet,
            let nguoinhan = item.nguoinhan,
            let diachi = item.diachi,
            let sdt = item.sdt,
            let email = item.email,
            
            let serial = item.serial,
            let tenlsp = item.tenlsp,
            let anhlsp = item.anhlsp,
            let mota = item.mota,
            let cpu = item.cpu,
            let ram = item.ram,
            let harddrive = item.harddrive,
            let cardscreen = item.cardscreen,
            let os = item.os
            {
            cell.date.text = ngaylapgiohang
            cell.status.text = tentrangthai
            cell.status.textColor = .green
            cell.receiver.text = nguoinhan
            cell.address.text = diachi
            cell.phone.text = sdt
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataHistory[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryOrderTableViewCell else { return }

    let detailSPViewController = DetailSanPhamViewController()
    detailSPViewController.order = item
    self.navigationController?.pushViewController(detailSPViewController, animated: true)
    }
}



