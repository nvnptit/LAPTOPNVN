//
//  CategoryTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cpu: UILabel!
    @IBOutlet weak var ram: UILabel!
    @IBOutlet weak var card: UILabel!
    
    @IBOutlet weak var disk: UILabel!
    
    @IBOutlet weak var os: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
