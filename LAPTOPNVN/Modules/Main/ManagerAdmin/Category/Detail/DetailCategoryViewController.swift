//
//  DetailCategoryViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit
import DropDown

class DetailCategoryViewController: UIViewController {
    
    
    @IBOutlet weak var sw1: UISwitch!
    
    @IBOutlet weak var sw2: UISwitch!
    @IBOutlet weak var tfMaLSP: UITextField!
    @IBOutlet weak var lbMaLSP: UILabel!
    
    var category: LoaiSanPhamKM?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnChange: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var camera: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var viewPicture: UIView!
    @IBOutlet weak var imagePicture: UIImageView!
    
    @IBOutlet weak var cpu: UITextField!
    
    @IBOutlet weak var ram: UITextField!
    
    @IBOutlet weak var card: UITextField!
    
    @IBOutlet weak var disk: UITextField!
    
    @IBOutlet weak var os: UITextField!
    
    @IBOutlet weak var mota: UITextView!
    
    @IBOutlet weak var gia: UITextField!
    
    let imagePickerController = UIImagePickerController()
    var image = UIImage()
    var picture: String = ""
    var isUploadPicture: Bool = false
    var isNew: Bool = false
    
    @IBOutlet weak var soLuong: UITextField!
    @IBOutlet weak var dropDownHangSX: UIView!
    @IBOutlet weak var hangSX: UILabel!
    var hangDrop = DropDown()
    var dataHang : [HangSX] = []
    var hangValues: [String] = []
    
    var maHang: Int?
    var maLSP: Int?
    
    var maNV: String = UserService.shared.maNV
    var giaCu:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUploadAvatar()
        setupKeyboard()
        self.giaCu = category?.giamoi!
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        mota.layer.borderWidth = 1
        mota.layer.borderColor = UIColor.lightGray.cgColor
        
        self.offFill()
        
