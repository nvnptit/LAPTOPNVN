//
//  SearchViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 24/07/2022.
//

import UIKit
import DropDown
import SDWebImage
import NVActivityIndicatorView
import Speech
import AVKit
import Vision

class SearchViewController: UIViewController, SFSpeechRecognizerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var camera: UIButton!
    var recognizedText = ""
    
    var isVN = true
    @IBOutlet weak var langVi: UIButton!
    @IBOutlet weak var langEn: UIButton!
    
    @IBOutlet weak var mic: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tfGiaMin: UITextField!
    @IBOutlet weak var tfGiaMax: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbBrand: UILabel!
    
    @IBOutlet weak var dropdownBrand: UIView!
    var maHang: Int?
    var data: [LoaiSanPhamKM] = []
    
    var brand = DropDown()
    var dataBrand: [HangSX] = []
    var brandValues: [String] = ["All"]
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    
    @IBAction func takingPicture(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.searchBar.text = ""
                self.recognizedText = ""
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                present(vc, animated: true)
            }
        }

    //MARK: - MICRO
//    var speechRecognizer:  SFSpeechRecognizer?
    
    var speechVN = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
    var speechUS = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    @IBAction func btnMicSpeechToText(_ sender: UIButton, forEvent event: UIEvent) {
        // Disable Language
        self.langVi.isUserInteractionEnabled = false
        self.langEn.isUserInteractionEnabled = false
        
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.mic.isEnabled = false
            self.mic.setTitle("", for: .normal)
        } else {
            if (isVN == true){
                self.startRecordingVN()
                self.mic.setTitle("Stop Recording", for: .normal)
            }else {
                self.startRecordingUS()
                self.mic.setTitle("Stop Recording", for: .normal)
            }
        }
    }
    
    func setupSpeech() {
        self.mic.isEnabled = false
        
        self.speechVN?.delegate = self
        self.speechUS?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                @unknown default:
                    fatalError()
            }
            
            OperationQueue.main.addOperation() {
                self.mic.isEnabled = isButtonEnabled
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func converNumberToText(data1: String) -> String{
        var data = data1
        data = data.replacingOccurrences(of: "một", with: "1")
        data = data.replacingOccurrences(of: "hai", with: "2")
        data = data.replacingOccurrences(of: "ba", with: "3")
        data = data.replacingOccurrences(of: "bốn", with: "4")
        data = data.replacingOccurrences(of: "năm", with: "5")
        data = data.replacingOccurrences(of: "sáu", with: "6")
        data = data.replacingOccurrences(of: "bảy", with: "7")
        data = data.replacingOccurrences(of: "bẩy", with: "7")
        data = data.replacingOccurrences(of: "tám", with: "8")
        data = data.replacingOccurrences(of: "chín", with: "9")
        data = data.replacingOccurrences(of: "mừ", with: "10")
        //        data = data.replaceCharacters(characters: "một", toSeparator: "1")
        return data
    }
    
    func startRecordingVN() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechVN?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                self.searchBar.text = result?.bestTranscription.formattedString
                self.searchBar.text = self.converNumberToText(data1: self.searchBar.text ?? "")
                isFinal = (result?.isFinal)!
                self.getDataSearch()
            }
            
            if error != nil || isFinal { // || self.time == 0
                print("KẾT THÚC")
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.mic.setTitle("", for: .normal)
                self.recognitionTask?.cancel()
                self.recognitionTask = nil
                self.mic.isEnabled = true
                
                // Enable Language
                self.langVi.isUserInteractionEnabled = true
                self.langEn.isUserInteractionEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.searchBar.text = "Tôi đang lắng nghe..."
    }
    func startRecordingUS() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechUS?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                self.searchBar.text = result?.bestTranscription.formattedString
                self.searchBar.text = self.converNumberToText(data1: self.searchBar.text ?? "")
                isFinal = (result?.isFinal)!
                self.getDataSearch()
            }
            
            if error != nil || isFinal { // || self.time == 0
                print("KẾT THÚC")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.mic.setTitle("", for: .normal)
                self.recognitionTask?.cancel()
                self.recognitionTask = nil
                self.mic.isEnabled = true
                
                // Enable Language
                self.langVi.isUserInteractionEnabled = true
                self.langEn.isUserInteractionEnabled = true
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.searchBar.text = "Listening..."
    }
    
    @IBAction func tapLangVi(_ sender: UIButton, forEvent event: UIEvent) {
        langVi.backgroundColor = .green
        langEn.backgroundColor = .white
        isVN = true
        //            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
        //        self.setupSpeech()
    }
    
    @IBAction func tapLangEn(_ sender: UIButton, forEvent event: UIEvent) {
        langEn.backgroundColor = .green
        langVi.backgroundColor = .white
        isVN = false
        //            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))
        //        self.setupSpeech()
    }
    
    
    //MARK: - END SETUP MICRO
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tìm kiếm sản phẩm"
        
            langVi.backgroundColor = .green
            langEn.backgroundColor = .white
        setupDropDown()
        setupKeyboard()
        setupSpeech()
        
        searchBar.delegate = self
        tfGiaMin.delegate = self
        tfGiaMax.delegate = self
        getDataBrands()
        configLayout()
        
        collectionView.register(UINib(nibName: "SanPhamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SanPhamCollectionViewCell")
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view1.addGestureRecognizer(gesture)
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
    
    private func setupBrand() {
        brand.anchorView = dropdownBrand
        brand.dataSource = brandValues
        brand.bottomOffset = CGPoint(x: 0, y:(brand.anchorView?.plainView.bounds.height)! + 5)
        brand.direction = .bottom
        brand.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbBrand.text = item
            for i in dataBrand{
                if let name = i.tenhang, let ma = i.mahang {
                    if (name == item){
                        self.maHang = ma
                    }
                }
            }
            if (item == "All") {
                self.maHang = nil
            }
            getDataSearch()
        }
        
        let gestureClock = UITapGestureRecognizer(target: self, action: #selector(didTapBrand))
        dropdownBrand.addGestureRecognizer(gestureClock)
        dropdownBrand.layer.borderWidth = 1
        dropdownBrand.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @objc func didTapBrand() {
        brand.show()
    }
    
    private func getDataBrands(){
        APIService.getHangSX(with: .getHangSX, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataBrand = base.data ?? []
                for item in self.dataBrand{
                    self.brandValues.append(item.tenhang ?? "")                }
            }
            self.setupBrand()
        })
    }
    
    
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.cyan
        DropDown.appearance().cornerRadius = 8
    }
    
    func configLayout(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (numberOfSection, env) in
            guard let self = self else { return nil }
            let section = self.sanPhamSection
            return section
            
        }
    }()
    
    private var sanPhamSection: NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .absolute(320),
                heightDimension: .absolute(300)
            ),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
    }
  
}
extension SearchViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getDataSearch()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        getDataSearch()
    }
}


