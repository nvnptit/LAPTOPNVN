//
//  HistoryOrderTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 31/07/2022.
//

import UIKit

class HistoryOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var datePlan: UILabel!
    @IBOutlet weak var idGH: UILabel!
    
    @IBOutlet weak var receiver: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
