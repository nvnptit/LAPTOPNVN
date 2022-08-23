//
//  DetailEmployeeViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 13/08/2022.
//

import UIKit
import NVActivityIndicatorView
import DropDown

class DetailEmployeeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lbTK: UILabel!
    @IBOutlet weak var tfTK: UITextField!
    @IBOutlet weak var lbMK: UILabel!
    @IBOutlet weak var tfMK: UITextField!
    
    @IBOutlet weak var tfMaNV: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfTen: UITextField!
    @IBOutlet weak var tfNgaySinh: UITextField!
    @IBOutlet weak var tfSDT: UITextField!
    
    @IBOutlet weak var btnChange: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var dropdownStatus: UIView!
    @IBOutlet weak var status: UILabel!
    
    var maStatus = 0
    var statusDrop = DropDown()
    var statusValues: [String] = []
    
    var isValidAccount = false;
    
    let datePicker = UIDatePicker()
    
    var employee: ModelNVResponseAD?
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    var isNew: Bool = false 
    var maNV: Int?
    var maQuyen: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        tfMK.enablePasswordToggle()
        setupAnimation()
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        self.offFill()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        if (!isNew){
            lbTK.isHidden = true
            lbMK.isHidden = true
            tfTK.isHidden = true
            tfMK.isHidden = true
            loadData()
            self.maQuyen = employee?.maquyen
            self.title = "Cập nhật thông tin nhân viên"
        }else {
            self.onFill()
            btnChange.setTitle("THÊM MỚI", for: .normal)
            btnDelete.isHidden = true
            getMaNV()
            self.title = "Thêm mới nhân viên"
        }
        setupDropDown()
        setupStatus()
    }
    func loadData(){
        if let employee = employee {
            tfMaNV.text = employee.manv
            tfEmail.text = employee.email
            tfTen.text = employee.ten
            tfNgaySinh.text = Date().convertDateTimeSQLToView(date: employee.ngaysinh!, format:"dd-MM-yyyy")
            tfSDT.text = employee.sdt
            status.text = employee.tenquyen
        }
    }
    override func viewDidAppear(_ animated: Bool = false) {
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
    @IBAction func tapChange(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnChange.currentTitle == "THÊM MỚI"){
            if (checkInfo()){
                let tk = chuanHoa(tfTK.text)
                let mk = chuanHoa(tfMK.text)
                let maNV = chuanHoa(tfMaNV.text)
                let email = chuanHoa(tfEmail.text)
                let hoTen = chuanHoa(tfTen.text)
                let ngaySinh = chuanHoa(tfNgaySinh.text)
                let sdt = chuanHoa(tfSDT.text)
                tfTen.text = hoTen
                tfEmail.text = email
                tfSDT.text = sdt
                
                let params1 = TaiKhoan(tendangnhap: tk, matkhau: mk, maquyen: self.maQuyen).convertToDictionary()
                print(params1)
                APIService.postRegisterKH(with: .register, params: params1, headers: nil, completion: {
                    base , error in
                    if let success = base?.success {
                        if (success){
                            self.isValidAccount = true;
                            let dateSql = Date().convertDateViewToSQL(ngaySinh)
                            let params2 = ModelNVEdit(manv: maNV, email: email, ten: hoTen, ngaysinh: dateSql, sdt: sdt, tendangnhap: tk).convertToDictionary()
                            
                            APIService.postHangSX(with: .postNV, params: params2, headers: nil, completion: {
                                base, error in
                                guard let base = base else { return }
                                if base.success == true {
                                    let alert = UIAlertController(title: "Thêm mới thành công!", message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                        self.dismiss(animated: true)
                                        
                                        self.navigationController?.popViewController(animated: true)
//                                        let vc = EmployeeViewController()
//                                        vc.navigationItem.hidesBackButton = true
//                                        vc.isAdded = true
//                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }))
                                    self.present(alert, animated: true)
                                } else {
                                        APIService.delTK(with: .delTK, params: ["tenDangNhap": tk], headers: nil, completion: {
                                            base, error in
                                            if let success = base?.success{
                                                print("Response: \(success)")
                                            }
                                        })
                                    let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                            self.dismiss(animated: true)
                                        }))
                                        self.present(alert, animated: true)
                                        return
                                }
                            })
                        }
                        else {
                            self.isValidAccount = false;
                            let alert = UIAlertController(title: base?.message!, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                self.dismiss(animated: true)
                            }))
                            self.present(alert, animated: true)
                            return
                        }
                    }
                })
            }
        } else
        if (btnChange.currentTitle == "THAY ĐỔI THÔNG TIN"){
            self.onFill()
            btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
            if (checkInfo()){
                let emailE = chuanHoa(tfEmail.text)
                let nameE = chuanHoa(tfTen.text)
                let dayE = chuanHoa(tfNgaySinh.text)
                let dateSql = Date().convertDateViewToSQL(dayE)
                let phoneE = chuanHoa(tfSDT.text)
                
                tfEmail.text = emailE
                tfTen.text = nameE
                tfNgaySinh.text = dayE
                tfSDT.text = phoneE
                let paramQKH = TaiKhoanQuyenKichHoat(tendangnhap: employee?.tendangnhap!, maquyen: self.maQuyen, kichhoat: true).convertToDictionary()
                print(paramQKH)
                updateQuyenKichHoat(params: paramQKH)
                
                let params = ModelNVEdit(manv: tfMaNV.text, email: emailE, ten: nameE, ngaysinh: dateSql, sdt: phoneE, tendangnhap: employee?.tendangnhap!).convertToDictionary()
                updateNV(params: params)
            }
        }
    }
    
    
    @IBAction func tapDelete(_ sender: UIButton, forEvent event: UIEvent) {
        print("DELETE")
        let alert = UIAlertController(title: "Bạn có chắc xoá nhân viên này?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
            self.dismiss(animated: true)
            let params = ModelNV(manv: self.tfMaNV.text!).convertToDictionary()
            self.delNV(params: params)
            // Huỷ kích hoạt tài khoản
            let paramQKH = TaiKhoanQuyenKichHoat(tendangnhap: self.employee?.tendangnhap!, maquyen: self.employee?.maquyen!, kichhoat: false).convertToDictionary()
            print(paramQKH)
            self.updateQuyenKichHoat(params: paramQKH)
            
        }))
        self.present(alert, animated: true)
    }
    
    func offFill(){
        dropdownStatus.backgroundColor = .lightGray
        tfEmail.backgroundColor = .lightGray
        tfTen.backgroundColor = .lightGray
        tfNgaySinh.backgroundColor = .lightGray
        tfSDT.backgroundColor = .lightGray
        
        dropdownStatus.isUserInteractionEnabled = false
        tfEmail.isEnabled = false
        tfTen.isEnabled = false
        tfNgaySinh.isEnabled = false
        tfSDT.isEnabled = false
    }
    func onFill(){
        if (isNew){
            tfTK.backgroundColor = .none
            tfMK.backgroundColor = .none
        }
        tfTK.isEnabled = true
        tfMK.isEnabled = true
        dropdownStatus.isUserInteractionEnabled = true
        
        dropdownStatus.backgroundColor = .none
        tfEmail.backgroundColor = .none
        tfTen.backgroundColor = .none
        tfNgaySinh.backgroundColor = .none
        tfSDT.backgroundColor = .none
        
        tfEmail.isEnabled = true
        tfTen.isEnabled = true
        tfNgaySinh.isEnabled = true
        tfSDT.isEnabled = true
    }
}
extension DetailEmployeeViewController{
    
