//
//  DetailSanPhamViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 19/07/2022.
//

import UIKit
import SDWebImage

class DetailSanPhamViewController: UIViewController{
    
    var loaiSp: LoaiSanPhamKM?
    var order: HistoryOrder?
    
    @IBOutlet weak var imageLSP: UIImageView!
    
    @IBOutlet weak var tfCPU: UILabel!
    
    @IBOutlet weak var tfRam: UILabel!
    
    @IBOutlet weak var tfCard: UILabel!
    @IBOutlet weak var tfDisk: UILabel!
    
    @IBOutlet weak var tfOS: UILabel!
    
    @IBOutlet weak var tfDescription: UILabel!
    
    @IBOutlet weak var btnAddCart: UIButton!
    
    @IBOutlet weak var viewStar: JStarRatingView!
    
    var isCancel:Bool = false
    var listComment: [RateListResponse] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !listComment.isEmpty{
            var point = 0
            for comment in listComment {
                point += comment.diem!
            }
            viewStar.rating = Float(point/listComment.capacity)
        }
        
        //CommentTableViewCell
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        DispatchQueue.main.async {
            self.checkSLTon()
        }
        if let loaiSp = loaiSp, let sl = loaiSp.soluong {
            if (sl>0){
                btnAddCart.isEnabled = true
            }else {
                btnAddCart.isEnabled = false
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let loaiSp = loaiSp {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
//                let url =  APIService.baseUrl + anhlsp
//                imageLSP.loadFrom(URLAddress: url)
                
                imageLSP.getImage(url: APIService.baseUrl + anhlsp, completion: { img in
                    DispatchQueue.main.sync {
                        self.imageLSP.image = img
                    }
                })
                

                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.text = loaiSp.mota
                tfDescription.sizeToFit()
                self.title = loaiSp.tenlsp
            }
        }
        if let loaiSp = order {
            // set du lieu vo
            if let anhlsp = loaiSp.anhlsp {
//                let url =  APIService.baseUrl + anhlsp
//                imageLSP.loadFrom(URLAddress: url)
                
                imageLSP.getImage(url: APIService.baseUrl + anhlsp, completion: { img in
                   
                    DispatchQueue.main.sync {
                        self.imageLSP.image = img
                    }
                })
                
                tfCPU.text = loaiSp.cpu
                tfRam.text = loaiSp.ram
                tfCard.text = loaiSp.cardscreen
                tfDisk.text = loaiSp.harddrive
                tfOS.text = loaiSp.os
                tfDescription.text =  loaiSp.mota
                btnAddCart.isHidden = true
                self.title = loaiSp.tenlsp
            }
        }
    }
    
    @IBAction func tapAddCart(_ sender: UIButton) {
        let cmnd = UserService.shared.cmnd
        if (cmnd != ""){
            if let loaiSp = loaiSp {
                UserService.shared.addOrder2(with: loaiSp)
                print(UserService.shared.getlistGH2())
                print("\n")
                
                let alert = UIAlertController(title: title, message: "Thêm vào giỏ hàng thành công", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
        else {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    
    
}
extension DetailSanPhamViewController{
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
extension DetailSanPhamViewController{
    func checkSLTon(){
        let listData = UserService.shared.listGH2
        if (listData.isEmpty) {return}
        let element = listData.filter { $0.data?.malsp == loaiSp?.malsp}
        if (element.isEmpty) {return}
        
        let key = element[0].data?.malsp
        let value = element[0].sl
        
        APIService.getSLLSP(with: key!, { data, error in
            guard let data = data else {
                return
            }
            if (data.success == true ){
                if let data = data.message {
                    print("VALUE: \(value)| DATA: \(data)")
                    if (value == data){
                        self.btnAddCart.isEnabled = false
                    }
                }
            }
            
        })
        
        
    }
}
extension DetailSanPhamViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listComment[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.name.text = item.ten!
        cell.star.text = "đã đánh giá \(item.diem ?? 0) ⭐ "
        cell.comment.text = "Nội dung: \(item.mota ?? "") \n\(item.ngaybinhluan!)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do something
    }
}
