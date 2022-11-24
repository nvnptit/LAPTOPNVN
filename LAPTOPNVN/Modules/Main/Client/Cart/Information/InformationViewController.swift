//
//  InformationViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 27/07/2022.
//

import UIKit
import DropDown
import BraintreePayPal
import BraintreeDataCollector

class InformationViewController: UIViewController {
    
    //MARK: - Start params Address
    
    @IBOutlet weak var dropProvince: UIView!
    @IBOutlet weak var lbProvince: UILabel!
    
    @IBOutlet weak var dropDistrict: UIView!
    @IBOutlet weak var lbDistrict: UILabel!
    
    @IBOutlet weak var dropWard: UIView!
    @IBOutlet weak var lbWard: UILabel!
    
    @IBOutlet weak var tfHouseNumber: UITextField!
    
    var listProvince: [ProvinceElement] = []
    var listDistrict: [DistrictElement] = []
    var listWard: [WardElement] = []
    
    var provinceDrop = DropDown()
    var districtDrop = DropDown()
    var wardDrop = DropDown()
    
    var provinceValues: [String] = []
    var districtValues: [String] = []
    var wardValues: [String] = []
    
    //MARK: - End params Address
    
    var statusDrop = DropDown()
    let statusValues: [String] = ["Thanh toán khi nhận hàng","Thanh toán qua Paypal"]
    @IBOutlet weak var dropdownStatus: UIView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var datePlan: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var btnThanhToan: UIButton!
    @IBOutlet weak var lbDatePlan: UILabel!
    
    var dataGioHang : [Orders] = []
    
    public var list: [LoaiSanPhamKM1] = []
    
    let datePicker = UIDatePicker()
    
    var braintreeClient: BTAPIClient!
    var tyGiaUSD: TyGiaResponse?
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Start Adrress
        setupDropDown()
        setupProvince()
        setupDistrict()
        setupWard()
//        loadDataProvince()
        lbProvince.text = "Thành phố Hồ Chí Minh"
        dropProvince.isUserInteractionEnabled = false
        loadDataDistrict(code: 79)
        //MARK: - End Adrress
        btnThanhToan.layer.borderColor = UIColor.lightGray.cgColor
        btnThanhToan.layer.borderWidth = 1
        btnThanhToan.layer.cornerRadius = 8
        
        setupStatus()
        
