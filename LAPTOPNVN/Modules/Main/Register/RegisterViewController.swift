//
//  RegisterViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapRegister(_ sender: UIButton, forEvent event: UIEvent) {
        if (checkInfo()){
            let username = tfUser.text
            let password = tfPass.text
            let cmnd = tfCMND.text
            let name = tfName.text
            let birthday = tfBirthday.text ?? ""
            let email = tfEmail.text
            let phone = tfPhone.text
            let address = tfAddress.text
            
            let params1 = TaiKhoan(tendangnhap: username, matkhau: password, maquyen: 7).convertToDictionary()
            print(params1)
            APIService.postRegister(with: .register, params: params1, headers: nil, completion: {
                base , error in
                if let success = base?.success {
                    if (success){
                        self.isValidAccount = true;
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let dateFromString = dateFormatter.date(from: birthday)
                        
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateSql = dateFormatter.string(from: dateFromString!)
                        
                        let params2 = UserModel(cmnd: cmnd, email: email, ten: name, diachi: address, ngaysinh: dateSql, sdt: phone, tendangnhap: username).convertToDictionary()
                        APIService.postUser(with: .addUser, params: params2, headers: nil, completion: {
                            base, error in
                            if let base = base {
                                if (base.success == true) {
                                    
                                    let alert = UIAlertController(title: "Đăng ký tài khoản mới thành công", message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                        self.dismiss(animated: false)
                                        let vc = LoginViewController()
                                        self.navigationController?.pushViewController(vc, animated: false)
                                        vc.navigationItem.hidesBackButton = true
                                    }))
                                    self.present(alert, animated: true)
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
    
    func isValidPhone(phone: String) -> Bool {
        let regexPhone =  "(((\\+|)84)|0)(3|5|7|8|9)+([0-9]{7})"
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