extension SearchViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SanPhamCollectionViewCell", for: indexPath) as? SanPhamCollectionViewCell else {fatalError()}
        let e = data[indexPath.item]
        if let ten = e.tenlsp, let price = e.giamoi, let newPrice = e.giagiam , let anh = e.anhlsp, let gg = e.ptgg{
            cell.name.text = ten
            if (gg > 0 ){
                cell.oldPrice.text = "\(CurrencyVN.toVND(price))"
                cell.oldPrice.textColor = .red
                cell.oldPrice.strikeThrough(true)
                cell.newPrice.text = "\(CurrencyVN.toVND(newPrice))"
            }else {
                cell.oldPrice.text = ""
                cell.newPrice.text =  "\(CurrencyVN.toVND(price))"
            }
//            cell.image.loadFrom(URLAddress: APIService.baseUrl + anh)
            cell.image.getImage(url: APIService.baseUrl + anh, completion: { img in
               
                DispatchQueue.main.sync {
                    cell.image.image = img
                }
            })
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        self.fetchListComment(item: item)
    }
}

extension SearchViewController {
    
    //self.fetchListComment(item: item)
    func fetchListComment(item: LoaiSanPhamKM){
        let maLSP = item.malsp!
        APIService.getRateList(with: maLSP, {
            data, error in
            guard let data = data else {return}
            if (data.success == true){
                let detailSPViewController = DetailSanPhamViewController()
                detailSPViewController.loaiSp = item
                detailSPViewController.listComment = data.data ?? []
                self.navigationController?.pushViewController(detailSPViewController, animated: true)
            }
        })
    }
    
    private func getDataSearch(){
        print("SEARCHNAME: \(searchBar.text)")
        let min = tfGiaMin.text?.count == 0 ? nil : Int(tfGiaMin.text!)
        let max = tfGiaMax.text?.count == 0 ? nil : Int(tfGiaMax.text!)
        let params = SearchModel(tenLSP: searchBar.text, priceMin: min, priceMax: max, maHang: self.maHang).convertToDictionary()
        APIService.searchLoaiSanPham(with: .searchLSP, params: params, headers: nil, completion: {
            [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true , let data = base.data{
                self.data = data
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        })
    }
    
}

extension SearchViewController{
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
}

extension SearchViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
//        self.imageView.image = image
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    for observation in requestResults {
                        guard let candidate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidate.string
                        self.recognizedText += "\n"
                    }
                    self.searchBar.text = self.recognizedText
                }
            }
        })
        textRecognitionRequest.recognitionLanguages = ["vi-VN"]
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            getDataSearch()
        } catch {
            print(error)
        }
    }

}
