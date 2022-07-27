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

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        
        let loginVC = LoginViewController()
//        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
}
