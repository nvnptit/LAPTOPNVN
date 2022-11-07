//
//  DetailOrderViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import UIKit
import DropDown
import NVActivityIndicatorView

class DetailOrderViewController: UIViewController {
    
    @IBOutlet weak var datePlan: UITextField!
    @IBOutlet weak var lbMap: UIButton!
    @IBOutlet weak var maDH: UILabel!
    
    @IBOutlet weak var nguoiNhan: UILabel!
    @IBOutlet weak var sdt: UILabel!
    @IBOutlet weak var ngayLapDon: UILabel!
    
    @IBOutlet weak var diaChi: UILabel!
    @IBOutlet weak var trangThai: UILabel!
    
    @IBOutlet weak var tongtien: UILabel!
    @IBOutlet weak var nvDuyet: UILabel!
    
    @IBOutlet weak var lbNVGiao: UILabel!
    @IBOutlet weak var nvGiao: UILabel!
    
    @IBOutlet weak var dropDownNVGiao: UIView!
    @IBOutlet weak var dropDownNVDuyet: UIView!
    
    @IBOutlet weak var btnDuyet: UIButton!
    @IBOutlet weak var btnHuy: UIButton!
    
    @IBOutlet weak var lbTongTien: UILabel!
    
    @IBOutlet weak var method: UILabel!
    
    
    var data: [EmployeeModel] = []
    var KEY = ""
    var dropNVDuyet = DropDown()
    var dropNVGiao = DropDown()
    var nvDuyetValues: [String] = []
    var nvGiaoValues: [String] = []
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    var maNVD: String = ""
    var maNVG: String = ""
    
    var order: HistoryOrder1?
//    var order1: HistoryOrder1?
    
    
    let datePicker1 = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupDropDown()
        setupKeyboard()
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
        loadData()
        if  self.order?.tentrangthai == "Đang giao hàng" {
            lbMap.isHidden = false
        }else { lbMap.isHidden = true}
        
