//
//  StatisticViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 06/08/2022.
//

import UIKit
import NVActivityIndicatorView

class StatisticViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfFrom: UITextField!
    @IBOutlet weak var tfTo: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var data: [String] = []
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HistoryOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryOrderTableViewCell")
    }

    
    override func viewDidAppear(_ animated: Bool = false) {
        loadDataHistory()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func loadDataHistory(){
        loading.startAnimating()
        let from = tfFrom.text == "" ? nil : Date().convertDateViewToSQL(tfFrom.text!)
        let to = self.tfTo.text == "" ? nil : Date().convertDateViewToSQL(tfTo.text!)
        
        
        let params = HistoryModel(status: 1, cmnd: nil, dateFrom: from, dateTo: to).convertToDictionary()
        print(params)
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            APIService.getHistoryOrder(with: .getHistoryOrder, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
//                        self.dataHistory = data
                    }
                } else {
                    print(base.success)
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


extension StatisticViewController{
    //MARK: - Setup keyboard, user
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
                var contentInset:UIEdgeInsets = self.scrollView.contentInset
                contentInset.bottom = keyboardFrame.size.height + 70
                scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
}

// History

extension StatisticViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrderTableViewCell", for: indexPath) as! HistoryOrderTableViewCell
        let item = data[indexPath.item]
        if let ngaylapgiohang = item.
//           //            let tonggiatri = item.tonggiatri,
//           let tentrangthai = item.tentrangthai,
//           //            let nvgiao = item.nvgiao,
//           //            let nvduyet = item.nvduyet,
//            let nguoinhan = item.nguoinhan,
//           let diachi = item.diachi,
//           let sdt = item.sdt,
//           let datePlan = item.ngaydukien,
//           let idGH = item.idgiohang
        
        //            let serial = item.serial,
        //            let tenlsp = item.tenlsp,
        //            let anhlsp = item.anhlsp,
        //            let mota = item.mota,
        //            let cpu = item.cpu,
        //            let ram = item.ram,
        //            let harddrive = item.harddrive,
        //            let cardscreen = item.cardscreen,
        //            let os = item.os
        {
            cell.date.text = Date().convertDateTimeSQLToView(date: ngaylapgiohang, format: "dd-MM-yyyy HH:mm:ss")
            cell.status.text = tentrangthai
            cell.status.textColor = .orange
            cell.receiver.text = nguoinhan
            cell.address.text = diachi
            cell.phone.text = sdt
            cell.datePlan.text = Date().convertDateSQLToView(String(datePlan.prefix(10)))
            cell.idGH.text = "\(idGH)"
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = dataHistory[indexPath.item]
//        let detailStatisticViewController = DetailStatisticViewController()
//        detailStatisticViewController.order = item
//        self.navigationController?.pushViewController(detailStatisticViewController, animated: true)
    }
}



