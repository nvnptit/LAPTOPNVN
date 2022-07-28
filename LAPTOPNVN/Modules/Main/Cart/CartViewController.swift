//
//  CartViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 16/07/2022.
//

import UIKit
import NVActivityIndicatorView


class CartViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbTongTien: UILabel!
    @IBOutlet weak var money: UILabel!
    
    var sum: Int = 0
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let Host = "http://192.168.1.74"
    @IBOutlet weak var btnDatHang: UIButton!
    
    
    var data : [GioHangData] = []
    var dataChecked : [GioHangData] = []
    
    let cmnd = UserService.shared.cmnd
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (cmnd == ""){
            lbTongTien.isHidden = true
            money.isHidden = true
            btnDatHang.isHidden = true
            let noLoginVC = NoLoginViewController()
            self.navigationController?.pushViewController(noLoginVC, animated: true)
            return
        }else {
            lbTongTien.isHidden = false
            money.isHidden = false
            btnDatHang.isHidden = false
        }
        self.money.text = "0 VNĐ"
        
        setupAnimation()
        loadData()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ItemCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCartTableViewCell")
    }
    
    @IBAction func tapDatHang(_ sender: UIButton, forEvent event: UIEvent) {
        
        let vc = InformationViewController()
        vc.dataGioHang = self.dataChecked
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool = false) {
        self.navigationController?.isNavigationBarHidden = true
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)
        ])
    }
    
    
    func loadData(){
        loading.startAnimating()
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self , self.cmnd != "" else { return }
            
            let params = GioHangRequest(cmnd: self.cmnd).convertToDictionary()
            
            APIService.getGioHang(with: .getGioHang, params: params, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let dataGioHang = base.data {
                        self.data = dataGioHang
                    }
                } else {
                    fatalError()
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.loading.stopAnimating()
                }
            })
        }
        
        
        
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCartTableViewCell", for: indexPath) as! ItemCartTableViewCell
        let item = data[indexPath.item]
        if let ten = item.tenlsp, let serial = item.serial, let price = item.giamoi, let newPrice = item.giagiam , let anhlsp = item.anhlsp, let gg = item.ptgg{
            
            cell.imageLSP.loadFrom(URLAddress: Host+anhlsp)
            cell.nameLSP.text = ten + "\n"+serial
            cell.oldPrice.text = "\(Currency.toVND(price))"
            cell.newPrice.text = "\(Currency.toVND(newPrice))"
            if (gg > 0 ){
                cell.oldPrice.textColor = .red
                cell.oldPrice.text = "\(Currency.toVND(price))"
                cell.oldPrice.strikeThrough(true)
                cell.newPrice.textColor = .systemGreen
                cell.newPrice.text = "\(Currency.toVND(newPrice))"
            }else {
                cell.oldPrice.text = ""
                cell.newPrice.textColor = .systemGreen
                cell.newPrice.text =  "\(Currency.toVND(price))"
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = data[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCartTableViewCell else { return }
        
        if (!cell.isChecked){
            cell.isChecked=true
            self.sum = self.sum + item.giagiam!
            self.money.text = "\(Currency.toVND(sum))"
            self.dataChecked.append(item)
            cell.checkBox.image = UIImage(named: "check")
        }else {
            cell.isChecked=false
            self.sum = self.sum - item.giagiam!
            self.money.text = "\(Currency.toVND(sum))"
            self.dataChecked = self.dataChecked.filter { $0.idgiohang != item.idgiohang }
            cell.checkBox.image = UIImage(named: "uncheck")
        }
    }
    
}


