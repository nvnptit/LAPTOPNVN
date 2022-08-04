//
//  InformationViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 27/07/2022.
//

import UIKit

import BraintreePayPal
import BraintreeDataCollector

class InformationViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var datePlan: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var btnThanhToan: UIButton!
    @IBOutlet weak var lbDatePlan: UILabel!
    
    var dataGioHang : [GioHangData] = []
    
    
    let datePicker = UIDatePicker()

    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.layer.shadowColor = UIColor.lightGray.cgColor
        address.layer.borderWidth = 0.2
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
        loadInfo()
        self.braintreeClient = BTAPIClient(authorization: "sandbox_d596sjps_7hsb2swzq3w35xrj")
        
    }
    func loadInfo(){
        guard let user = UserService.shared.infoProfile else {return}
        name.text = user.ten
        phone.text = user.sdt
        email.text = user.email
        address.text = user.diachi
    }
    func checkFill() -> Bool{
        guard let name = name.text,
              let phone = phone.text,
              let email = email.text,
              let address = address.text,
                let datePlan = datePlan.text
        else {
            return false
        }
        if (name.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty || datePlan.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
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
        if (!isValidEmail(email: email)){
            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        
        let currentDate = Date()
        let current = "\(currentDate)".prefix(10)
        
        if (!Date().checkDatePlan(start: datePlan, end: Date().convertDateSQLToView(String(current))) ){
                let alert = UIAlertController(title: "Ngày giao mong muốn phải lớn hơn ngày hiện tại", message: "", preferredStyle: .alert)
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
            // Chuyen doi tien te
//            let currencyConverter = CurrencyConverter()
//            currencyConverter.updateExchangeRates(completion: {
//                       let doubleResult = currencyConverter.convert(10, valueCurrency: .USD, outputCurrency: .EUR)
//                       
//                   })
            
            let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
            
            let request = BTPayPalCheckoutRequest(amount: "100.67")
            request.currencyCode = "USD"
            
            payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
                if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                    print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                    // Access additional information
                    let emailPP = tokenizedPayPalAccount.email
                    let firstNamePP = tokenizedPayPalAccount.firstName
                    let lastNamePP = tokenizedPayPalAccount.lastName
                    let phonePP = tokenizedPayPalAccount.phone
                    print("INFO: \(firstNamePP) |\(lastNamePP) |\(emailPP) |\(phonePP)")
                    
                    // Xử lý db
                    let name = self.name.text
                    let phone = self.phone.text
                    let email = self.email.text
                    let address = self.address.text
                    let dayPlan = self.datePlan.text
                    for item in self.dataGioHang{
                        var params = GioHangEdit(idgiohang: item.idgiohang, ngaylapgiohang: nil,ngaydukien: dayPlan,  tonggiatri: item.giagiam, matrangthai: 0, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email).convertToDictionary()
                        self.updateGH(params: params)
                    }
                    
                    
                    let alert = UIAlertController(title: "Thanh toán thành công", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                        let vc = MainTabBarController()
                        self.navigationController?.pushViewController(vc, animated: false)
                    }))
                    self.present(alert, animated: true)
                    
                } else if let error = error {
                    // Handle error here...
                    let alert = UIAlertController(title: "Đơn hàng chưa được thanh toán", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                } else {
                    // Buyer canceled payment approval
                }
            }
            
            
            
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
extension InformationViewController{
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
        datePlan.inputView = datePicker
        datePlan.inputAccessoryView = createToolbar(datePicker)
    }
    
    @objc func donedatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePlan.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

extension InformationViewController{
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

//        if (checkFill()){
//            let name = name.text
//            let phone = phone.text
//            let email = email.text
//            let address = address.text
//            for item in dataGioHang{
//                var params = GioHangEdit(idgiohang: item.idgiohang, ngaylapgiohang: nil, tonggiatri: item.giagiam, matrangthai: 0, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email).convertToDictionary()
//                updateGH(params: params)
//            }
//
//
//
//            let alert = UIAlertController(title: "Thanh toán thành công", message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
//                self.dismiss(animated: true)
//                let vc = MainTabBarController()
//                self.navigationController?.pushViewController(vc, animated: false)
//            }))
//            self.present(alert, animated: true)
//        }
