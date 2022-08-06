//
//  DetailBrandViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 07/08/2022.
//

import UIKit

class DetailBrandViewController: UIViewController {

    @IBOutlet weak var tfMaHang: UITextField!
    @IBOutlet weak var tfTenHang: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPicture: UITextField!
    
    @IBOutlet weak var btnChange: UIButton!
    var brand: HangSX?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
        title = brand?.tenhang!
    }
    func loadData(){
        if let brand = brand {
            self.tfMaHang.text = "\(brand.mahang!)"
            self.tfTenHang.text = brand.tenhang!
            self.tfEmail.text = brand.email
            self.tfPhone.text = brand.sdt
            self.tfPicture.text = brand.logo
        }
    }
    
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    func checkFill()->Bool {
        return true
    }
    @IBAction func tapChangeInfo(_ sender: UIButton, forEvent event: UIEvent) {
        
            if (btnChange.currentTitle == "THAY ĐỔI THÔNG TIN"){
//                tfMaHang.backgroundColor = .none
                tfTenHang.backgroundColor = .none
                tfEmail.backgroundColor = .none
                tfPhone.backgroundColor = .none
                tfPicture.backgroundColor = .none
                
//                tfMaHang.isEnabled = true
                tfTenHang.isEnabled = true
                tfEmail.isEnabled = true
                tfPhone.isEnabled = true
                tfPicture.isEnabled = true
                
                btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
            }
            else {
                if (checkFill()){
//                    tfMaHang.backgroundColor = .lightGray
                    tfTenHang.backgroundColor = .lightGray
                    tfEmail.backgroundColor = .lightGray
                    tfPhone.backgroundColor = .lightGray
                    tfPicture.backgroundColor = .lightGray
                    
//                    tfMaHang.isEnabled = false
                    tfTenHang.isEnabled = false
                    tfEmail.isEnabled = false
                    tfPhone.isEnabled = false
                    tfPicture.isEnabled = false
                    
                    let maHang = Int(tfMaHang.text!)
                    let name = chuanHoa(tfTenHang.text)
                    let email = chuanHoa(tfEmail.text)
                    let phone = chuanHoa(tfPhone.text)
                    let picture = chuanHoa(tfPicture.text)
                    
                    
                    tfTenHang.text = name
                    tfEmail.text = email
                    tfPhone.text = phone
                    tfPicture.text = picture
                    
                    let params = HangSX(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: picture)
                    
                    btnChange.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
                    
                }
            }
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        
    }
    
}
