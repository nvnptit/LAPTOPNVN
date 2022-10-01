//
//  DetailSaleTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit

class DetailSaleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLSP: UILabel!
    
    @IBOutlet weak var percentLSP: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
