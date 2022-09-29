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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var datePlan: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var btnThanhToan: UIButton!
    @IBOutlet weak var lbDatePlan: UILabel!
    
    var dataGioHang : [Orders] = []
    
    public var list: [LoaiSanPhamKM1] = []
    
    let datePicker = UIDatePicker()
    
    var braintreeClient: BTAPIClient!
    var tyGiaUSD: TyGiaResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        address.layer.shadowColor = UIColor.lightGray.cgColor
        address.layer.borderWidth = 0.2
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.getTyGia()
        }
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
        loadInfo()
        self.dataSend()
        self.braintreeClient = BTAPIClient(authorization: "sandbox_9qswqysc_7hsb2swzq3w35xrj")
        
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
        print("Current:\(currentDate)")
        print("datePlan:\(datePlan)")
        
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
        guard let usd = tyGiaUSD?.giatri else {
            let alert = UIAlertController(title: "Lỗi lấy tỷ giá", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        //        print(tyGiaUSD?.giatri)
        var sum = 0
        if (checkFill()){
            for item in dataGioHang {
                sum = sum + ((item.data?.giagiam)! * item.sl)
            }
            let total = Double(sum) / Double(usd)
            print(total.rounded(toPlaces: 2))
            let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
            
            let request = BTPayPalCheckoutRequest(amount: total.rounded(toPlaces: 2))
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
                    let dayPlan = Date().convertDateViewToSQL(self.datePlan.text!)
                    let cmnd = UserService.shared.cmnd
                    
                    //                    for item in self.dataGioHang{
                    //                        let params = GioHangEdit(idgiohang: item.idgiohang, ngaylapgiohang: nil,ngaydukien: dayPlan, tonggiatri: item.giagiam, matrangthai: 0, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email).convertToDictionary()
                    //                        self.updateGH(params: params)
                    //                    }
                    //
                    print("\n LIST\n ")
                    print(self.list)
                    print("\n -------LIST------\n ")
                    let params = ModelAddGH(idgiohang: nil, ngaylapgiohang: nil, ngaydukien: dayPlan, tonggiatri: sum, matrangthai: 0, cmnd: cmnd, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email, malsp: nil, dslsp: self.list).convertToDictionary()
                    print(params)
                    print("\n -------params------\n ")
                    //
                    APIService.addGioHang1(with: .addGioHang1, params: params, headers: nil, completion:   { base, error in
                        guard let base = base else { return }
                        if base.success == true{
                            let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                self.dismiss(animated: true)
                                for itemz in self.dataGioHang{
                                    UserService.shared.removeOrder2(with: itemz.data)
                                }
                                let vc = MainTabBarController()
                                self.navigationController?.pushViewController(vc, animated: false)
                            }))
                            self.present(alert, animated: true)
                        }
                    })
                } else if let error = error {
                    // Handle error here...
                    print(error)
                    let alert = UIAlertController(title: "Đơn hàng chưa được thanh toán", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                } else {
                    // Buyer canceled payment approval
                    
                    let alert = UIAlertController(title: "Đơn hàng chưa được thanh toán", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
}
extension InformationViewController {
    func dataSend(){
        self.list.removeAll()
        for dt in self.dataGioHang{
            if let item = dt.data {
                for _ in 0 ..< dt.sl{
                    list.append(LoaiSanPhamKM1(malsp: item.malsp, tenlsp: item.tenlsp, soluong: item.soluong, anhlsp: item.anhlsp, mota: item.mota, cpu: item.cpu, ram: item.ram, harddrive: item.harddrive, cardscreen: item.cardscreen, os: item.os, mahang: item.mahang, isnew: item.isnew, isgood: item.isgood, giamoi: item.giamoi, ptgg: item.ptgg, giagiam: item.giagiam))
                }
            }
    }
}
func updateGH(params: [String : Any]?){
    APIService.updateGioHang(with: .updateGioHang, params: params, headers: nil, completion: { base, error in
        guard let base = base else { return }
        if base.success == true {
            print(base)
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

extension InformationViewController{
    private func getTyGia(){
        APIService.getTyGia(with: .getTyGia, params: nil, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                self.tyGiaUSD = base.data?.first
                print(self.tyGiaUSD)
            } else {
                let alert = UIAlertController(title:"Lỗi get tỷ giá", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
        
    }
}

// Chuyen doi tien te
//            let currencyConverter = CurrencyConverter()
//            currencyConverter.updateExchangeRates(completion: {
//                       let doubleResult = currencyConverter.convert(10, valueCurrency: .USD, outputCurrency: .EUR)
//
//                   })


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
