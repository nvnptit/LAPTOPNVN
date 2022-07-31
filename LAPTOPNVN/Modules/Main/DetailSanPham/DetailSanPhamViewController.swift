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
    let Host = "http://192.168.1.74"

    @IBOutlet weak var imageLSP: UIImageView!
    
    @IBOutlet weak var tfCPU: UILabel!
    
    @IBOutlet weak var tfRam: UILabel!
    
    @IBOutlet weak var tfCard: UILabel!
    @IBOutlet weak var tfDisk: UILabel!
    
    @IBOutlet weak var tfOS: UILabel!
    
    @IBOutlet weak var tfDescription: UILabel!
    
    @IBOutlet weak var btnAddCart: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let loaiSp = loaiSp {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
                let url =  Host + anhlsp
                imageLSP.loadFrom(URLAddress: url)
                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.text = loaiSp.mota
                tfDescription.sizeToFit()
            }
        }
        if let loaiSp = order {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
                let url =  Host + anhlsp
                imageLSP.loadFrom(URLAddress: url)
                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.isHidden = true
                btnAddCart.isHidden = true
            }
        }
    }

    @IBAction func tapAddCart(_ sender: UIButton) {
        let cmnd = UserService.shared.cmnd
        if (cmnd != ""){
            if let loaiSp = loaiSp {
                let params = GioHangModel(idgiohang: nil, ngaylapgiohang: nil, tonggiatri: 0, matrangthai: -1, cmnd: cmnd, manvgiao: nil, manvduyet: nil, nguoinhan: nil, diachi: nil, sdt: nil, email: nil, malsp: loaiSp.malsp).convertToDictionary()
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
    
}
