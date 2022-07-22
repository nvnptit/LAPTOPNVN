//
//  HangCollectionViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 17/07/2022.
//

import UIKit

class HangCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var viewLogo: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLogo.layer.cornerRadius = 5
        viewLogo.layer.masksToBounds = true
        viewLogo.layer.borderColor = UIColor.systemGray.cgColor
        viewLogo.layer.borderWidth = 1
    }

}
