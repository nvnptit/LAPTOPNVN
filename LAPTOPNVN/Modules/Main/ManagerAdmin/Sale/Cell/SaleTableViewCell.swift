//
//  SaleTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit

class SaleTableViewCell: UITableViewCell {

    @IBOutlet weak var maDotGG: UILabel!
    
    @IBOutlet weak var dateStart: UILabel!
    
    @IBOutlet weak var dateEnd: UILabel!
    @IBOutlet weak var describe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
