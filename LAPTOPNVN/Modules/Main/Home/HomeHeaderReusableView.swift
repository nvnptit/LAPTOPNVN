//
//  HomeHeaderReusableView.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit

protocol HomeHeaderResuableViewDelegate: AnyObject {
    func homeHeader(_ homeHeader: HomeHeaderReusableView, seeMore sender: UIButton, indexPath: IndexPath)
}

class HomeHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var btnSeemore: UIButton!
    
    
    var indexPath: IndexPath!
    weak var delegate: HomeHeaderResuableViewDelegate!
    
    deinit {
        delegate = nil
        indexPath = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func seeMoreAction(_ sender: UIButton) {
        delegate?.homeHeader(self, seeMore: sender, indexPath: indexPath)
    }
}
