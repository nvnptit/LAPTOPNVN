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
    
    @IBOutlet weak var maDH: UILabel!
    
    @IBOutlet weak var nguoiNhan: UILabel!
    @IBOutlet weak var sdt: UILabel!
    @IBOutlet weak var ngayLapDon: UILabel!
    @IBOutlet weak var ngayDuKien: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupDropDown()
        setupKeyboard()
        loadData()
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
        }else if (order?.tentrangthai == "Đang giao hàng" && KEY == "SHIPPER") {
            btnHuy.isHidden = true
            btnDuyet.setTitle("Xác nhận đã giao hàng", for: .normal)
        }else {
            btnDuyet.isHidden = true
            btnHuy.isHidden = true
        }
    }
    
    func loadData(){
        if let order = order {
            maDH.text = "\(order.idgiohang!)"
            nguoiNhan.text = order.nguoinhan
            sdt.text = order.sdt
            ngayLapDon.text = Date().convertDateTimeSQLToView(date: order.ngaylapgiohang!, format: "dd-MM-yyyy HH:MM:ss")
            ngayDuKien.text = Date().convertDateTimeSQLToView(date: order.ngaydukien!, format: "dd-MM-yyyy")
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
            let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: order?.ngaydukien, tonggiatri: order?.tonggiatri, matrangthai: 1, manvgiao: self.maNVG, manvduyet: self.maNVD, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email).convertToDictionary()
            self.updateGH(params: params)
            print(params)
            let alert = UIAlertController(title: "Duyệt đơn hàng thành công", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
            
        }else if (btnDuyet.titleLabel?.text == "Xác nhận đã giao hàng"){
            print("Xác nhận")
            let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: order?.ngaydukien, tonggiatri: order?.tonggiatri, matrangthai: 2, manvgiao: self.maNVG, manvduyet: self.maNVD, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email).convertToDictionary()
            self.updateShipper(params: params)
            print(params)
            let alert = UIAlertController(title: "Giao hàng thành công", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
                
                self.navigationController?.popViewController(animated: true)
//                let vc = OrderShipViewController()
//                self.navigationController?.pushViewController(vc, animated: false)
            }))
            self.present(alert, animated: true)
            
        }else {
            print("Lưu")
            let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: order?.ngaydukien, tonggiatri: order?.tonggiatri, matrangthai: 1, manvgiao: self.maNVG, manvduyet: nil, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email).convertToDictionary()
            self.updateGH(params: params)
            print(params)
            let alert = UIAlertController(title: "Cập nhật nhân viên giao hàng thành công", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
            
        }
    }
    
    @IBAction func tapHuyDon(_ sender: UIButton, forEvent event: UIEvent) {
        let params = GioHangEdit(idgiohang: order?.idgiohang, ngaylapgiohang: order?.ngaylapgiohang,ngaydukien: order?.ngaydukien, tonggiatri: order?.tonggiatri, matrangthai: 3, manvgiao: nil, manvduyet: nil, nguoinhan: order?.nguoinhan, diachi: order?.diachi, sdt: order?.sdt, email: order?.email).convertToDictionary()
        self.updateGH(params: params)
        
        let alert = UIAlertController(title: "Huỷ đơn hàng thành công", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
            let vc = OrderViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func tapDetail(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = DetailHistoryViewController()
        if let order = order {
            vc.id = order.idgiohang
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension DetailOrderViewController {
    func updateGH(params: [String : Any]?){
        APIService.updateGioHang(with: .updateGioHangAdmin, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                print(base)
            }
            else {
                fatalError()
            }
        })
    }
    func updateShipper(params: [String : Any]?){
        APIService.updateGioHang(with: .putOrderShipper, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                print(base)
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
                }
                self.setupNVGiao()
            }
        })
    }
}
