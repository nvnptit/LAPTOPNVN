//
//  ProductTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var serial: UILabel!
    @IBOutlet weak var tenLSP: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
