//
//  SaleDetailViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 01/10/2022.
//

import UIKit

class SaleDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var id: UITextField!
    
    @IBOutlet weak var dateStart: UITextField!
    
    @IBOutlet weak var dateEnd: UITextField!
    
    @IBOutlet weak var describe: UITextField!
    
    @IBOutlet weak var btnSaleEvent: UIButton!
    
    @IBOutlet weak var btnSaleDetail: UIButton!
    
    
    var isNew = false
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var data: Sale?
    var dataDetail : [ResponseDetailSale] = []
    var dataLSP : [LoaiSanPhamKM] = []
    override func viewDidAppear(_ animated: Bool) {
        
        if (!isNew) {
            getDetail(maDot: (data?.madotgg)!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!isNew) {
            getDetail(maDot: (data?.madotgg)!)
            getListLSP()
            loadData()
            
            dateStart.backgroundColor = .lightGray
            dateEnd.backgroundColor = .lightGray
            dateStart.isEnabled = false
            dateEnd.isEnabled = false
            btnSaleDetail.isHidden = false
            
            btnSaleEvent.setTitle("LƯU THAY ĐỔI", for: .normal)
        }else {
            btnSaleEvent.setTitle("THÊM MỚI", for: .normal)
            btnSaleDetail.isHidden = true
            getMaDGG()
        }
        
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
    }
    func loadData(){
        guard let id = data?.madotgg,
              let dateS = data?.ngaybatdau,
              let dateE = data?.ngayketthuc,
              let des = data?.mota
        else {return}
        self.id.text = id
        dateStart.text = Date().convertDateTimeSQLToView(date: dateS, format: "dd-MM-yyyy")
        dateEnd.text = Date().convertDateTimeSQLToView(date: dateE, format: "dd-MM-yyyy")
        describe.text = des
    }
    func checkFill()-> Bool{
        guard let dateS = dateStart.text,
              let dateE = dateEnd.text,
              let des = describe.text
        else { return false  }
        if (dateS.isEmpty || dateE.isEmpty || des.isEmpty){
                let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
                return false
        }
        return true
    }
    @IBAction func tapSaleEvent(_ sender: UIButton, forEvent event: UIEvent) {
        if checkFill(){
            if (btnSaleEvent.currentTitle == "THÊM MỚI"){
                
                guard let dateStart = dateStart.text, let dateEnd = dateEnd.text else {return}
                
                let currentDate = Date()
                let current = "\(currentDate)".prefix(10)
                if (!Date().checkDatePlan(start: dateStart, end: Date().convertDateSQLToView(String(current))) ){
                    let alert = UIAlertController(title: "Ngày bắt đầu cần lớn hơn ngày hiện tại", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                    return
                }
                
                let params = SaleModel(madotgg: id.text, ngaybatdau: Date().convertDateViewToSQL(dateStart), ngayketthuc: Date().convertDateViewToSQL(dateEnd), mota: describe.text, manv: UserService.shared.maNV).convertToDictionary()
                APIService.postRequest(with: .postDotGG, params: params, headers: nil, completion: {base, error in
                    guard let base = base else { return }
                    let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                })
            }else {
                    guard let dateStart = dateStart.text, let dateEnd = dateEnd.text else {return}
                    let params = SaleModel(madotgg: id.text, ngaybatdau: Date().convertDateViewToSQL(dateStart), ngayketthuc: Date().convertDateViewToSQL(dateEnd), mota: describe.text, manv: UserService.shared.maNV).convertToDictionary()
                
                    APIService.postRequest(with: .putDotGG, params: params, headers: nil, completion: {base, error in
                        guard let base = base else { return }
                        let alert = UIAlertController(title:base.message!, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                                    self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true)
                    })
            }
        }
    }
    
    
    @IBAction func tapSaleDetail(_ sender: UIButton, forEvent event: UIEvent) {
        //DetailSaleViewController
        let  vc = DetailSaleViewController()
        vc.id = id.text
        vc.dataDetail = dataDetail
        vc.dataLSP = dataLSP
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SaleDetailViewController{
    
    private func getMaDGG(){
        APIService.getMaSo(with: .getMaSoDGG, params: nil, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let maSo = base.data?[0].maso
                self.id.text = "DGG" + String(describing: maSo! + 1)
            } else {
                let alert = UIAlertController(title:"Đã có lỗi lấy mã", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
}

extension SaleDetailViewController{
    //MARK: - Datepicker
    
    private func createToolbar(_ datePickerView: UIDatePicker) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapOnView))
        switch (datePickerView){
            case datePicker1:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker1))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            case datePicker2:
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donedatePicker2))
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton,flexButton,doneButton], animated: true)
            default: break
                
        }
        
        return toolbar
    }
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker1.preferredDatePickerStyle = .wheels
        datePicker2.preferredDatePickerStyle = .wheels
        
        if #available(iOS 14, *) {
            datePicker1.preferredDatePickerStyle = .inline
            datePicker2.preferredDatePickerStyle = .inline
        }
        
        datePicker1.datePickerMode = .date
        dateStart.inputView = datePicker1
        dateStart.inputAccessoryView = createToolbar(datePicker1)
        
        datePicker2.datePickerMode = .date
        dateEnd.inputView = datePicker2
        dateEnd.inputAccessoryView = createToolbar(datePicker2)
    }
    
    @objc func donedatePicker1() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateStart.text =  dateFormatter.string(from: datePicker1.date)
        view.endEditing(true)
    }
    @objc func donedatePicker2() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateEnd.text =  dateFormatter.string(from: datePicker2.date)
        view.endEditing(true)
    }
}

extension SaleDetailViewController{
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

extension SaleDetailViewController{
    func getDetail(maDot: String){
        APIService.getCTGG(with: maDot, { base, error in
            guard let base = base else {
                return
            }
            if (base.success == true ){
                if let dataz = base.data {
                    self.dataDetail = dataz
                }
            }
        })
    }
    
    func getListLSP(){
        APIService.getLoaiSanPhamFull(with: .getLoaiSanPhamFull, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataLSP = base.data ?? []
            }
        })
    }
}