        if (!isNew){
            print(hangValues)
            loadData()
            self.maHang = category?.mahang
        }else {
            self.onFill()
            btnChange.setTitle("THÊM MỚI", for: .normal)
            btnDelete.isHidden = true
            getMaLSP()
        }
        setupDropDown()
        setupStatus()
    }
    
    @IBAction func tapNew(_ sender: UISwitch, forEvent event: UIEvent) {
    }
    
    @IBAction func tapPrice(_ sender: UISwitch, forEvent event: UIEvent) {
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func offFill(){
        self.tfMaLSP.isEnabled = false
        self.name.isEnabled = false
        self.cpu.isEnabled = false
        self.ram.isEnabled = false
        self.card.isEnabled = false
        self.disk.isEnabled = false
        self.os.isEnabled = false
        self.mota.isEditable = false
        camera.isUserInteractionEnabled = false
        self.dropDownHangSX.isUserInteractionEnabled = false
        self.sw1.isEnabled = false
        self.sw2.isEnabled = false
        self.gia.isEnabled = false
        self.soLuong.isEnabled = false
        
        self.tfMaLSP.backgroundColor = .lightGray
        self.name.backgroundColor = .lightGray
        self.cpu.backgroundColor = .lightGray
        self.ram.backgroundColor = .lightGray
        self.card.backgroundColor = .lightGray
        self.disk.backgroundColor = .lightGray
        self.os.backgroundColor = .lightGray
        self.mota.backgroundColor = .lightGray
        self.dropDownHangSX.backgroundColor = .lightGray
        self.gia.backgroundColor = .lightGray
        self.soLuong.backgroundColor = .lightGray
    }
    func onFill(){
        self.name.isEnabled = true
        self.cpu.isEnabled = true
        self.ram.isEnabled = true
        self.card.isEnabled = true
        self.disk.isEnabled = true
        self.os.isEnabled = true
        self.mota.isEditable = true
        camera.isUserInteractionEnabled = true
        self.dropDownHangSX.isUserInteractionEnabled = true
        self.gia.isEnabled = true
        self.soLuong.isEnabled = true
        
        self.sw1.isEnabled = true
        self.sw2.isEnabled = true
        
        self.name.backgroundColor = .none
        self.cpu.backgroundColor = .none
        self.ram.backgroundColor = .none
        self.card.backgroundColor = .none
        self.disk.backgroundColor = .none
        self.os.backgroundColor = .none
        self.mota.backgroundColor = .none
        self.dropDownHangSX.backgroundColor = .none
        self.gia.backgroundColor = .none
        self.soLuong.backgroundColor = .none
    }
    func loadData(){
        if let category = category {
            tfMaLSP.text = category.malsp
            imagePicture.loadFrom(URLAddress: APIService.baseUrl + category.anhlsp!)
            name.text = category.tenlsp
            cpu.text = category.cpu
            ram.text = category.ram
            card.text = category.cardscreen
            disk.text = category.harddrive
            os.text = category.os
            mota.text = category.mota
            hangSX.text = dataHang.filter({$0.mahang == category.mahang})[0].tenhang
            sw1.isOn = category.isnew!
            sw2.isOn = category.isgood!
            gia.text = "\(category.giamoi!)"
            soLuong.text = "\(category.soluong!)"
            sw1.isOn = category.isnew!
            sw2.isOn = category.isgood!
        }
    }
    @IBAction func tapChange(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnChange.currentTitle == "THÊM MỚI"){
            if (checkInfo()){
                let maLSP = tfMaLSP.text
                let name = name.text
                let cpu = cpu.text
                let ram = ram.text
                let card = card.text
                let disk = disk.text
                let os = os.text
                let mota = mota.text
                let gia = Int(gia.text!)
                
                if (isUploadPicture){
                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { [self] base, error in
                        if let base = base {
                            if base.success == true{
                                if let url = base.message{
                                    self.picture = url
                                }
                                let params = LoaiSanPham(malsp: maLSP, tenlsp: name, soluong: Int(soLuong.text!), anhlsp: self.picture, mota: mota, cpu: cpu, ram: ram, harddrive: disk, cardscreen: card, os: os, mahang: self.maHang, isnew: sw1.isOn, isgood: sw2.isOn, giamoi: gia, manv: self.maNV).convertToDictionary()
                                print(params)
                                self.addLSP(params: params)
                            }
                        }
                    }
                }else {
                    let params = LoaiSanPham(malsp: maLSP, tenlsp: name, soluong: Int(soLuong.text!), anhlsp: "/images/noimage.jpg", mota: mota, cpu: cpu, ram: ram, harddrive: disk, cardscreen: card, os: os, mahang: self.maHang, isnew: sw1.isOn, isgood: sw2.isOn, giamoi: gia, manv: self.maNV).convertToDictionary()
                    print(params)
                    self.addLSP(params: params)
                    //
                }
            }
        } else
        if (btnChange.currentTitle == "CẬP NHẬT THÔNG TIN"){
            self.onFill()
            btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
            if (checkInfo()){
                let maLSP = tfMaLSP.text
                let name = name.text
                let cpu = cpu.text
                let ram = ram.text
                let card = card.text
                let disk = disk.text
                let os = os.text
                let mota = mota.text
                var gia = Int(gia.text!)
                
                if (self.giaCu == gia){
                    gia = -1
                }else {
                    self.giaCu = gia
                }
                
                if (isUploadPicture){
                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { [self] base, error in
                        if let base = base {
                            if base.success == true{
                                if let url = base.message{
                                    self.picture = url
                                }
                                let params = LoaiSanPham(malsp: maLSP, tenlsp: name, soluong: Int(soLuong.text!), anhlsp: self.picture, mota: mota, cpu: cpu, ram: ram, harddrive: disk, cardscreen: card, os: os, mahang: self.maHang, isnew: sw1.isOn, isgood: sw2.isOn, giamoi: gia, manv: self.maNV).convertToDictionary()
                                print(params)
                                self.updateLSP(params: params)
                            }
                        }
                    }
                }else {
                    let params = LoaiSanPham(malsp: maLSP, tenlsp: name, soluong: Int(soLuong.text!), anhlsp: category?.anhlsp!, mota: mota, cpu: cpu, ram: ram, harddrive: disk, cardscreen: card, os: os, mahang: self.maHang, isnew: sw1.isOn, isgood: sw2.isOn, giamoi: gia, manv: self.maNV).convertToDictionary()
                    print(params)
                    self.updateLSP(params: params)
                    //
                }
            }
        }
    }
    
    @IBAction func tapDelete(_ sender: UIButton, forEvent event: UIEvent) {
        print("Delete")
        
        let alert = UIAlertController(title: "Bạn có chắc xoá loại sản phẩm này?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler:{ _ in
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler:{ _ in
            self.dismiss(animated: true)
            let params = DeleteLSP(maLSP: self.category?.malsp!).convertToDictionary()
            print(params)
            self.delLSP(params: params)
        }))
        self.present(alert, animated: true)
        
        
    }
}

