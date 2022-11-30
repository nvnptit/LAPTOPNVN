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
    
    var isOK:Bool?
    var data: [Orders] = []
    var dataChecked: [Orders] = []
    
    let cmnd = UserService.shared.cmnd
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDatHang.layer.borderColor = UIColor.lightGray.cgColor
        btnDatHang.layer.borderWidth = 1
        btnDatHang.layer.cornerRadius = 8
        
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
//        self.navigationController?.isNavigationBarHidden = true
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
        
        self.data = UserService.shared.getlistGH()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.loading.stopAnimating()
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
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
        guard let item = data[indexPath.item].data else {return cell}
        //let serial = item.serial,
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        if let ten = item.tenlsp,  let price = item.giamoi, let newPrice = item.giagiam , let anhlsp = item.anhlsp, let gg = item.ptgg{
            
//            cell.imageLSP.loadFrom(URLAddress: APIService.baseUrl+anhlsp)
            
            cell.imageLSP.getImage(url: APIService.baseUrl + anhlsp, completion: { img in
                DispatchQueue.main.sync {
                    cell.imageLSP.image = img
                }
            })
            
            
            cell.nameLSP.text = ten //+ "\nSerial: "+serial
            cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
            cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            if (gg > 0 ){
                cell.oldPrice.textColor = .red
                cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
                cell.oldPrice.strikeThrough(true)
                cell.newPrice.textColor = .black
                cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            }else {
                cell.oldPrice.text = ""
                cell.newPrice.textColor = .systemGreen
                cell.newPrice.text =  "\(CurrencyVN.toVND(price))"
            }
        }
        cell.quantity.text = "\(data[indexPath.item].sl)"
        cell.selectionStyle = .none
        
        
        let gestureMinus : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapOnMinus(tapGesture:)))
        gestureMinus.delegate = self
        gestureMinus.numberOfTapsRequired = 1
        cell.viewOfMinus.isUserInteractionEnabled = true
        cell.viewOfMinus.tag = indexPath.row
        cell.viewOfMinus.addGestureRecognizer(gestureMinus)
        
        let gesturePlus : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapOnPlus(tapGesture:)))
        gesturePlus.delegate = self
        gesturePlus.numberOfTapsRequired = 1
        cell.viewOfPlus.isUserInteractionEnabled = true
        cell.viewOfPlus.tag = indexPath.row
        cell.viewOfPlus.addGestureRecognizer(gesturePlus)
        
        
        // Checked
        if  dataChecked.contains(where: {$0.data?.malsp == item.malsp }){
            cell.isChecked = true
            cell.checkBox.image = UIImage(named: "check")
        }else {
            cell.isChecked = false
            cell.checkBox.image = UIImage(named: "uncheck")
        }
        return cell
    }
    
    @objc func tapOnMinus(tapGesture:UITapGestureRecognizer) {
        print("Minus")
        let indexPath2 = IndexPath(row: tapGesture.view!.tag, section: 0)
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath as IndexPath) as? ItemCartTableViewCell else { return }
        let item = data[indexPath2.item]
        var tempQuantity = 0
        tempQuantity = Int(cell.quantity.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) - 1
        if tempQuantity > 0 {
            UserService.shared.putOrder2(order: item, k: 0)
            cell.quantity.text = "\(tempQuantity)"
            if (cell.isChecked){
                self.sum = self.sum - (item.data?.giagiam)!
                self.money.text = "\(CurrencyVN.toVND(self.sum))"}
        }else {
            let alert = UIAlertController(title: "Bạn có chắc xoá sản phẩm ra khỏi giỏ hàng?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
                let item = self.data[indexPath.item]
                if  self.dataChecked.contains(where: {$0.data?.malsp == item.data?.malsp }){
                    self.sum = self.sum -  (item.data?.giagiam)!
                    self.money.text = "\(CurrencyVN.toVND(self.sum))"
                    self.dataChecked = self.dataChecked.filter {$0.data?.malsp  != item.data?.malsp }
                }
                self.data.remove(at: indexPath.row)
                UserService.shared.removeOrder2(with: item.data)
                self.tableView.deleteRows(at: [indexPath2], with: .automatic)
            }))
            
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
    @objc func tapOnPlus(tapGesture:UITapGestureRecognizer){
        print("Plus")
        let indexPath2 = IndexPath(row: tapGesture.view!.tag, section: 0)
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath as IndexPath) as? ItemCartTableViewCell else { return }
        var tempQuantity = 0
        let item = data[indexPath2.item]
        tempQuantity = Int(cell.quantity.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) + 1
        if tempQuantity <= (item.data?.soluong)! {
            UserService.shared.putOrder2(order: item, k: 1)
            cell.quantity.text = "\(tempQuantity)"
            if (cell.isChecked){
                self.sum = self.sum + (item.data?.giagiam)!
                self.money.text = "\(CurrencyVN.toVND(self.sum))"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCartTableViewCell else { return }
        let quantity = Int(cell.quantity.text ?? "0") ?? 0
        if (!cell.isChecked){
            cell.isChecked=true
            self.sum = self.sum + ((item.data?.giagiam)! * quantity)
            self.money.text = "\(CurrencyVN.toVND(self.sum))"
            self.dataChecked.append(item)
            cell.checkBox.image = UIImage(named: "check")
        }else {
            cell.isChecked=false
            self.sum = self.sum - ((item.data?.giagiam)!  * quantity)
            self.money.text = "\(CurrencyVN.toVND(self.sum))"
            self.dataChecked = self.dataChecked.filter { $0.data?.malsp != item.data?.malsp }
            cell.checkBox.image = UIImage(named: "uncheck")
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemCartTableViewCell else { return nil}
        let delete = UIContextualAction(style: .normal, title: "Xoá") { (action, view, completionHandler) in
            print("Delete: \(indexPath.row + 1)")
            let quantity = Int(cell.quantity.text ?? "0") ?? 0
            let item = self.data[indexPath.item]
            if  self.dataChecked.contains(where: {$0.data?.malsp == item.data?.malsp }){
                self.sum = self.sum - ((item.data?.giagiam)! * quantity)
                self.money.text = "\(CurrencyVN.toVND(self.sum))"
                self.dataChecked = self.dataChecked.filter { $0.data?.malsp != item.data?.malsp }
            }
            
            self.data.remove(at: indexPath.row)
            UserService.shared.removeOrder2(with: item.data)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
}
