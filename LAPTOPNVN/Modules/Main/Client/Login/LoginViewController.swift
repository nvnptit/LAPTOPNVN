//
//  LoginViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var username: UITextFieldX!
    
    @IBOutlet weak var password: UITextFieldX!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUI.layer.cornerRadius = 8
        viewUI.layer.borderColor = UIColor.systemGray.cgColor
        viewUI.layer.borderWidth = 2
        
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        password.enablePasswordToggle()
    }
    
    @IBAction func tapForgotPassword(_ sender: UIButton, forEvent event: UIEvent) {
        
            let vc = ForgotPasswordViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        if (username.text == "" || password.text == "" ) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        guard let user = username.text, let pass = password.text else {return}
        let md5Pass = pass.md5
//               if  md5Pass.uppercased() != HASHED{
//                   return false
//               }
//        print(md5Pass)
        let params = LoginModel(tenDangNhap: user, matKhau: md5Pass).convertToDictionary()
        
        APIService.postLogin(with: .login, params, nil, completion: {
            [weak self] base,error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                if (base.data?.maquyen == 7){
                    guard let dataz = base.data else {return}
                    let info = LoginResponse(cmnd: dataz.cmnd, email: dataz.email, ten: dataz.ten, diachi: dataz.diachi, ngaysinh: dataz.ngaysinh, sdt: dataz.sdt, tendangnhap: dataz.tendangnhap)
                    UserService.shared.setInfo(with: info)
                    
                    let mainVC = MainTabBarController()
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
                else  if (base.data?.maquyen == 6) {
                    guard let dataz = base.data else {return}
                    let info = ModelNVResponse(manv: dataz.manv, email: dataz.email, ten: dataz.ten, ngaysinh: dataz.ngaysinh, sdt: dataz.sdt, tendangnhap: dataz.tendangnhap)
                    UserService.shared.setInfoNV(with: info)
                    
                    let mainVC = OrderShipViewController()
                    mainVC.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(mainVC, animated: true)
                } else {
                    guard let dataz = base.data else {return}
                    let info = ModelNVResponse(manv: dataz.manv, email: dataz.email, ten: dataz.ten, ngaysinh: dataz.ngaysinh, sdt: dataz.sdt, tendangnhap: dataz.tendangnhap)
                    UserService.shared.setInfoNV(with: info)
                    
                    let mainVC = HomeAdminViewController()
                    mainVC.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
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
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension LoginViewController{
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
