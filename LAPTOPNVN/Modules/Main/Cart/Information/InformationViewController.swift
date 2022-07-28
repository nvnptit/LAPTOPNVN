//
//  InformationViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 27/07/2022.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var btnThanhToan: UIButton!
    
    var dataGioHang : [GioHangData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.layer.shadowColor = UIColor.lightGray.cgColor
        address.layer.borderWidth = 0.2
        
    }
    func checkFill() -> Bool{
        guard let name = name.text,
              let phone = phone.text,
              let email = email.text,
              let address = address.text
        else {
            return false
        }
        if (name.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty) {
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
    @IBAction func tapThanhToan(_ sender: Any) {
        if (checkFill()){
            let name = name.text
            let phone = phone.text
            let email = email.text
            let address = address.text
            for item in dataGioHang{
                var params = GioHangEdit(idgiohang: item.idgiohang, ngaylapgiohang: nil, tonggiatri: item.giagiam, matrangthai: 0, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email).convertToDictionary()
                updateGH(params: params)
            }
            let alert = UIAlertController(title: "Thanh toán thành công", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
                let vc = MainTabBarController()
                self.navigationController?.pushViewController(vc, animated: false)
            }))
            self.present(alert, animated: true)
        }
    }
    
    
}
extension InformationViewController {
    func updateGH(params: [String : Any]?){
        APIService.updateGioHang(with: .updateGioHang, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                
            }
            else {
                fatalError()
            }
        })
    }
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
