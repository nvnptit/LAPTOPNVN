//
//  DetailSanPhamViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 19/07/2022.
//

import UIKit
import SDWebImage

class DetailSanPhamViewController: UIViewController {
    
    var loaiSp: LoaiSanPhamKM?
    var order: HistoryOrder?

    @IBOutlet weak var imageLSP: UIImageView!
    
    @IBOutlet weak var tfCPU: UILabel!
    
    @IBOutlet weak var tfRam: UILabel!
    
    @IBOutlet weak var tfCard: UILabel!
    @IBOutlet weak var tfDisk: UILabel!
    
    @IBOutlet weak var tfOS: UILabel!
    
    @IBOutlet weak var tfDescription: UILabel!
    
    @IBOutlet weak var btnAddCart: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    var isCancel:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (order?.tentrangthai == "Chờ duyệt"){
            btnCancel.isHidden = false
        }else {
             btnCancel.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let loaiSp = loaiSp {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
                let url =  APIService.baseUrl + anhlsp
                imageLSP.loadFrom(URLAddress: url)
                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.text = loaiSp.mota
                tfDescription.sizeToFit()
                self.title = loaiSp.tenlsp
            }
        }
        if let loaiSp = order {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
                let url =  APIService.baseUrl + anhlsp
                imageLSP.loadFrom(URLAddress: url)
                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.text =  loaiSp.mota
                btnAddCart.isHidden = true
                self.title = loaiSp.tenlsp
            }
        }
    }

    @IBAction func tapAddCart(_ sender: UIButton) {
        let cmnd = UserService.shared.cmnd
        if (cmnd != ""){
            if let loaiSp = loaiSp {
                let params = GioHangModel(idgiohang: nil, ngaylapgiohang: nil,ngaydukien: nil, tonggiatri: 0, matrangthai: -1, cmnd: cmnd, manvgiao: nil, manvduyet: nil, nguoinhan: nil, diachi: nil, sdt: nil, email: nil, malsp: loaiSp.malsp).convertToDictionary()
                APIService.addGioHangC(with: .addGioHang, params: params, headers: nil, completion:   { base, error in
                    guard let base = base else { return }
                    var title = ""
                    if base.success == true{
                        title = "Thêm vào giỏ hàng thành công"
                    } else {
                        title = "Sản phẩm đang tạm thời hết hàng"
                    }
                    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                    self.present(alert, animated: true)
            })
            }
        }else {
            
                let loginVC = LoginViewController()
            //        self.navigationController?.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton, forEvent event: UIEvent) {
        
        let alert = UIAlertController(title: "Bạn có chắc huỷ đơn hàng này?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
            self.dismiss(animated: true)
            let params = GioHangEdit(idgiohang: self.order?.idgiohang, ngaylapgiohang: self.order?.ngaylapgiohang,ngaydukien: self.order?.ngaydukien, tonggiatri: self.order?.tonggiatri, matrangthai: 3, manvgiao: nil, manvduyet: nil, nguoinhan: self.order?.nguoinhan, diachi: self.order?.diachi, sdt: self.order?.sdt, email: self.order?.email).convertToDictionary()
            self.updateGH(params: params)
        }))
        self.present(alert, animated: true)
    
    }
    
}
extension DetailSanPhamViewController{
    
    func updateGH(params: [String : Any]?){
        APIService.updateGioHang(with: .updateGioHangAdmin, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                        let alert = UIAlertController(title: "Huỷ đơn hàng thành công", message: "", preferredStyle: .alert)
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
