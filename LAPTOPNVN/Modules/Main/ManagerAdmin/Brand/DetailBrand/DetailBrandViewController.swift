//
//  DetailBrandViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 07/08/2022.
//

import UIKit

class DetailBrandViewController: UIViewController {
    
    @IBOutlet weak var lbMaHang: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfMaHang: UITextField!
    @IBOutlet weak var tfTenHang: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    @IBOutlet weak var viewPicture: UIView!
    @IBOutlet weak var imagePicture: UIImageView!
    
    @IBOutlet weak var btnChange: UIButton!
    var brand: HangSX?
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var camera: UIView!
    let imagePickerController = UIImagePickerController()
    var image = UIImage()
    var picture: String = ""
    var isUploadPicture: Bool = false
    var isNew: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        camera.isUserInteractionEnabled = false;
        // Do any additional setup after loading the view.
        if (!isNew){
            title = brand?.tenhang!
        }else {
            title = " THÊM HÃNG SẢN XUẤT MỚI"
            lbMaHang.isHidden = true
            tfMaHang.isHidden = true
            btnDelete.isHidden = true
            
            btnChange.setTitle("THÊM MỚI", for: .normal)
            self.onFill()
        }
        
        viewPicture.layer.cornerRadius = 12
        viewPicture.layer.masksToBounds = true
        viewPicture.layer.borderColor = UIColor.systemGray.cgColor
        viewPicture.layer.borderWidth = 1
        setupKeyboard()
        setupUploadAvatar()
    }
    func loadData(){
        if let brand = brand {
            self.tfMaHang.text = "\(brand.mahang!)"
            self.tfTenHang.text = brand.tenhang!
            self.tfEmail.text = brand.email
            self.tfPhone.text = brand.sdt
            if let logo = brand.logo{
                self.imagePicture.loadFrom(URLAddress: APIService.baseUrl+logo)
            }
        }
    }
    
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    func checkInfo() -> Bool{
        
//        @IBOutlet weak var tfMaHang: UITextField!
//        @IBOutlet weak var tfTenHang: UITextField!
//        @IBOutlet weak var tfEmail: UITextField!
//        @IBOutlet weak var tfPhone: UITextField!
        guard
            var email = tfEmail.text,
            var name = tfTenHang.text,
            var phone = tfPhone.text
        else {
            return false
        }
        
        email = chuanHoa(tfEmail.text)
        name = chuanHoa(tfTenHang.text)
        phone = chuanHoa(tfPhone.text)
        tfEmail.text = email
        tfTenHang.text = name
        tfPhone.text = phone
        
        if (email.isEmpty || name.isEmpty || phone.isEmpty) {
            let alert = UIAlertController(title: "Bạn cần điền đầy đủ thông tin", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        
        if (!isValidEmail(email: email)){
            let alert = UIAlertController(title: "Email không đúng định dạng", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        if (!isValidPhone(phone: phone)){
            let alert = UIAlertController(title: "Số điện thoại không hợp lệ", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    func offFill(){
        camera.isUserInteractionEnabled = false;
        tfTenHang.backgroundColor = .lightGray
        tfEmail.backgroundColor = .lightGray
        tfPhone.backgroundColor = .lightGray
        
        tfTenHang.isEnabled = false
        tfEmail.isEnabled = false
        tfPhone.isEnabled = false
    }
    func onFill(){
        camera.isUserInteractionEnabled = true;
            tfTenHang.backgroundColor = .none
            tfEmail.backgroundColor = .none
            tfPhone.backgroundColor = .none
            
            tfTenHang.isEnabled = true
            tfEmail.isEnabled = true
            tfPhone.isEnabled = true
    }
    @IBAction func tapChangeInfo(_ sender: UIButton, forEvent event: UIEvent) {
        if (btnChange.currentTitle == "THÊM MỚI"){
            if (checkInfo()){
                let name = chuanHoa(tfTenHang.text)
                let email = chuanHoa(tfEmail.text)
                let phone = chuanHoa(tfPhone.text)
                
                
                tfTenHang.text = name
                tfEmail.text = email
                tfPhone.text = phone
                
                if (isUploadPicture){
                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { base, error in
                        if let base = base {
                            if base.success == true{
                                if let url = base.message{
                                    self.picture = url
                                }
                                let params = HangSXModel(mahang: nil, tenhang: name, email: email, sdt: phone, logo: self.picture).convertToDictionary()
                                // xử lý update
                                self.addHangSX(params: params)
                            }
                        }
                    }
                }else {
                    let params = HangSXModel(mahang: nil, tenhang: name, email: email, sdt: phone, logo: "/images/noimage.png").convertToDictionary()
                    print(params)
                    self.addHangSX(params: params)
                }
            }
        } else
        if (btnChange.currentTitle == "THAY ĐỔI THÔNG TIN"){
            self.onFill()
            btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
        }
        else {
            if (checkInfo()){
                
                let maHang = Int(tfMaHang.text!)
                let name = chuanHoa(tfTenHang.text)
                let email = chuanHoa(tfEmail.text)
                let phone = chuanHoa(tfPhone.text)
                let logoG = brand?.logo!
                
                
                tfTenHang.text = name
                tfEmail.text = email
                tfPhone.text = phone
                
                if (isUploadPicture){
                    APIService.uploadAvatar(with: .uploadAvatar, image: image) { base, error in
                        if let base = base {
                            if base.success == true{
                                if let url = base.message{
                                    self.picture = url
                                }
                                let params = HangSXModel(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: self.picture).convertToDictionary()
                                // xử lý update
                                self.updateHangSX(params: params)
                            }
                        }
                    }
                }else {
                    let params = HangSXModel(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: logoG).convertToDictionary()
                    print(params)
                    self.updateHangSX(params: params)
                }
            }
        }
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        let params = HangModel(maHang: Int(tfMaHang.text!)).convertToDictionary()
        delHangSX(params: params)
        
    }
    
}
extension DetailBrandViewController{
    private func setupUploadAvatar() {
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

extension DetailBrandViewController{
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
}

extension DetailBrandViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
extension DetailBrandViewController{
    private func updateHangSX(params: [String: Any]?) {
        APIService.postHangSX(with: .putHangSX, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Cập nhật thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    self.btnChange.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
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
    private func addHangSX(params: [String: Any]?) {
        APIService.postHangSX(with: .postHangSX, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Thêm mới thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    
                    let vc = BrandViewController()
                    vc.navigationItem.hidesBackButton = true
                    vc.isAdded = true
                    self.navigationController?.pushViewController(vc, animated: true)
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
    private func delHangSX(params: [String: Any]?) {
        APIService.postHangSX(with: .delHangSX, params: params, headers: nil, completion: {
            base, error in
            guard let base = base else { return }
            if base.success == true {
                let alert = UIAlertController(title: "Xoá hãng thành công!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ _ in
                    self.dismiss(animated: true)
                    let vc = BrandViewController()
                    vc.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(vc, animated: true)
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
extension DetailBrandViewController{
    
    func isValidPhone(phone: String) -> Bool {
        let regexPhone =  "(84|0){1}(3|5|7|8|9){1}+([0-9]{8})"
        let phoneTest = NSPredicate(format: "SELF MATCHES%@", regexPhone)
        print(phoneTest.evaluate(with: phone))
        return phoneTest.evaluate(with: phone)
    }
    func isValidEmail( email:String)->Bool{
        let regexEmail = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let passwordTest=NSPredicate(format:"SELF MATCHES%@",regexEmail)
        print(passwordTest.evaluate(with:email))
        return passwordTest.evaluate(with:email)
    }
    
}
