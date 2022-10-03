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
        print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
    
}
