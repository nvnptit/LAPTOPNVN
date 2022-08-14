//
//  DetailCategoryViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 14/08/2022.
//

import UIKit

class DetailCategoryViewController: UIViewController {

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
    
    
    let imagePickerController = UIImagePickerController()
    var image = UIImage()
    var picture: String = ""
    var isUploadPicture: Bool = false
    var isNew: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUploadAvatar()
        
        self.offFill()
        setupKeyboard()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        mota.layer.borderWidth = 1
        mota.layer.borderColor = UIColor.lightGray.cgColor
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool = false) {
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func offFill(){
        self.name.isEnabled = false
        self.cpu.isEnabled = false
        self.ram.isEnabled = false
        self.card.isEnabled = false
        self.disk.isEnabled = false
        self.os.isEnabled = false
        self.mota.isEditable = false
        camera.isUserInteractionEnabled = false
        
        self.name.backgroundColor = .lightGray
        self.cpu.backgroundColor = .lightGray
        self.ram.backgroundColor = .lightGray
        self.card.backgroundColor = .lightGray
        self.disk.backgroundColor = .lightGray
        self.os.backgroundColor = .lightGray
        self.mota.backgroundColor = .lightGray
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
        
        self.name.backgroundColor = .none
        self.cpu.backgroundColor = .none
        self.ram.backgroundColor = .none
        self.card.backgroundColor = .none
        self.disk.backgroundColor = .none
        self.os.backgroundColor = .none
        self.mota.backgroundColor = .none
    }
    func loadData(){
        if let category = category {
            imagePicture.loadFrom(URLAddress: APIService.baseUrl + category.anhlsp!)
            name.text = category.tenlsp
            cpu.text = category.cpu
            ram.text = category.ram
            card.text = category.cardscreen
            disk.text = category.harddrive
            os.text = category.os
            mota.text = category.mota
        }
    }
    @IBAction func tapChange(_ sender: UIButton, forEvent event: UIEvent) {
        
        if (btnChange.currentTitle == "THÊM MỚI"){
//            if (checkInfo()){
//                let name = chuanHoa(tfTenHang.text)
//                let email = chuanHoa(tfEmail.text)
//                let phone = chuanHoa(tfPhone.text)
//
//
//                tfTenHang.text = name
//                tfEmail.text = email
//                tfPhone.text = phone
//
//                if (isUploadPicture){
//                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { base, error in
//                        if let base = base {
//                            if base.success == true{
//                                if let url = base.message{
//                                    self.picture = url
//                                }
//                                let params = HangSXModel(mahang: nil, tenhang: name, email: email, sdt: phone, logo: self.picture).convertToDictionary()
//                                // xử lý update
//                                self.addHangSX(params: params)
//                            }
//                        }
//                    }
//                }else {
//                    let params = HangSXModel(mahang: nil, tenhang: name, email: email, sdt: phone, logo: "/images/noimage.png").convertToDictionary()
//                    print(params)
//                    self.addHangSX(params: params)
//                }
//            }
        } else
        if (btnChange.currentTitle == "THAY ĐỔI THÔNG TIN"){
            self.onFill()
            btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
//            if (checkInfo()){
//
//                let maHang = Int(tfMaHang.text!)
//                let name = chuanHoa(tfTenHang.text)
//                let email = chuanHoa(tfEmail.text)
//                let phone = chuanHoa(tfPhone.text)
//                let logoG = brand?.logo!
//
//
//                tfTenHang.text = name
//                tfEmail.text = email
//                tfPhone.text = phone
//
//                if (isUploadPicture){
//                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { base, error in
//                        if let base = base {
//                            if base.success == true{
//                                if let url = base.message{
//                                    self.picture = url
//                                }
//                                let params = HangSXModel(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: self.picture).convertToDictionary()
//                                // xử lý update
//                                self.updateHangSX(params: params)
//                            }
//                        }
//                    }
//                }else {
//                    let params = HangSXModel(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: logoG).convertToDictionary()
//                    print(params)
//                    self.updateHangSX(params: params)
//                }
//            }
        }
    }
    
    @IBAction func tapDelete(_ sender: UIButton, forEvent event: UIEvent) {
    }
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
    
    func checkInfo() -> Bool{
//        guard
//            var email = tfEmail.text,
//            var name = tfTen.text,
//            var birthday = tfNgaySinh.text,
//            var phone = tfSDT.text
//        else {
//            return false
//        }
        
//        email = chuanHoa(tfEmail.text)
//        name = chuanHoa(tfTen.text)
//        phone = chuanHoa(tfSDT.text)
//        if (email.isEmpty || name.isEmpty ||
//            birthday.isEmpty || phone.isEmpty) {
//            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
//                self.dismiss(animated: true)
//            }))
//            self.present(alert, animated: true)
//            return false
//        }
//
//        if (!isValidEmail(email: email)){
//            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
//                self.dismiss(animated: true)
//            }))
//            self.present(alert, animated: true)
//            return false
//        }
       
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
