//
//  SanPhamCollectionViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 17/07/2022.
//

import UIKit

class SanPhamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var newPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
