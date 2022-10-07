//
//  ForgotPasswordViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 03/10/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var email: UITextFieldX!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
    }
    
    @IBAction func tapForgotPassword(_ sender: UIButton, forEvent event: UIEvent) {
        guard let email =  email.text else {return}
        if (email == ""){
            let alert = UIAlertController(title: "Bạn cần điền email!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
        if (!isValidEmail(email: email)){
            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        } else {
            let params = ForgotModel(email: email).convertToDictionary()
            APIService.postRequest(with: .postForgotPassword, params: params, headers: nil, completion:  {
                base, error in
                guard let base = base else {return}
                let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            })
        }
    }
}
extension ForgotPasswordViewController{
    func isValidEmail( email:String)->Bool{
        let regexEmail = "^[\\w-\\.\\+]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let passwordTest=NSPredicate(format:"SELF MATCHES%@",regexEmail)
        //   print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
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
        
        //        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //        contentInset.bottom = keyboardFrame.size.height + 70
        //        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}