        setupKeyboard()
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
        address = user.diachi ?? ""
    }
    func checkFill() -> Bool{
        guard let name = name.text,
              let phone = phone.text,
              let email = email.text,
              let datePlan = datePlan.text,
              let status = status.text,
              let province = lbProvince.text,
              let district = lbDistrict.text,
              let ward = lbWard.text,
              let houseNumber = tfHouseNumber.text
        else {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        self.address = "\(houseNumber), \(ward), \(district), \(province)"
        if (name.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty || datePlan.isEmpty ||
            province.isEmpty || district.isEmpty || ward.isEmpty || houseNumber.isEmpty
        ) {
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
//        print("Current:\(currentDate)")
//        print("datePlan:\(datePlan)")
        
        if (!Date().checkDatePlan(start: datePlan, end: Date().convertDateSQLToView(String(current))) ){
            let alert = UIAlertController(title: "Ngày giao mong muốn phải lớn hơn ngày hiện tại", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (status.isEmpty){
            let alert = UIAlertController(title: "Bạn cần chọn phương thức thanh toán", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    func addOrderDatabase(sum: Int, method: String){
        // Xử lý db
        let name = self.name.text
        let phone = self.phone.text
        let email = self.email.text
        let address = self.address
        let dayPlan = Date().convertDateViewToSQL(self.datePlan.text!)
        let cmnd = UserService.shared.cmnd
        var isPay = true
        if method == "COD"{
            isPay = false
        }
        print("\n BEGIN LIST ORDER ADD DB\n ")
        print(self.list)
        print("\n -------END LIST ORDER ADD DB------\n ")
        
        let params = ModelAddGH(idgiohang: nil, ngaylapgiohang: nil, ngaydukien: dayPlan, tonggiatri: sum, matrangthai: 0, cmnd: cmnd, manvgiao: nil, manvduyet: nil, nguoinhan: name, diachi: address, sdt: phone, email: email, malsp: nil, dslsp: self.list,ngaynhan: nil,phuongthuc: method, thanhtoan: isPay).convertToDictionary()
       print(params)
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
            } else {
                print("ERROR: \(base)" )
            }
        })
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
            if (self.status.text == "Thanh toán khi nhận hàng"){
                
                let alert = UIAlertController(title: "Xác nhận thanh toán COD?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in
                    self.addOrderDatabase(sum: sum,method: "COD")
                }))
                alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                let total = Double(sum) / Double(usd)
//                print(total.rounded(toPlaces: 2))
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

                        self.addOrderDatabase(sum: sum,method: "PAYPAL")
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
    //func updateGH(params: [String : Any]?){
    //    APIService.updateGioHang(with: .updateGioHang, params: params, headers: nil, completion: { base, error in
    //        guard let base = base else { return }
    //        if base.success == true {
    //            print(base)
    //        }
    //        else {
    //            fatalError()
    //        }
    //    })
    //}
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
    //DropDown
    
    // BEGIN STATUS
    private func setupStatus() {
        statusDrop.anchorView = dropdownStatus
        statusDrop.dataSource = statusValues
        statusDrop.bottomOffset = CGPoint(x: 0, y:(statusDrop.anchorView?.plainView.bounds.height)! + 5)
        statusDrop.direction = .bottom
        statusDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.status.text = item
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
                print("\nTỷ giá hiện tại:\(self.tyGiaUSD)")
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
extension InformationViewController{
//    
//    //MARK: - Setup Drop
//    private func setupDropDown() {
//        DropDown.appearance().textColor = UIColor.black
//        DropDown.appearance().selectedTextColor = UIColor.black
//        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
//        DropDown.appearance().backgroundColor = UIColor.white
//        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
//        DropDown.appearance().cornerRadius = 8
//    }
//    
    //MARK: - Setup Province Drop
    private func setupProvince() {
        provinceDrop.anchorView = dropProvince
        provinceDrop.dataSource = provinceValues
        provinceDrop.bottomOffset = CGPoint(x: 0, y:(provinceDrop.anchorView?.plainView.bounds.height)! + 5)
        provinceDrop.direction = .bottom
        provinceDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbProvince.text = item
            guard let code = listProvince.filter({ $0.name == item })[0].code else {return}
            self.lbDistrict.text = ""
            self.lbWard.text = ""
            self.districtValues.removeAll()
            self.wardValues.removeAll()
            setupWard()
            loadDataDistrict(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapProvince))
        dropProvince.addGestureRecognizer(gestureClock)
        dropProvince.layer.borderWidth = 1
        dropProvince.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapProvince() {
        provinceDrop.show()
    }
    
    //MARK: - Setup District Drop
    private func setupDistrict() {
        districtDrop.anchorView = dropDistrict
        districtDrop.dataSource = districtValues
        districtDrop.bottomOffset = CGPoint(x: 0, y:(districtDrop.anchorView?.plainView.bounds.height)! + 5)
        districtDrop.direction = .bottom
        districtDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbDistrict.text = item
            guard let code = listDistrict.filter({ $0.name == item })[0].code else {return}
            self.lbWard.text = ""
            self.wardValues.removeAll()
            loadDataWard(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapDistrict))
        dropDistrict.addGestureRecognizer(gestureClock)
        dropDistrict.layer.borderWidth = 1
        dropDistrict.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapDistrict() {
        districtDrop.show()
    }
    //MARK: - Setup Ward Drop
    private func setupWard() {
        wardDrop.anchorView = dropWard
        wardDrop.dataSource = wardValues
        wardDrop.bottomOffset = CGPoint(x: 0, y:(districtDrop.anchorView?.plainView.bounds.height)! + 5)
        wardDrop.direction = .bottom
        wardDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbWard.text = item
//            guard let code = listWard.filter({ $0.name == item })[0].code else {return}
//            loadDataWard(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapWard))
        dropWard.addGestureRecognizer(gestureClock)
        dropWard.layer.borderWidth = 1
        dropWard.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapWard() {
        wardDrop.show()
    }
}

extension InformationViewController {
    func  loadDataProvince(){
        APIService.getProvince({
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let provinces = data else {return}
            self.listProvince = provinces
            for i in provinces {
                self.provinceValues.append(i.name ?? "")
            }
            self.setupProvince()
        })
    }
    func  loadDataDistrict(code: Int){
        APIService.getDistricts(with: code, {
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let districts = data?.districts else {return}
            self.listDistrict = districts
            for i in districts {
                self.districtValues.append(i.name ?? "")
            }
            self.setupDistrict()
        })
    }
    func  loadDataWard(code: Int){
        listWard.removeAll()
        APIService.getWards(with: code, {
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let wards = data?.wards else {return}
            self.listWard = wards
            for i in wards {
                self.wardValues.append(i.name ?? "")
            }
            self.setupWard()
        })
    }
}

// Chuyen doi tien te
//            let currencyConverter = CurrencyConverter()
//            currencyConverter.updateExchangeRates(completion: {
//                       let doubleResult = currencyConverter.convert(10, valueCurrency: .USD, outputCurrency: .EUR)
//
//                   })