        if let order = order {
            self.title = "Giỏ hàng \(order.idgiohang!)"
        }
        if (order?.tentrangthai == "Chờ duyệt"){
            if let name = UserService.shared.infoNV?.ten,
               let manvd = UserService.shared.infoNV?.manv{
                self.maNVD = manvd
                nvDuyet.text = name
            }
            getDataNVGiao()
        }else if (order?.tentrangthai == "Đang giao hàng" && KEY != "SHIPPER") {
            lbNVGiao.isHidden = false
            dropDownNVGiao.isHidden = false
            nvGiao.isHidden = false
            getDataNVGiao()
            btnHuy.isHidden = true
            btnDuyet.setTitle("Lưu thay đổi", for: .normal)
                btnDuyet.isEnabled = false
        }else if (order?.tentrangthai == "Đang giao hàng" && KEY == "SHIPPER") {
//            btnHuy.isHidden = true
            btnDuyet.setTitle("Xác nhận đã giao hàng", for: .normal)
            // Cap nhat thoi gian nhan du kien
            btnHuy.setTitle("Cập nhật thời gian dự kiến", for: .normal)
        }else {
            btnDuyet.isHidden = true
            btnHuy.isHidden = true
        }
    }
    
    func loadData(){
        if (order?.phuongthuc == "COD") && (order?.tentrangthai == "Chờ duyệt" || order?.tentrangthai == "Đang giao hàng" ){
            self.lbTongTien.text = "Tổng tiền cần thu:"
        }
        if let order = order {
            method.text = order.phuongthuc
            maDH.text = "\(order.idgiohang!)"
            nguoiNhan.text = order.nguoinhan
            sdt.text = order.sdt
            ngayLapDon.text = Date().convertDateTimeSQLToView(date: order.ngaylapgiohang!, format: "dd-MM-yyyy HH:MM:ss")
            datePlan.text = Date().convertDateTimeSQLToView(date: order.ngaydukien!, format: "dd-MM-yyyy")
            diaChi.text = order.diachi
            trangThai.text = order.tentrangthai
            nvDuyet.text = order.nvduyet ?? ""
            nvGiao.text = order.nvgiao ?? ""
            tongtien.text = "\(CurrencyVN.toVND(order.tonggiatri!))"
        }
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
    
    @IBAction func tapMap(_ sender: UIButton, forEvent event: UIEvent) {
            let vc = MapsViewController()
        vc.address = order?.diachi ?? ""
        vc.totalz = order?.tonggiatri ?? 0
        vc.isPay = order?.thanhtoan ?? false
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    @IBAction func tapDuyetDon(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnDuyet.titleLabel?.text == "Duyệt đơn"){
            if (self.maNVG == ""){
                let alert = UIAlertController(title: "Bạn cần chọn nhân viên giao", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return;
            }
            print("Duyệt")
            guard let datePlan = self.datePlan.text else {return}
            let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: Date().convertDateViewToSQL(datePlan), tonggiatri: order?.tonggiatri, matrangthai: 1, manvgiao: self.maNVG, manvduyet: self.maNVD, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email,phuongthuc: order?.phuongthuc,thanhtoan: order?.thanhtoan).convertToDictionary()
            self.updateGH(params: params)

            
        }else if (btnDuyet.titleLabel?.text == "Xác nhận đã giao hàng"){
            print("Xác nhận")
            
            let alert = UIAlertController(title: "Xác nhận đã giao hàng?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ [self] _ in
                self.dismiss(animated: true)
                let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: nil, tonggiatri: order?.tonggiatri, matrangthai: 2, manvgiao: maNVG, manvduyet: self.maNVD, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: self.order?.sdt, email: order?.email,phuongthuc: order?.phuongthuc,thanhtoan: true).convertToDictionary()
                self.updateShipper(params: params)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            
            
        }else {
            print("Lưu")
            let currentDate = Date()
            let current = "\(currentDate)".prefix(10)
            guard let datePlan = self.datePlan.text else {return}
            if (!Date().checkDatePlan(start: datePlan, end: Date().convertDateSQLToView(String(current))) ){
                let alert = UIAlertController(title: "Ngày giao dự kiến mới cần sau ngày hiện tại", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            
            let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: Date().convertDateViewToSQL(datePlan), tonggiatri: order?.tonggiatri, matrangthai: 1, manvgiao: self.maNVG, manvduyet: nil, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email,phuongthuc: order?.phuongthuc,thanhtoan: order?.thanhtoan).convertToDictionary()
            print(params)
            self.updateGH(params: params)
            
        }
    }
    
    @IBAction func tapHuyDon(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnHuy.titleLabel?.text == "Huỷ đơn"){
            guard let order = self.order else {return}
            let alert = UIAlertController(title: "Bạn có chắc huỷ đơn hàng này?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
                self.dismiss(animated: true)
                let params = GioHangEdit(idgiohang: order.idgiohang, ngaylapgiohang: order.ngaylapgiohang,ngaydukien: order.ngaydukien, tonggiatri: order.tonggiatri, matrangthai: 3, manvgiao: nil, manvduyet: nil, nguoinhan: order.nguoinhan, diachi: order.diachi, sdt: order.sdt, email: order.email,phuongthuc: order.phuongthuc,thanhtoan: order.thanhtoan).convertToDictionary()
                self.updateGH(params: params)
            }))
            self.present(alert, animated: true)
            
        }else // Cap nhat thoi gian du kien
        {
            let currentDate = Date()
            let current = "\(currentDate)".prefix(10)
            guard let datePlan = datePlan.text else {return}
            if (!Date().checkDatePlan(start: datePlan, end: Date().convertDateSQLToView(String(current))) ){
                let alert = UIAlertController(title: "Ngày giao dự kiến mới cần sau ngày hiện tại", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            
            let newDatePlan = Date().convertDateViewToSQL(datePlan)
            let alert = UIAlertController(title: "Bạn có chắc cập nhật ngày giao dự kiến mới?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ [self] _ in
                self.dismiss(animated: true)
                let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: newDatePlan, tonggiatri: order?.tonggiatri, matrangthai: 1, manvgiao: maNVG, manvduyet: self.maNVD, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: self.order?.sdt, email: order?.email,phuongthuc: order?.phuongthuc,thanhtoan: true).convertToDictionary()
                self.updateShipper(params: params)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            
        }
    }
    
    @IBAction func tapDetail(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = DetailHistoryViewController()
        if let order = order {
            vc.id = order.idgiohang
            vc.order = order
            vc.isRate = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension DetailOrderViewController {
    func updateGH(params: [String : Any]?){
        APIService.updateGioHang(with: .updateGioHangAdmin, params: params, headers: nil, completion: { base, error in
            print("OKKKS")
            print(base)
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Cập nhật thông tin đơn hàng thành công!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
            }
            else {
                    let alert = UIAlertController(title: "Đã có lỗi xảy ra!", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                            self.dismiss(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
            }
        })
    }
    func updateShipper(params: [String : Any]?){
        APIService.updateGioHang(with: .putOrderShipper, params: params, headers: nil, completion: { base, error in
            guard let base = base, let mess = base.message else { return }
            if base.success == true {
                let alert = UIAlertController(title: mess, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else {
                fatalError()
            }
        })
    }
}

extension DetailOrderViewController{
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
    }
    @objc func keyboardWillHide(notification:NSNotification) {
    }
    //MARK: - End Setup keyboard
}
extension DetailOrderViewController{
    //Nhan vien Duyet
    
    private func setupNVDuyet() {
        dropNVDuyet.anchorView = dropDownNVDuyet
        dropNVDuyet.dataSource = nvDuyetValues
        dropNVDuyet.bottomOffset = CGPoint(x: 0, y:(dropNVDuyet.anchorView?.plainView.bounds.height)! + 5)
        dropNVDuyet.direction = .bottom
        dropNVDuyet.selectionAction = { [unowned self] (index: Int, item: String) in
            let items = item.components(separatedBy: "|")
            let name = items[0]
            self.nvDuyet.text = name
            self.maNVD = items[1]
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapNVDuyet))
        dropDownNVDuyet.addGestureRecognizer(gestureClock)
        dropDownNVDuyet.layer.borderWidth = 1
        dropDownNVDuyet.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapNVDuyet() {
        dropNVDuyet.show()
    }
    
    private func getDataNVDuyet(){
        APIService.getNVDG(with: .getNVDuyet, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.data = base.data ?? []
                for item in self.data{
                    self.nvDuyetValues.append("\(item.ten!)|\(item.manv!)")
                }
                self.setupNVDuyet()
            }
        })
    }
    
    
}

extension DetailOrderViewController{
    //Nhan vien Giao Hang
    
    private func setupNVGiao() {
        dropNVGiao.anchorView = dropDownNVGiao
        dropNVGiao.dataSource = nvGiaoValues
        dropNVGiao.bottomOffset = CGPoint(x: 0, y:(dropNVGiao.anchorView?.plainView.bounds.height)! + 5)
        dropNVGiao.direction = .bottom
        dropNVGiao.selectionAction = { [unowned self] (index: Int, item: String) in
            let items = item.components(separatedBy: "|")
            let name = items[0]
            self.nvGiao.text = name
            self.maNVG = items[1]
            
            guard let nvgiao1 = order?.nvgiao else {return}
            let nvgiao2 = nvGiao.text
                if (nvgiao2 != nvgiao1){
                    btnDuyet.isEnabled = true
                }else {
                    btnDuyet.isEnabled = false
                }
        }
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapNVGiao))
        dropDownNVGiao.addGestureRecognizer(gestureClock)
        dropDownNVGiao.layer.borderWidth = 1
        dropDownNVGiao.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapNVGiao() {
        dropNVGiao.show()
    }
    
    private func getDataNVGiao(){
        APIService.getNVDG(with: .getNVGiao, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.data = base.data ?? []
                for item in self.data{
                    self.nvGiaoValues.append("\(item.ten!)|\(item.manv!)")
                    if item.ten == self.nvGiao.text {
                        self.maNVG  = item.manv!
                    }
                }
                self.setupNVGiao()
            }
        })
    }
}

extension DetailOrderViewController{
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
            default: break
                
        }
        
        return toolbar
    }
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker1.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker1.preferredDatePickerStyle = .inline
        }
        
        datePicker1.datePickerMode = .date
        datePlan.inputView = datePicker1
        datePlan.inputAccessoryView = createToolbar(datePicker1)
        
    }
    
    @objc func donedatePicker1() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        datePlan.text =  dateFormatter.string(from: datePicker1.date)
        guard var date1 = order?.ngaydukien else {return}
        date1 = Date().convertDateTimeSQLToView(date: date1, format: "dd-MM-yyyy")
        let date2 = self.datePlan.text
            if (date2 != date1 ){
                btnDuyet.isEnabled = true
            }else {
                btnDuyet.isEnabled = false
            }
        
        view.endEditing(true)
    }
}
