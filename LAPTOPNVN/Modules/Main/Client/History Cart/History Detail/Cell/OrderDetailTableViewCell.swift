//
//  OrderDetailTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 21/08/2022.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbGia: UILabel!
    @IBOutlet weak var gia: UILabel!
    @IBOutlet weak var card: UILabel!
    @IBOutlet weak var os: UILabel!
    @IBOutlet weak var disk: UILabel!
    @IBOutlet weak var ram: UILabel!
    @IBOutlet weak var cpu: UILabel!
    @IBOutlet weak var serial: UILabel!
    @IBOutlet weak var tensp: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var viewRate: UIView!
    
    //    let serial: String?
//    let tenlsp: String?
//    let anhlsp: String?
//    let mota: String?
//    let cpu: String?
//    let ram: String?
//    let harddrive: String?
//    let cardscreen: String?
//    let os: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewRate.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
