//
//  SanPhamCollectionViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 17/07/2022.
//

import UIKit

class SanPhamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
    }

}
