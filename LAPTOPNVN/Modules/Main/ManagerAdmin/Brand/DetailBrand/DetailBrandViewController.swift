//
//  DetailBrandViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 07/08/2022.
//

import UIKit

class DetailBrandViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfMaHang: UITextField!
    @IBOutlet weak var tfTenHang: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPicture: UITextField!
    
    @IBOutlet weak var btnChange: UIButton!
    var brand: HangSX?
    
    @IBOutlet weak var camera: UIView!
    let imagePickerController = UIImagePickerController()
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
        title = brand?.tenhang!
        
        setupKeyboard()
        setupUploadAvatar()
    }
    func loadData(){
        if let brand = brand {
            self.tfMaHang.text = "\(brand.mahang!)"
            self.tfTenHang.text = brand.tenhang!
            self.tfEmail.text = brand.email
            self.tfPhone.text = brand.sdt
            self.tfPicture.text = brand.logo
        }
    }
    
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        print(kq)
        return kq;
    }
    func checkFill()->Bool {
        return true
    }
    @IBAction func tapChangeInfo(_ sender: UIButton, forEvent event: UIEvent) {
        
            if (btnChange.currentTitle == "THAY ĐỔI THÔNG TIN"){
                tfTenHang.backgroundColor = .none
                tfEmail.backgroundColor = .none
                tfPhone.backgroundColor = .none
                tfPicture.backgroundColor = .none
                
                tfTenHang.isEnabled = true
                tfEmail.isEnabled = true
                tfPhone.isEnabled = true
                tfPicture.isEnabled = true
                
                btnChange.setTitle("LƯU THAY ĐỔI", for: .normal)
            }
            else {
                if (checkFill()){
//                    tfMaHang.backgroundColor = .lightGray
                    tfTenHang.backgroundColor = .lightGray
                    tfEmail.backgroundColor = .lightGray
                    tfPhone.backgroundColor = .lightGray
                    tfPicture.backgroundColor = .lightGray
                    
//                    tfMaHang.isEnabled = false
                    tfTenHang.isEnabled = false
                    tfEmail.isEnabled = false
                    tfPhone.isEnabled = false
                    tfPicture.isEnabled = false
                    
                    let maHang = Int(tfMaHang.text!)
                    let name = chuanHoa(tfTenHang.text)
                    let email = chuanHoa(tfEmail.text)
                    let phone = chuanHoa(tfPhone.text)
                    let picture = chuanHoa(tfPicture.text)
                    
                    
                    tfTenHang.text = name
                    tfEmail.text = email
                    tfPhone.text = phone
                    tfPicture.text = picture
                    
                    let params = HangSX(mahang: maHang, tenhang: name, email: email, sdt: phone, logo: picture)
                    
        //            avatar.image = image
        //            presenter.postUploadAvatar(image)
                    btnChange.setTitle("THAY ĐỔI THÔNG TIN", for: .normal)
                    
                }
            }
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        
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
        let alert = UIAlertController(title: "Upload your avatar.", message: "Select a way", preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Choose Photo", style: .default) { action in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Take Photo", style: .default) { action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let actionCencal = UIAlertAction(title: "Cencal", style: .cancel, handler: nil)
        
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
        if let image: UIImage = info[.editedImage] as? UIImage {
            self.image = image
            imagePickerController.dismiss(animated: true)
        }
    }
}
extension DetailBrandViewController{
    private func uploadAvatar(image: UIImage?) {
        APIService.uploadAvatar(with: .uploadAvatar, image: image) { base, error in
            if let base = base {
                if base.success == true{
                    print("success")
                }
            }
        }
    }
}
