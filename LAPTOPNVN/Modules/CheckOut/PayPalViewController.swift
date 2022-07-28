//
//  PayPalViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import UIKit
import BraintreePayPal
import BraintreeDataCollector
class PayPalViewController: UIViewController {
    var braintreeClient: BTAPIClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.braintreeClient = BTAPIClient(authorization: "sandbox_d596sjps_7hsb2swzq3w35xrj")
        //        let customPayPalButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 120))
        //        customPayPalButton.addTarget(self, action: #selector(customPayPalButtonTapped(button:)), for: UIControl.Event.touchUpInside)
        //        self.view.addSubview(customPayPalButton)
    
        
    }
    
    @objc func customPayPalButtonTapped(button: UIButton) {
        let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
        
        // Important! Choose either Vault or Checkout flow
        // Start the Vault flow, or...
        let vaultRequest = BTPayPalVaultRequest()
        payPalDriver.tokenizePayPalAccount(with: vaultRequest) { (tokenizedPayPalAccount, error) in
            // ...
        }
        
        // ...start the Checkout flow
        let checkoutRequest = BTPayPalCheckoutRequest(amount: "1.00")
        payPalDriver.tokenizePayPalAccount(with: checkoutRequest) { (tokenizedPayPalAccount, error) in
            // ...
        }
    }
    
    @IBAction func tapPay(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        // Specify the transaction amount here. "5" is used in this example.
        let request = BTPayPalCheckoutRequest(amount: "5.00")
        request.currencyCode = "USD" // Optional; see BTPayPalCheckoutRequest.h for more options
        
        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                // Access additional information
                let email = tokenizedPayPalAccount.email
                print("EMAIL: \(email)")
//                let firstName = tokenizedPayPalAccount.firstName
//                let lastName = tokenizedPayPalAccount.lastName
//                let phone = tokenizedPayPalAccount.phone
//
//                // See BTPostalAddress.h for details
//                let billingAddress = tokenizedPayPalAccount.billingAddress
//                let shippingAddress = tokenizedPayPalAccount.shippingAddress
            
                let alert = UIAlertController(title: "Thanh toán thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    let vc = MainTabBarController()
                    self.navigationController?.pushViewController(vc, animated: false)
                }))
                self.present(alert, animated: true)
                
            } else if let error = error {
                // Handle error here...
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
