//
//  SanPhamViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit
import NVActivityIndicatorView

class SanPhamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    
    var dataSP : [SanPham] = []
    
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
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        loadDataSP()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataSP(){
        APIService.getSanPham(with: .getSP, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataSP = base.data ?? []
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


extension SanPhamViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSP.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = dataSP[indexPath.item]
        if  let lsp = item.malsp,
            let serial = item.serial
            
        {
            cell.serial.text = serial
            cell.tenLSP.text = lsp
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSP[indexPath.item]
        let  vc = DetailProductViewController()
        vc.product = item
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
