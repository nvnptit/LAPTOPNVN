//
//  DetailHistoryViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 21/08/2022.
//

import UIKit
import NVActivityIndicatorView
import JXReviewController

class DetailHistoryViewController: UIViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var shipper: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var dataHistory: [HistoryOrder1Detail] = []
    var id: Int?
    var order: HistoryOrder1?
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    var currentSerial: String?
    var comment: String?
    
    override func viewDidAppear(_ animated: Bool = false) {
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chi tiết giỏ hàng"
        
        if  self.order?.tentrangthai == "Chờ duyệt"{
            btnCancel.isHidden = false
        }else {  btnCancel.isHidden = true}
        if let nameShipper = order?.nvgiao, let sdtnvg = order?.sdtnvg {
            self.shipper.text = "Nhân viên giao hàng\n\(nameShipper) - \(sdtnvg)☎"
        } else {
            self.shipper.isHidden = true
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        shipper.isUserInteractionEnabled = true
        shipper.addGestureRecognizer(tap)
        
        setupAnimation()
        loadData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrderDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailTableViewCell")
    }
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        if let sdt = order?.sdtnvg{
            callNumber(phoneNumber: sdt)
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


extension DetailHistoryViewController: UITableViewDataSource, UITableViewDelegate , UIGestureRecognizerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
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
            //            cell.picture.loadFrom(URLAddress: APIService.baseUrl + anhlsp)
            cell.picture.getImage(url: APIService.baseUrl + anhlsp, completion: { img in
                DispatchQueue.main.sync {
                    cell.picture.image = img
                }
            })
            cell.gia.text =  "\(CurrencyVN.toVND(giaban))"
        }
        cell.selectionStyle = .none
        if (UserService.shared.maNV.isEmpty){
            cell.viewRate.isHidden = false
        }
        let gestureRate : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapRate(tapGesture:)))
        gestureRate.delegate = self
        gestureRate.numberOfTapsRequired = 1
        cell.viewRate.isUserInteractionEnabled = true
        cell.viewRate.tag = indexPath.row
        cell.viewRate.addGestureRecognizer(gestureRate)
        
        if let stt = order?.tentrangthai{
            if (stt == "Đã giao hàng"){
                cell.viewRate.isHidden = false
            }else {
                cell.viewRate.isHidden = true
            }
            
        }
        return cell
    }
    
    @objc func tapRate(tapGesture:UITapGestureRecognizer){
        print("Rate")
        let indexPath = IndexPath(row: tapGesture.view!.tag, section: 0)
        let item = dataHistory[indexPath.item]
        self.currentSerial = item.serial
        getComment(seri: self.currentSerial!)
    }
    func getComment(seri: String){
        APIService.getRateBySerial(with: seri, {
            data, error in
            guard let data = data, let message = data.message else {
                return
            }
            if data.success == true {
                self.comment = message
            }else {
                self.comment = ""
            }
            self.requestReview()
        })
    }
    func requestReview() {
        if (comment != ""){
            let alert = UIAlertController(title:"\(self.comment!)\n\nBạn có muốn đánh giá lại?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Có", style: .default, handler:{ _ in
                let reviewController = JXReviewController()
                reviewController.image = UIImage(systemName: "heart.fill")
                reviewController.title = "Bạn có hài lòng với chất lượng sản phẩm"
                //        reviewController.message = "Đánh giá"
                reviewController.delegate = self
                self.present(reviewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
        }else{
            let reviewController = JXReviewController()
            reviewController.image = UIImage(systemName: "heart.fill")
            reviewController.title = "Bạn có hài lòng với chất lượng sản phẩm"
            //        reviewController.message = "Đánh giá"
            reviewController.delegate = self
            present(reviewController, animated: true)
        }
    }
    
    @IBAction func tapCancel(_ sender: UIButton, forEvent event: UIEvent) {
        guard let order = self.order else {return}
        let alert = UIAlertController(title: "Bạn có chắc huỷ đơn hàng này?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
            self.dismiss(animated: true)
            let params = GioHangEdit(idgiohang: order.idgiohang, ngaylapgiohang: order.ngaylapgiohang,ngaydukien: order.ngaydukien, tonggiatri: order.tonggiatri, matrangthai: 3, manvgiao: nil, manvduyet: nil, nguoinhan: order.nguoinhan, diachi: order.diachi, sdt: order.sdt, email: order.email).convertToDictionary()
            self.updateGH(params: params)
        }))
        self.present(alert, animated: true)
    }
}

extension DetailHistoryViewController{
    func updateGH(params: [String : Any]?){
        APIService.updateGioHang(with: .updateGioHangAdmin, params: params, headers: nil, completion: { base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Huỷ đơn hàng thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
            else {
                fatalError()
            }
        })
    }
}
extension DetailHistoryViewController: JXReviewControllerDelegate {
    
    func reviewController(_ reviewController: JXReviewController, didSelectWith point: Int) {
        print("Did select with \(point) point(s).")
    }
    
    func reviewController(_ reviewController: JXReviewController, didCancelWith point: Int) {
        print("Did cancel with \(point) point(s).")
    }
    
    func reviewController(_ reviewController: JXReviewController, didSubmitWith point: Int) {
        print("Did submit with \(point) point(s).")
        let alert = UIAlertController(title: "Bình luận sản phẩm", message: nil, preferredStyle: .alert)
        alert.addTextField{ text in
            text.placeholder = "Nhập nội dung tại đây"
            text.keyboardType = .default
        }
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler:{ _ in
            self.dismiss(animated: true)
            guard let value = alert.textFields, value.count > 0 else { return }
            let message = value[0].text!
            //point
            // cach su ly khi ma da danh gia roi nhu the nao, viet api
            let params = RateModel(cmnd: UserService.shared.cmnd, serial: self.currentSerial, ngaybinhluan: nil, diem: point, mota: message).convertToDictionary()
            if (self.comment == ""){
                print("POST")
                APIService.postRequest(with: .postRate, params: params, headers: nil, completion: {
                    base, error in
                    guard let base = base else {return}
                    let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                })
            }else {
                print("PUT")
                APIService.postRequest(with: .putRate, params: params, headers: nil, completion: {
                    base, error in
                    guard let base = base else {return}
                    let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ //[unowned alert]
                        _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                })
            }
        }))
        self.present(alert, animated: true)
    }
}

