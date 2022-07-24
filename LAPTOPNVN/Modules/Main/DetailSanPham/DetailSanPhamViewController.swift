//
//  DetailSanPhamViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 19/07/2022.
//

import UIKit
import SDWebImage

class DetailSanPhamViewController: UIViewController {
    
    var loaiSp: LoaiSanPham?
    var loaiSp2: LoaiSanPhamKM?
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
        if let loaiSp = loaiSp2 {
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
    }

    @IBAction func tapAddCart(_ sender: UIButton) {
        if let loaiSp = loaiSp {
            let params = GioHangModel(idgiohang: nil, ngaylapgiohang: nil, tonggiatri: 0, matrangthai: -1, cmnd: "300123456", manvgiao: nil, manvduyet: nil, nguoinhan: nil, diachi: nil, sdt: nil, email: nil, malsp: loaiSp.malsp).convertToDictionary()
//            bi nay la do kieu du lieu moi bien thui ma cho nil  vs ""
             
            print(params)
            
            APIService.addGioHangC(with: .addGioHang, params: params, headers: nil, completion:   { base, error in
            guard let base = base else { return }
                    let alert = UIAlertController(title: "Thêm vào giỏ hàng thành công!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
        })
        }
    }
    
}
