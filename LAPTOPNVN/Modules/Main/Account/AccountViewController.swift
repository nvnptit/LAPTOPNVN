//
//  AccountViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cmnd = UserService.shared.cmnd
        if (cmnd == ""){
            let loginVC = LoginViewController()
    //        self.navigationController?.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }



}
