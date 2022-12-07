//
//  StatsViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 02/12/2022.
//

import UIKit
import NVActivityIndicatorView

// MARK: - ImportExportLSP
struct ImportExportLSP: Decodable {
    let success: Bool?
    let data: [DataImportExport]?
}

// MARK: - DataImportExport
struct DataImportExport: Decodable {
    let malsp, tenlsp, anhlsp: String?
    let slnhap, slton, slban: Int?
}

class StatsViewController: UIViewController {
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    var data : [DataImportExport] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thống kê số lượng loại sản phẩm"
        fetchData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "StatLSPTableViewCell", bundle: nil), forCellReuseIdentifier: "StatLSPTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        fetchData()
    }
    
    func fetchData(){
        APIService.fetchDataImportExportLSP(with: .importExportLSP, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.data = base.data ?? []
            }
        })
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.loading.stopAnimating()
        }
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
    
}
extension StatsViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatLSPTableViewCell", for: indexPath) as! StatLSPTableViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let item = data[indexPath.section]
        if let name = item.tenlsp,
           let sln = item.slnhap,
           let slb = item.slban,
           let slt = item.slton,
           let img = item.anhlsp{
            cell.name.text = name
            cell.sln.text = "\(sln)"
            cell.slb.text = "\(slb)"
            cell.slt.text = "\(slt)"
            cell.img.getImage(url: APIService.baseUrl + img, completion: { img in
                DispatchQueue.main.sync {
                    cell.img.image = img
                }
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    
}
