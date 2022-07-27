//
//  LoginViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextFieldX!
    
    @IBOutlet weak var password: UITextFieldX!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        guard let user = username.text, let pass = password.text else {
            
            let alert = UIAlertController(title: "Tên đăng nhập hoặc mật khẩu không được để trống", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        
        let params = LoginModel(tenDangNhap: user, matKhau: pass).convertToDictionary()
        
        APIService.postLogin(with: .login, params, nil, completion: {
            [weak self] base,error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                UserService.shared.setInfo(with: base.data)
                let mainVC = MainTabBarController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                let alert = UIAlertController(title: "Tên đăng nhập hoặc mật khẩu không hợp lệ", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
        
    }
    
    
    
    @IBAction func didTapRegister(_ sender: UIButton, forEvent event: UIEvent) {
        let amount = 123456
        print(Currency.toVND(amount))
    }
}

