//
//  TogglePassword.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import Foundation
import UIKit

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "closeEye")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        }else{
            button.setImage(UIImage(named: "openEye")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        }
    }
    
    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.frame = CGRect (x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}
