//
//  EmployeeViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 13/08/2022.
//

import UIKit
import NVActivityIndicatorView


class EmployeeViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataNV : [ModelNVResponseAD] = []
    
    var dataQuyen : [QuyenResponse] = []
    
    func loadDataQuyen(){
        DispatchQueue.init(label: "QuyenVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            APIService.getQuyen(with: .getQuyen, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.dataQuyen = (base.data ?? [])
                }
//                else {
//                    let alert = UIAlertController(title:"Đã có lỗi xảy ra", message: "", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
//                        self.dismiss(animated: true)
//                    }))
//                    self.present(alert, animated: true)
//                }
            })
        }
        
    }
    
    var isAdded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataQuyen()
        if (isAdded){
            btnBack.isHidden = false
        }else {
            btnBack.isHidden = true
        }
        setupAnimation()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
    }
    
    @IBAction func tapBack(_ sender: UIButton, forEvent event: UIEvent) {
        let vc = HomeAdminViewController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool = false) {
        //        self.navigationController?.isNavigationBarHidden = true
        loadDataNV()
        loadDataQuyen()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataNV(){
        APIService.getNhanVien(with: .getNV, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataNV = base.data ?? []
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
        
        let vc = DetailEmployeeViewController()
        var data: [String] = []
            for i in dataQuyen{
                data.append(i.tenquyen ?? "")
            }
        vc.statusValues = data
        vc.isNew  = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
extension EmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataNV.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let item = dataNV[indexPath.item]
        if  let manv = item.manv,
            let email = item.email,
            let ten = item.ten,
            let ngaysinh = item.ngaysinh,
            let sdt = item.sdt,
            let tendangnhap = item.tendangnhap
        {
            cell.maNV.text = manv
            cell.email.text = email
            cell.ten.text = ten
            cell.ngaySinh.text = Date().convertDateTimeSQLToView(date: ngaysinh, format:"dd-MM-yyyy")
            cell.sdt.text = sdt
            cell.tenDangNhap.text = tendangnhap
            //            cell.datePlan.text = Date().convertDateSQLToView(String(datePlan.prefix(10)))
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataNV[indexPath.item]
        let detailEmployeeViewController = DetailEmployeeViewController()
        detailEmployeeViewController.employee = item
        var data: [String] = []
            for i in dataQuyen{
                data.append(i.tenquyen ?? "")
            }
        print(data)
        detailEmployeeViewController.statusValues = data
        self.navigationController?.pushViewController(detailEmployeeViewController, animated: true)
    }
}



