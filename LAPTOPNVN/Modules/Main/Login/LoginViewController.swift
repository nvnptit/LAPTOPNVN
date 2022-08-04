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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
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
