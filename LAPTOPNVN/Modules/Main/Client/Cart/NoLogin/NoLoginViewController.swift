//
//  NoLoginViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 27/07/2022.
//

import UIKit

class NoLoginViewController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.borderColor = UIColor.lightGray.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.cornerRadius = 8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
        if isMovingFromParent, transitionCoordinator?.isInteractive == false {
            let vc = MainTabBarController()
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
}
