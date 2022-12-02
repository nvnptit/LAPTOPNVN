//
//  StatLSPTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 02/12/2022.
//

import UIKit

class StatLSPTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sln: UILabel!
    @IBOutlet weak var slb: UILabel!
    @IBOutlet weak var slt: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
