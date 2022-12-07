//
//  DetailSaleViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit
import DropDown
import NVActivityIndicatorView

class DetailSaleViewController: UIViewController {

    @IBOutlet weak var maDot: UITextField!
    @IBOutlet weak var percent: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dataDetail : [ResponseDetailSale] = []
    var dataLSP : [LoaiSanPhamKM] = []
    var id: String?
    
    @IBOutlet weak var dropDownLSP: UIView!
    @IBOutlet weak var lbLSP: UILabel!
    var dropLSP = DropDown()
    var lspValues: [String] = []
    var maLSP = ""
    
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maDot.text = id
        getDataLSP()
        setupDropDown()
        setupAnimation()
        
        // SETUP tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DetailSaleTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailSaleTableViewCell")
    }

    @IBAction func tapAddLSP(_ sender: UIButton, forEvent event: UIEvent) {
        if checkFill(){
            let params = DetailSaleModel(malsp: self.maLSP, madotgg: maDot.text, phantramgg: Int(percent.text!)).convertToDictionary()
            APIService.postRequest(with: .postDetailSale, params: params, headers: nil, completion: {base, error in
                guard let base = base else { return }
                let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                        self.reloadData()
                        self.percent.text = ""
                    }))
                    self.present(alert, animated: true)
            })
        }
    }
    
    func checkFill()-> Bool{
        guard let lsp = lbLSP.text,
              let percent = percent.text
        else { return false  }
        if (lsp.isEmpty || percent.isEmpty ){
                let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return false
        }
        guard let pt = Int(percent) else {return false}
            if (pt < 0 || pt > 100){
                let alert = UIAlertController(title:"Phần trăm giảm giá không hợp lệ!", message: "Phần trăm phải trong khoảng 0 - 100", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                return false
            }
        return true
    }
}
extension DetailSaleViewController{
    //MARK: - LOADING
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
    //MARK: - DROPDOWN
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    private func setupLSP() {
        dropLSP.anchorView = dropDownLSP
        dropLSP.dataSource = lspValues
        dropLSP.bottomOffset = CGPoint(x: 0, y:(dropLSP.anchorView?.plainView.bounds.height)! + 5)
        dropLSP.direction = .bottom
        dropLSP.selectionAction = { [unowned self] (index: Int, item: String) in
            let items = item.components(separatedBy: "|")
            let name = items[0]
            self.lbLSP.text = name
            self.maLSP = items[1]
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapLSP))
        dropDownLSP.addGestureRecognizer(gestureClock)
        dropDownLSP.layer.borderWidth = 1
        dropDownLSP.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapLSP() {
        dropLSP.show()
    }
    
    private func getDataLSP(){
        for item in self.dataLSP{
            self.lspValues.append("\(item.tenlsp!)|\(item.malsp!)")
        }
        self.setupLSP()
    }
    
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
        //        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //        contentInset.bottom = keyboardFrame.size.height + 70
        //        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        //        scrollView.contentInset = contentInset
    }
    //MARK: - End Setup keyboard
    func reloadData(){
        loading.startAnimating()
        guard let ma = self.maDot.text else { return }
        APIService.getCTGG(with: ma, { base, error in
            guard let base = base else {
                return
            }
            if (base.success == true ){
                if let dataz = base.data {
                    self.dataDetail = dataz
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.loading.stopAnimating()
            }
        })
    }
}

extension DetailSaleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailSaleTableViewCell", for: indexPath) as! DetailSaleTableViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        let item = dataDetail[indexPath.item]
        
        if let maLSP = item.malsp,
           let percent = item.phantramgg
        {
            let name = dataLSP.filter { $0.malsp == maLSP}[0].tenlsp
            cell.nameLSP.text = name
            cell.percentLSP.text = "\(percent)%"
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataDetail[indexPath.item]
        let alert = UIAlertController(title: "Bạn có muốn cập nhật phần trăm không?", message: "", preferredStyle: .alert)
        alert.addTextField { text in
            text.placeholder = "Giá trị mới"
            text.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Có", style: .default, handler:{ _ in
            if let t = alert.textFields {
                if (t[0].text == ""){
                        let alert = UIAlertController(title: "Giá trị không được để trống!", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                            self.dismiss(animated: true)
                        }))
                        self.present(alert, animated: true)
                    return
                } else {
                    guard let newVal = Int(t[0].text!) else {return}
                    print("NEWVAL: \(newVal)")
                    if (newVal < 0 || newVal > 100){
                        let alert = UIAlertController(title:"Phần trăm giảm giá không hợp lệ!", message: "Phần trăm phải trong khoảng 0 - 100", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                self.dismiss(animated: true)
                            }))
                            self.present(alert, animated: true)
                        return
                    }
                }
               
            }
                    self.dismiss(animated: true)
                guard let value = alert.textFields, value.count > 0 else {  return }
            let newValue = Int(value[0].text!)
            
            let params = DetailSaleModel(malsp: item.malsp, madotgg: item.madotgg, phantramgg: newValue).convertToDictionary()
            APIService.postRequest(with: .putDetailSale, params: params, headers: nil, completion: {base, error in
                guard let base = base else { return }
                let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                        self.reloadData()
                        self.percent.text = ""
                    }))
                    self.present(alert, animated: true)
            })
        }))
        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = dataDetail[indexPath.item]
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailSaleTableViewCell else { return nil}
        let delete = UIContextualAction(style: .normal, title: "Xoá") { (action, view, completionHandler) in
            print("Delete: \(indexPath.row + 1)")
            
             APIService.delCTGG(with: item.malsp!,maDot: item.madotgg!, { data, error in
                 guard let data = data else {
                     return
                 }
                 if data.success == true {
                     self.dataDetail.remove(at: indexPath.row)
                     self.tableView.deleteRows(at: [indexPath], with: .automatic)
                 }
                 let alert = UIAlertController(title: data.message!, message: "", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                     self.dismiss(animated: true)
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
