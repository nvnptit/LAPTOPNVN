//
//  SaleViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit
import NVActivityIndicatorView

class SaleViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    var data : [Sale] = []
    var dataDetail : [ResponseDetailSale] = []
    
    @IBAction func tapAddSale(_ sender: UIButton, forEvent event: UIEvent) {
        let  vc = SaleDetailViewController()
        vc.isNew  = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData(){
        DispatchQueue.main.async {
            APIService.getDotGG(with: .getDotGG, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.data = (base.data ?? [])
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                    self.loading.stopAnimating()
                }
            })
        }
    }
    
    var isAdded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        setupAnimation()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SaleTableViewCell", bundle: nil), forCellReuseIdentifier: "SaleTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
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
}

extension SaleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaleTableViewCell", for: indexPath) as! SaleTableViewCell
        let item = data[indexPath.item]
        if  let maDotGG = item.madotgg,
            let dateStart = item.ngaybatdau,
            let dateEnd = item.ngayketthuc,
            let describe = item.mota,
            let maNV = item.manv
        {
            cell.maDotGG.text = maDotGG
            cell.dateStart.text = Date().convertDateTimeSQLToView(date: dateStart, format: "dd-MM-yyyy HH:mm:ss")
            cell.dateEnd.text = Date().convertDateTimeSQLToView(date: dateEnd, format: "dd-MM-yyyy HH:mm:ss")
            cell.describe.text = describe
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        let  vc = SaleDetailViewController()
        vc.data = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = data[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? SaleTableViewCell else { return nil}
        let delete = UIContextualAction(style: .normal, title: "Xoá") { (action, view, completionHandler) in
            print("Delete: \(indexPath.row + 1)")
            
            let params = SaleDel(madotgg: item.madotgg).convertToDictionary()
            APIService.postHangSX(with: .delDotGG, params: params, headers: nil, completion: {
                base, error in
                guard let base = base else { return }
                if base.success == true {
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                //    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            })
            
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
}
