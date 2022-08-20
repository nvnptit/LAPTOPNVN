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
            self.navigationController?.pushViewController(noLoginVC, animated: false)
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
        if (!self.dataChecked.isEmpty){
            let vc = InformationViewController()
            vc.dataGioHang = self.dataChecked
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let alert = UIAlertController(title: "Bạn chưa chọn sản phẩm nào", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }
        
    }
    override func viewDidAppear(_ animated: Bool = false) {
        self.navigationController?.isNavigationBarHidden = true
        loadData()
        if (data.isEmpty){
            self.money.text = "0 VNĐ"
            
        }
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
            
            cell.imageLSP.loadFrom(URLAddress: APIService.baseUrl+anhlsp)
            cell.nameLSP.text = ten + "\nSerial: "+serial
            cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
            cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            if (gg > 0 ){
                cell.oldPrice.textColor = .red
                cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
                cell.oldPrice.strikeThrough(true)
                cell.newPrice.textColor = .systemGreen
                cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            }else {
                cell.oldPrice.text = ""
                cell.newPrice.textColor = .systemGreen
                cell.newPrice.text =  "\(CurrencyVN.toVND(price))"
            }
        }
        cell.selectionStyle = .none
        // Checked
        if  dataChecked.contains(where: {$0.serial == item.serial }){
            cell.isChecked = true
            cell.checkBox.image = UIImage(named: "check")
        }else {
            cell.isChecked = false
            cell.checkBox.image = UIImage(named: "uncheck")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = data[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCartTableViewCell else { return }
        
        if (!cell.isChecked){
            cell.isChecked=true
            self.sum = self.sum + item.giagiam!
            self.money.text = "\(CurrencyVN.toVND(sum))"
            self.dataChecked.append(item)
            cell.checkBox.image = UIImage(named: "check")
        }else {
            cell.isChecked=false
            self.sum = self.sum - item.giagiam!
            self.money.text = "\(CurrencyVN.toVND(sum))"
            self.dataChecked = self.dataChecked.filter { $0.idgiohang != item.idgiohang }
            cell.checkBox.image = UIImage(named: "uncheck")
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // delete
//        
//            let alert = UIAlertController(title: "Bạn muốn loại bỏ sản phẩm này", message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Có", style: .cancel, handler:{ _ in
//            self.dismiss(animated: true)
//        }))
//        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler:{ _ in
//            self.dismiss(animated: true)
//            return
//        }))
//            self.present(alert, animated: true)
        
        let delete = UIContextualAction(style: .normal, title: "Xoá") { (action, view, completionHandler) in
             print("Delete: \(indexPath.row + 1)")
            
            
            let item = self.data[indexPath.item]
            if  self.dataChecked.contains(where: {$0.serial == item.serial }){
                self.sum = self.sum - item.giagiam!
                self.money.text = "\(CurrencyVN.toVND(self.sum))"
                self.dataChecked = self.dataChecked.filter { $0.idgiohang != item.idgiohang }
            }

            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // Xử lý API
            let params = GioHangDel(idGioHang: item.idgiohang!).convertToDictionary()
            APIService.deleteGioHang(with: .deleteGioHang, params: params, headers: nil, completion: {
                 base, error in
                    if let base = base {
                        if (base.success == true){
                        }else {
                            print(base.message)
                        }
                    }
            })
             completionHandler(true)
           }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
           // swipe
           let swipe = UISwipeActionsConfiguration(actions: [delete])
           
           return swipe
    }
    
}
