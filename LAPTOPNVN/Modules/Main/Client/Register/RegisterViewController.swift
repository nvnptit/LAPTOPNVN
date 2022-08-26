//
//  RegisterViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    
    @IBOutlet weak var tfCMND: UITextField!
    
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfBirthday: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var tfAddress: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    var isValidAccount = false;
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        tfPass.enablePasswordToggle()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    func isValidUsername(Input:String) -> Bool {
        let RegEx = "\\w{4,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    @IBAction func tapRegister(_ sender: UIButton, forEvent event: UIEvent) {
        if (checkInfo()){
            guard
                let username = tfUser.text,
                let password = tfPass.text,
                let cmnd = tfCMND.text,
                let name = tfName.text,
                let birthday = tfBirthday.text,
                let email = tfEmail.text,
                let phone = tfPhone.text,
                let address = tfAddress.text
            else {return}
            let params1 = TaiKhoan(tendangnhap: username, matkhau: password, maquyen: 7).convertToDictionary()
            print(params1)
            APIService.postRegisterKH(with: .register, params: params1, headers: nil, completion: {
                base , error in
                if let success = base?.success {
                    if (success){
                        self.isValidAccount = true;
                        let dateSql = Date().convertDateViewToSQL(birthday)
                        
                        let params2 = UserModel(cmnd: cmnd, email: email, ten: name, diachi: address, ngaysinh: dateSql, sdt: phone, tendangnhap: username).convertToDictionary()
                        APIService.postUserKH(with: .addUserKH, params: params2, headers: nil, completion: {
                            base, error in
                            if let base = base {
                                print(base)
                                if (base.success == true) {
                                    let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                        self.dismiss(animated: true)
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alert, animated: true)
                                }else {
                                    DispatchQueue.global().async {
                                        // Xoá tài khoản
                                        APIService.delTK1(with: username, { data, error in
                                            guard let data = data else {
                                                return
                                            }
                                            if (data.success == true ){
                                                print("success")
                                            }
                                        })
                                    }
                                    let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                        self.dismiss(animated: true)
                                    }))
                                    self.present(alert, animated: true)
                                    
                                    return
                                }
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
    }
    
    
    func checkInfo() -> Bool{
        guard let username = tfUser.text,
              let password = tfPass.text,
              
                let cmnd = tfCMND.text,
              let name = tfName.text,
              let birthday = tfBirthday.text,
              let email = tfEmail.text,
              let phone = tfPhone.text,
              let address = tfAddress.text
        else {
            return false
        }
        if (username.isEmpty || password.isEmpty ||
            cmnd.isEmpty || name.isEmpty ||
            birthday.isEmpty || email.isEmpty ||
            phone.isEmpty ||  address.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        
        if (!isValidUsername(Input: username)){
            let alert = UIAlertController(title: "Username không hợp lệ \n cần ít nhất 4 kí tự", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        
        if (!isValidCMND(cmnd: cmnd)){
            let alert = UIAlertController(title: "Số chứng minh nhân dân \n không hợp lệ gồm 9-12 số", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
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
extension RegisterViewController {
    
    func isValidCMND(cmnd: String) -> Bool {
        let regexC1 =  "[0-9]{9}"
        let regexC2 =  "[0-9]{12}"
        let cmndC1 = NSPredicate(format: "SELF MATCHES%@", regexC1)
        let cmndC2 = NSPredicate(format: "SELF MATCHES%@", regexC2)
        let rs = cmndC1.evaluate(with: cmnd) || cmndC2.evaluate(with: cmnd)
        print(rs)
        return rs
    }
    func isValidPhone(phone: String) -> Bool {
        let regexPhone =  "(84|0){1}(3|5|7|8|9){1}+([0-9]{8})"
        let phoneTest = NSPredicate(format: "SELF MATCHES%@", regexPhone)
        print(phoneTest.evaluate(with: phone))
        return phoneTest.evaluate(with: phone)
    }
    func isValidEmail( email:String)->Bool{
        let regexEmail = "^[\\w-\\.\\+]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let passwordTest=NSPredicate(format:"SELF MATCHES%@",regexEmail)
        print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
    
}
extension RegisterViewController{
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
        tfBirthday.inputView = datePicker
        tfBirthday.inputAccessoryView = createToolbar(datePicker)
    }
    
    @objc func donedatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfBirthday.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

extension RegisterViewController{
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
