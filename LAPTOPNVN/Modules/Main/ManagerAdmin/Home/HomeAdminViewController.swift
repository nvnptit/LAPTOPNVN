//
//  HomeAdminViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import UIKit

class HomeAdminViewController: UIViewController {

    @IBOutlet weak var welcome: UILabel!
    
    
    
    
    let info = UserService.shared.infoNV
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        if let name = info?.ten {
            welcome.text = "Chào mừng bạn, \(name)"
        }
        // Do any additional setup after loading the view.
    }
    func loadData(){
        
    }

    @IBAction func tapBrand(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    @IBAction func tapEmployee(_ sender: UIButton, forEvent event: UIEvent) {
        
        
    }
    
    @IBAction func tapCategory(_ sender: Any) {
        
    }
    
    @IBAction func tapProduct(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    
    @IBAction func updateOrder(_ sender: UIButton, forEvent event: UIEvent) {
        
        let mainVC = OrderViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func tapStatistics(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    
}
