//
//  ItemCartTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/07/2022.
//

import UIKit

class ItemCartTableViewCell: UITableViewCell {

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
