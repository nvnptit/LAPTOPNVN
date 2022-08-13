//
//  EmployeeTableViewCell.swift
//  LAPTOPNVN
//
//  Created by Nhat on 13/08/2022.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var maNV: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var ten: UILabel!
    @IBOutlet weak var ngaySinh: UILabel!
    @IBOutlet weak var sdt: UILabel!
    @IBOutlet weak var tenDangNhap: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
