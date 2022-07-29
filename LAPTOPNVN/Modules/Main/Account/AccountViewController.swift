//
//  AccountViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var info: UIView!
    
    @IBOutlet var history: UIView!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var lb7: UILabel!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
    @IBOutlet weak var tfCMND: UITextField!
    @IBOutlet weak var btnThayDoi: UIButton!
    @IBOutlet weak var btnDangXuat: UIButton!
    
    
    @IBOutlet weak var tfFrom: UITextField!
    
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cmnd = UserService.shared.cmnd
        if (cmnd == ""){
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            showhide(true)
        }else {
            showhide(false)
        }
        info.isHidden = false
        history.isHidden = true
        
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func showhide(_ sh: Bool){
        lb1.isHidden = sh
        lb2.isHidden = sh
        lb3.isHidden = sh
        lb4.isHidden = sh
        lb5.isHidden = sh
        lb6.isHidden = sh
        lb7.isHidden = sh
        btnThayDoi.isHidden = sh
        btnDangXuat.isHidden = sh
        
        tfName.isHidden  = sh
        tfBirthday.isHidden  = sh
        tfEmail.isHidden  = sh
        tfPhone.isHidden  = sh
        tfAddress.isHidden  = sh
    }
    @IBAction func tapChangeInfo(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnThayDoi.currentTitle == "THAY ĐỔI THÔNG TIN"){
            tfName.backgroundColor = .none
            tfBirthday.backgroundColor = .none
            tfEmail.backgroundColor = .none
            tfPhone.backgroundColor = .none
            tfAddress.backgroundColor = .none
            
            tfName.isEnabled = true
            tfBirthday.isEnabled = true
            tfEmail.isEnabled = true
            tfPhone.isEnabled = true
            tfAddress.isEnabled = true
            
            btnThayDoi.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
            tfName.backgroundColor = .lightGray
            tfBirthday.backgroundColor = .lightGray
            tfEmail.backgroundColor = .lightGray
            tfPhone.backgroundColor = .lightGray
            tfAddress.backgroundColor = .lightGray
            
            tfName.isEnabled = false
            tfBirthday.isEnabled = false
            tfEmail.isEnabled = false
            tfPhone.isEnabled = false
            tfAddress.isEnabled = false
            
            btnThayDoi.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
        }
    }
    
    @IBAction func tapLogout(_ sender: UIButton, forEvent event: UIEvent) {
    }
    @IBAction func switchView(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        if segment.selectedSegmentIndex == 0 {
            info.isHidden = false
            history.isHidden = true
        } else {
            history.isHidden = false
            info.isHidden = true
        }
    }
    
}

extension AccountViewController{
    //MARK: - Datepicker
    
    private func createToolbar(_ datePickerView: UIDatePicker) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapOnView))
        switch (datePickerView){
            case datePicker1:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker1))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            case datePicker2:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker2))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            default: break
                
        }
        
        return toolbar
    }
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker1.preferredDatePickerStyle = .wheels
        datePicker2.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker1.preferredDatePickerStyle = .inline
            datePicker2.preferredDatePickerStyle = .inline
        }
        
        datePicker1.datePickerMode = .date
        tfFrom.inputView = datePicker1
        tfFrom.inputAccessoryView = createToolbar(datePicker1)
        
        datePicker2.datePickerMode = .date
        tfTo.inputView = datePicker2
        tfTo.inputAccessoryView = createToolbar(datePicker2)
    }
    
    @objc func donedatePicker1() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfFrom.text =  dateFormatter.string(from: datePicker1.date)
        view.endEditing(true)
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        tfTo.text =  dateFormatter.string(from: datePicker2.date)
        view.endEditing(true)
    }
}

extension AccountViewController{
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

