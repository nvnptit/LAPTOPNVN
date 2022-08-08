//
//  PayPalViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import UIKit
import BraintreePayPal
import BraintreeDataCollector
import BraintreePaymentFlow
class PayPalViewController: UIViewController {
    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.braintreeClient = BTAPIClient(authorization: "sandbox_9qswqysc_7hsb2swzq3w35xrj")
        
    }
    
    @IBAction func tapPay(_ sender: UIButton, forEvent event: UIEvent) {
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        
        let request = BTPayPalCheckoutRequest(amount: "100.00")
        request.currencyCode = "USD"
        
        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // Access additional information
                let emailPP = tokenizedPayPalAccount.email
                let firstNamePP = tokenizedPayPalAccount.firstName
                let lastNamePP = tokenizedPayPalAccount.lastName
                let phonePP = tokenizedPayPalAccount.phone
                print("INFO: \(firstNamePP) |\(lastNamePP) |\(emailPP) |\(phonePP)")
                
                let alert = UIAlertController(title: "Thanh toán thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    let vc = MainTabBarController()
                    self.navigationController?.pushViewController(vc, animated: false)
                }))
                self.present(alert, animated: true)
                
            } else if let error = error {
                // Handle error here...
                print(error)
                let alert = UIAlertController(title: "Đã có lỗi xảy ra", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                // Buyer canceled payment approval
            }
        }
        
        
        
    }
    
}
