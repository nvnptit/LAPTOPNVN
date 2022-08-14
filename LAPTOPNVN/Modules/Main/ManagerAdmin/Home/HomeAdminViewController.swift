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
        if let name = info?.ten {
            welcome.text = "Chào mừng bạn, \(name)"
        }
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
    }
    @IBAction func tapLogout(_ sender: UIButton, forEvent event: UIEvent) {
        
        UserService.shared.removeAllNV()
        let vc = LoginViewController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapBrand(_ sender: UIButton, forEvent event: UIEvent) {
        let mainVC = BrandViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
        
    }
    @IBAction func tapEmployee(_ sender: UIButton, forEvent event: UIEvent) {
        let mainVC = EmployeeViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func tapCategory(_ sender: Any) {
        let mainVC = CategoryViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
        
    }
    
    @IBAction func tapProduct(_ sender: UIButton, forEvent event: UIEvent) {
        
//            let mainVC = EmployeeViewController()
//            self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func updateOrder(_ sender: UIButton, forEvent event: UIEvent) {
        let mainVC = OrderViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func tapStatistics(_ sender: UIButton, forEvent event: UIEvent) {
        let mainVC = StatisticViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
}