    // BEGIN STATUS
    
    private func setupStatus() {
        statusDrop.anchorView = dropdownStatus
        statusDrop.dataSource = statusValues
        statusDrop.bottomOffset = CGPoint(x: 0, y:(statusDrop.anchorView?.plainView.bounds.height)! + 5)
        statusDrop.direction = .bottom
        statusDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.status.text = item
            //            self.maStatus = statusValues.firstIndex(where: {$0 == item})!
            self.maStatus = index + 1
            self.maQuyen = index + 1
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
extension DetailEmployeeViewController{
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
            default: break
                
        }
        
        return toolbar
    }
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        
        datePicker.datePickerMode = .date
        tfNgaySinh.inputView = datePicker
        tfNgaySinh.inputAccessoryView = createToolbar(datePicker)
    }
    
    @objc func donedatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfNgaySinh.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}


extension DetailEmployeeViewController{
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
extension DetailEmployeeViewController{
    
    func isValidUsername(Input:String) -> Bool {
        let RegEx = "\\w{4,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    func isValidPhone(phone: String) -> Bool {
        let regexPhone =  "(84|0){1}(3|5|7|8|9){1}+([0-9]{8})"
        let phoneTest = NSPredicate(format: "SELF MATCHES%@", regexPhone)
        print(phoneTest.evaluate(with: phone))
        return phoneTest.evaluate(with: phone)
    }
    func isValidEmail( email:String)->Bool{
        let regexEmail = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let passwordTest=NSPredicate(format:"SELF MATCHES%@",regexEmail)
        print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    
    func checkInfo() -> Bool{
        guard
            var email = tfEmail.text,
            var name = tfTen.text,
            var birthday = tfNgaySinh.text,
            var phone = tfSDT.text
        else {
            return false
        }
        
        email = chuanHoa(tfEmail.text)
        name = chuanHoa(tfTen.text)
        phone = chuanHoa(tfSDT.text)
        if (email.isEmpty || name.isEmpty ||
            birthday.isEmpty || phone.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if ( isNew){
            guard let tk = tfTK.text else {return false}
            if (!isValidUsername(Input: tk)){
                let alert = UIAlertController(title: "Tài khoản không hợp lệ \n cần ít nhất 4 kí tự", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return false
            }
        }
        
        
        if (!Date().checkDate18(date: birthday)){
            let alert = UIAlertController(title: "Ngày sinh không hợp lệ \ncần đủ 18 tuổi", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        
        if (!isValidEmail(email: email)){
            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (!isValidPhone(phone: phone)){
            let alert = UIAlertController(title: "Số điện thoại không hợp lệ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
}

extension DetailEmployeeViewController{
    private func updateNV(params: [String: Any]?) {
        APIService.postNhanVien(with: .putNV, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Cập nhật thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.btnChange.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
                    self.offFill()
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    private func delNV(params: [String: Any]?) {
        APIService.postNhanVien(with: .delNV, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Xoá nhân viên thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    
                    self.navigationController?.popViewController(animated: true)
//                    let vc = EmployeeViewController()
//                    vc.navigationItem.hidesBackButton = true
//                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: base.message! + "\n Đã huỷ kích hoạt tài khoản", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    private func getMaNV(){
        APIService.getMaSo(with: .getMaSoNV, params: nil, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                self.maNV = base.data?[0].maso
                self.tfMaNV.text = "NV" + String(describing: self.maNV!+1)
            } else {
                let alert = UIAlertController(title:"Đã có lỗi lấy mã", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    private func updateQuyenKichHoat(params:  [String: Any]?){
        APIService.updateQuyenKichHoat(with: .putQuyenKichHoat, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else {
                return
            }
            if base.success == true {
                //                    let alert = UIAlertController(title: base.message , message: "", preferredStyle: .alert)
                //                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                //                            self.dismiss(animated: true)
                //                        }))
                //                        self.present(alert, animated: true)
            }else {
                let alert = UIAlertController(title:"Đã có lỗi cập nhật quyền", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
}
