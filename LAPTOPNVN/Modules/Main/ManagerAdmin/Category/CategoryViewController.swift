//
//  CategoryViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit
import NVActivityIndicatorView

class CategoryViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    
    var dataLSP : [LoaiSanPhamKM] = []
    
    var isAdded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isAdded){
            btnBack.isHidden = false
        }else {
            btnBack.isHidden = true
        }
        setupAnimation()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        loadDataLSP()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataLSP(){
        APIService.getLoaiSanPhamFull(with: .getLoaiSanPhamFull, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataLSP = base.data ?? []
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.loading.stopAnimating()
            }
        })
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

    @IBAction func tapThemMoi(_ sender: UIButton, forEvent event: UIEvent) {
        
        //        let vc = DetailEmployeeViewController()
        //        var data: [String] = []
        //        if let listQuyen = UserService.shared.getListQuyen(){
        //            for i in listQuyen{
        //                data.append(i.tenquyen ?? "")
        //                //                if (i.maquyen == UserService.shared.)
        //            }
        //        }
        //        vc.statusValues = data
        //        vc.isNew  = true
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapBack(_ sender: UIButton, forEvent event: UIEvent) {
                let vc = HomeAdminViewController()
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLSP.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let item = dataLSP[indexPath.item]
        if  let name = item.tenlsp,
            let cpu = item.cpu,
            let ram = item.ram,
            let card = item.cardscreen,
            let harddisk = item.harddrive,
            let os = item.os,
            let img = item.anhlsp
            
        {
            cell.name.text = name
            cell.cpu.text = cpu
            cell.ram.text = ram
            cell.card.text = card
            cell.disk.text = harddisk
            cell.os.text = os
            cell.imagePicture.loadFrom(URLAddress: APIService.baseUrl + img)
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataLSP[indexPath.item]
        let  vc = DetailCategoryViewController()
        vc.category = item
//        var data: [String] = []
//        if let listQuyen = UserService.shared.getListQuyen(){
//            for i in listQuyen{
//                data.append(i.tenquyen ?? "")
//                //                if (i.maquyen == UserService.shared.)
//            }
//        }
//        print(data)
//        detailEmployeeViewController.statusValues = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