extension DetailCategoryViewController{
    
    // BEGIN Hãng
    
    private func setupStatus() {
        hangDrop.anchorView = dropDownHangSX
        hangDrop.dataSource = hangValues
        hangDrop.bottomOffset = CGPoint(x: 0, y:(hangDrop.anchorView?.plainView.bounds.height)! + 5)
        hangDrop.direction = .bottom
        hangDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.hangSX.text = item
            self.maHang = dataHang.filter( {$0.tenhang == item})[0].mahang
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapStatus))
        dropDownHangSX.addGestureRecognizer(gestureClock)
        dropDownHangSX.layer.borderWidth = 1
        dropDownHangSX.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapStatus() {
        hangDrop.show()
    }
    
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    // END Hãng
}

extension DetailCategoryViewController{
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

extension DetailCategoryViewController{
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    func chuanHoaTF(){
        name.text = chuanHoa( name.text)
        cpu.text = chuanHoa( cpu.text)
        ram.text = chuanHoa( ram.text)
        card.text = chuanHoa( card.text)
        disk.text = chuanHoa( disk.text)
        os.text = chuanHoa( os.text)
        mota.text = chuanHoa( mota.text)
        gia.text = chuanHoa( gia.text)
        soLuong.text = chuanHoa( soLuong.text)
    }
    func checkInfo() -> Bool{
        chuanHoaTF()
        guard
            let name = name.text,
            let cpu = cpu.text,
            let ram = ram.text,
            let card = card.text,
            let disk = disk.text,
            let os = os.text,
            let mota = mota.text,
            let hang = hangSX.text,
            let gia = gia.text,
            let soLuong = soLuong.text
        else {
            return false
        }
        
        if (name.isEmpty || cpu.isEmpty || ram.isEmpty || card.isEmpty || disk.isEmpty ||
            os.isEmpty || mota.isEmpty || hang.isEmpty || gia.isEmpty || soLuong.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
}

extension DetailCategoryViewController{
    private func setupUploadAvatar() {
        
        viewPicture.layer.cornerRadius = 12
        viewPicture.layer.masksToBounds = true
        viewPicture.layer.borderColor = UIColor.systemGray.cgColor
        viewPicture.layer.borderWidth = 1
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.videoQuality = .typeMedium
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        gesture.numberOfTapsRequired = 1
        //        viewOfAvatar.addGestureRecognizer(gesture)
        camera.addGestureRecognizer(gesture)
        //        tfPicture.addGestureRecognizer(gesture)
    }
    
    @objc private func tapOnAvatar() {
        let alert = UIAlertController(title: "Tải lên hình ảnh", message: "Chọn 1 mục", preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Chọn từ thư viện", style: .default) { action in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Chụp ảnh mới", style: .default) { action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let actionCencal = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCencal)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image1: UIImage = info[.editedImage] as? UIImage else {return}
        self.image = image1
        imagePickerController.dismiss(animated: true)
        imagePicture.image = image1
        isUploadPicture = true
    }
}

extension DetailCategoryViewController{
    private func getMaLSP(){
        APIService.getMaSo(with: .getMaSoLSP, params: nil, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                self.maLSP = base.data?[0].maso
                self.tfMaLSP.text = "LSP" + String(describing: self.maLSP!+1)
            } else {
                let alert = UIAlertController(title:"Đã có lỗi lấy mã", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
    private func updateLSP(params: [String: Any]?) {
        APIService.postLSP(with: .putLSP, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Cập nhật thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.btnChange.setTitle("CẬP NHẬT THÔNG TIN", for: .normal)
                    self.offFill()
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    private func addLSP(params: [String: Any]?) {
        APIService.postLSP(with: .postLSP, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            print(base)
            if base.success == true {
                let alert = UIAlertController(title: "Thêm mới thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    
                    self.navigationController?.popViewController(animated: true)
//                    let vc = CategoryViewController()
//                    vc.navigationItem.hidesBackButton = true
//                    vc.isAdded = true
//                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: base.message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    private func delLSP(params: [String: Any]?) {
        APIService.postHangSX(with: .delLSP, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    
                    self.navigationController?.popViewController(animated: true)
//                    let vc = CategoryViewController()
//                    vc.navigationItem.hidesBackButton = true
//                    vc.isAdded = true
//                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: base.message!, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
}
