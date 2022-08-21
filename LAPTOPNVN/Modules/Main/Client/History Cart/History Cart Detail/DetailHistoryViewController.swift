//
//  DetailHistoryViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 21/08/2022.
//

import UIKit
import NVActivityIndicatorView

class DetailHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataHistory: [HistoryOrder1Detail] = []
    var id: Int?
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    
    override func viewDidAppear(_ animated: Bool = false) {
//        self.navigationController?.isNavigationBarHidden = true
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiết giỏ hàng \(self.id!)"
        setupAnimation()
        loadData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableViewCell")
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
        DispatchQueue.init(label: "DetailHistoryVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let params = ModelDetailHistory(idGioHang: self.id).convertToDictionary()
            
            APIService.getDetailHistoryOrder1(with: .getDetailHistory, params: params, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        self.dataHistory = data
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
    

extension DetailHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell", for: indexPath) as! OrderDetailTableViewCell
        let item = dataHistory[indexPath.item]
        
        if let serial = item.serial,
           let  tensp = item.tenlsp,
           let anhlsp = item.anhlsp,
           let cpu = item.cpu,
           let ram = item.ram,
           let harddrive = item.harddrive,
           let cardscreen = item.cardscreen,
           let os = item.os,
           let giaban = item.giaban{
            cell.tensp.text = tensp
            cell.serial.text = serial
            cell.tensp.text = tensp
            cell.cpu.text = cpu
            cell.ram.text = ram
            cell.disk.text = harddrive
            cell.card.text = cardscreen
            cell.os.text = os
            cell.picture.loadFrom(URLAddress: APIService.baseUrl + anhlsp)
            cell.gia.text =  "\(CurrencyVN.toVND(giaban))"
        }
        cell.selectionStyle = .none
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let item = dataHistory[indexPath.item]
//        guard let cell = tableView.cellForRow(at: indexPath) as? OrderDetailTableViewCell else { return }
//
//    }
    
}
