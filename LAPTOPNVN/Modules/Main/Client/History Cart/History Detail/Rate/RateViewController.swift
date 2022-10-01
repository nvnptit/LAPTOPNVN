//
//  RateViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit
import JXReviewController

class RateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    } 
    func requestReview() {
            let reviewController = JXReviewController()
            reviewController.image = UIImage(systemName: "app.fill")
            reviewController.title = "Enjoy it?"
            reviewController.message = "Tap a star to rate it."
            reviewController.delegate = self
            present(reviewController, animated: true)
    }
}
extension RateViewController: JXReviewControllerDelegate {
    
    func reviewController(_ reviewController: JXReviewController, didSelectWith point: Int) {
        print("Did select with \(point) point(s).")
    }

    func reviewController(_ reviewController: JXReviewController, didCancelWith point: Int) {
        print("Did cancel with \(point) point(s).")
    }

    func reviewController(_ reviewController: JXReviewController, didSubmitWith point: Int) {
        print("Did submit with \(point) point(s).")
    }
}
