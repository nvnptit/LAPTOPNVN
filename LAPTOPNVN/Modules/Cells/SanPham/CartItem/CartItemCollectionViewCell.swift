//
//  CartItemCollectionViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 21/07/2022.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageLSP: UIImageView!
    
    @IBOutlet weak var nameLSP: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    
    @IBOutlet weak var checkBox: UIImageView!
    var isChecked: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
