//
//  TestAddressViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 28/10/2022.
//

import UIKit
import DropDown

class TestAddressViewController: UIViewController {
    
    @IBOutlet weak var dropProvince: UIView!
    @IBOutlet weak var lbProvince: UILabel!
    
    @IBOutlet weak var dropDistrict: UIView!
    @IBOutlet weak var lbDistrict: UILabel!
    
    @IBOutlet weak var dropWard: UIView!
    @IBOutlet weak var lbWard: UILabel!
    
    @IBOutlet weak var tfHouseNumber: UITextField!
    
    var listProvince: [ProvinceElement] = []
    var listDistrict: [DistrictElement] = []
    var listWard: [WardElement] = []
    
    var provinceDrop = DropDown()
    var districtDrop = DropDown()
    var wardDrop = DropDown()
    
    var provinceValues: [String] = []
    var districtValues: [String] = []
    var wardValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        setupProvince()
        setupDistrict()
        setupWard()
//        loadDataProvince()
        lbProvince.text = "Thành phố Hồ Chí Minh"
        dropProvince.isUserInteractionEnabled = false
        loadDataDistrict(code: 79)
    }
    func  loadDataProvince(){
        APIService.getProvince({
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let provinces = data else {return}
            self.listProvince = provinces
            for i in provinces {
                self.provinceValues.append(i.name ?? "")
            }
            self.setupProvince()
        })
    }
    func  loadDataDistrict(code: Int){
        APIService.getDistricts(with: code, {
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let districts = data?.districts else {return}
            self.listDistrict = districts
            for i in districts {
                self.districtValues.append(i.name ?? "")
            }
            self.setupDistrict()
        })
    }
    func  loadDataWard(code: Int){
        listWard.removeAll()
        APIService.getWards(with: code, {
            data, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            guard let wards = data?.wards else {return}
            self.listWard = wards
            for i in wards {
                self.wardValues.append(i.name ?? "")
            }
            self.setupWard()
        })
    }
}
extension TestAddressViewController{
    
    //MARK: - Setup Drop
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    //MARK: - Setup Province Drop
    private func setupProvince() {
        provinceDrop.anchorView = dropProvince
        provinceDrop.dataSource = provinceValues
        provinceDrop.bottomOffset = CGPoint(x: 0, y:(provinceDrop.anchorView?.plainView.bounds.height)! + 5)
        provinceDrop.direction = .bottom
        provinceDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbProvince.text = item
            guard let code = listProvince.filter({ $0.name == item })[0].code else {return}
            self.lbDistrict.text = ""
            self.lbWard.text = ""
            self.districtValues.removeAll()
            self.wardValues.removeAll()
            setupWard()
            loadDataDistrict(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapProvince))
        dropProvince.addGestureRecognizer(gestureClock)
        dropProvince.layer.borderWidth = 1
        dropProvince.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapProvince() {
        provinceDrop.show()
    }
    
    //MARK: - Setup District Drop
    private func setupDistrict() {
        districtDrop.anchorView = dropDistrict
        districtDrop.dataSource = districtValues
        districtDrop.bottomOffset = CGPoint(x: 0, y:(districtDrop.anchorView?.plainView.bounds.height)! + 5)
        districtDrop.direction = .bottom
        districtDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbDistrict.text = item
            guard let code = listDistrict.filter({ $0.name == item })[0].code else {return}
            self.lbWard.text = ""
            self.wardValues.removeAll()
            loadDataWard(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapDistrict))
        dropDistrict.addGestureRecognizer(gestureClock)
        dropDistrict.layer.borderWidth = 1
        dropDistrict.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapDistrict() {
        districtDrop.show()
    }
    //MARK: - Setup Ward Drop
    private func setupWard() {
        wardDrop.anchorView = dropWard
        wardDrop.dataSource = wardValues
        wardDrop.bottomOffset = CGPoint(x: 0, y:(districtDrop.anchorView?.plainView.bounds.height)! + 5)
        wardDrop.direction = .bottom
        wardDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbWard.text = item
//            guard let code = listWard.filter({ $0.name == item })[0].code else {return}
//            loadDataWard(code: code)
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapWard))
        dropWard.addGestureRecognizer(gestureClock)
        dropWard.layer.borderWidth = 1
        dropWard.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func didTapWard() {
        wardDrop.show()
    }
}
