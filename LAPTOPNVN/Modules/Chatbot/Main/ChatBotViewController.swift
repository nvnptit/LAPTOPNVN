//
//  ChatBotViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 04/11/2022.
//

import UIKit
import Speech
import AVKit

protocol BotResponseDelegate: NSObjectProtocol {
    func welcomeReply()
    func meReply()
    func defaultReply()
    func dataCart()
    func historyCart(status: Int)
    func detailHistoryCart(idGH: Int)
    func searchByManufacturer(name: String)
    
    func paymentReply()
}
class ChatResponse {
    var delegate: BotResponseDelegate?
    init(){  }
    
}
class ChatBotViewController: UIViewController, UITableViewDelegate {
    
    var checkOrder = false
    var kt = false
    
    var isVN = true
    @IBOutlet weak var langVi: UIButton!
    @IBOutlet weak var langEn: UIButton!
    
    var result = ""
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    private var sendAction = ChatResponse()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageViewBottomConstraints: NSLayoutConstraint!
    
    var messages: [Message] = []
    var dataHistory: [HistoryOrderCMND] = []
    var dataManufacture: [HangSX] = []
    var dataLSP : [LoaiSanPhamKM] = []
    
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
                self.messageTextfield.text = result?.bestTranscription.formattedString
                self.messageTextfield.text = self.converNumberToText(data1: self.messageTextfield.text ?? "")
                isFinal = (result?.isFinal)!
                
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
        
        self.messageTextfield.text = "Mời nói, Tôi đang lắng nghe..."
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
                self.messageTextfield.text = result?.bestTranscription.formattedString
                self.messageTextfield.text = self.converNumberToText(data1: self.messageTextfield.text ?? "")
                isFinal = (result?.isFinal)!
                
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
        
        self.messageTextfield.text = "Listening..."
    }
    
    
    
    @IBAction func tapLangVi(_ sender: UIButton, forEvent event: UIEvent) {
        langVi.backgroundColor = .green
        langEn.backgroundColor = .white
        isVN = true
        messageTextfield.placeholder = "Nhập tin nhắn..."
        //            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
        //        self.setupSpeech()
    }
    
    @IBAction func tapLangEn(_ sender: UIButton, forEvent event: UIEvent) {
        langEn.backgroundColor = .green
        langVi.backgroundColor = .white
        isVN = false
        messageTextfield.placeholder = "Write a message..."
        //            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))
        //        self.setupSpeech()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        self.langVi.backgroundColor = .green
        self.langEn.backgroundColor = .white
        messageTextfield.placeholder = "Nhập tin nhắn..."
        
        self.setupSpeech()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        tableView.dataSource = self
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 0.5
        
//        title = K.appName // ChatbotVN
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        let newMessage = Message(sender: "BOT", body: "Xin chào bạn, mình rất vui khi được hỗ trợ bạn!")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        sendAction.delegate = self
        loadOrderCMND()
        loadDataManufacture()
        getListLSP()
    }
    
    
    func chuanHoa(_ s:String?) -> String {
        let s1 = s!.trimmingCharacters(in: .whitespaces);
        let kq = s1.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return kq;
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.audioEngine.stop()
        self.recognitionRequest = nil
        self.mic.setTitle("", for: .normal)
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        self.mic.isEnabled = true
        
        guard var mess = messageTextfield.text else {return}
        if mess.isEmpty {
            return
        }
        let newMessage = Message(sender: "ME", body: mess)
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.messageTextfield.text = ""
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        mess = chuanHoa(mess).lowercased()
        print(mess)
        
        // Đặt hàng
        if (mess.contains("thêm vào giỏ hàng") || mess.contains("thêm sản phẩm")){
            checkOrder = true
        }
        
        if checkOrder == true {
            var t1 = false
            if (mess.contains("thêm vào giỏ hàng") || mess.contains("thêm sản phẩm") ){
                replyText(message: "Nhập tên sản phẩm và số lượng")
                t1 = true
                return
            }
            if (t1 == false && (mess.contains("huỷ thao tác") || mess.contains("cancel order"))){
                checkOrder = false
                t1 = true
                replyText(message: "Đã ngừng đặt hàng")
                return
            } // số lượng 2
            if (t1 == false ){
                mess = mess.replacingOccurrences(of: " số lượng", with: "")
                mess = mess.replacingOccurrences(of: " amount", with: "")
                var words = mess.components(separatedBy: " ")
                let sl = Int(words.last ?? "-1") ?? -1
                
                if sl > 0{
                    words = words.filter({$0 != "\(sl)"})
                    let name = chuanHoa(words.joined(separator: " ")+"")
                    print(name)
                    // FOR 1
                    for item in dataLSP {
                        if  let nameLSP = item.tenlsp?.lowercased(){
                            
                            if name.contains(nameLSP){
                                kt = true
                                break;
                            }
                        }
                    }
                    if (kt == false){
                        self.replyText(message: "Không tìm thấy tên sản phẩm")
                    }else {
                        //FOR 2
                        for item in dataLSP {
                            if  let nameLSP = item.tenlsp?.lowercased(){
                                kt = true
                                if name.contains(nameLSP){
                                    var value = 0
                                    var value1 = 0
                                    var key = item.malsp ?? ""
                                    let listData = UserService.shared.listGH2
                                    let element = listData.filter { $0.data?.malsp == item.malsp}
                                    if (!element.isEmpty){
                                        key = element[0].data?.malsp ?? ""
                                        value1 = element[0].sl
                                    }
                                    value = value + value1
                                    APIService.getSLLSP(with: key, { data, error in
                                        guard let data = data else {
                                            return
                                        }
                                        if (data.success == true ){
                                            if let data = data.message {
                                                if ((value + sl) > data){
                                                    self.replyText(message: "Số lượng đã vượt quá số lượng tồn")
                                                    return
                                                }
                                                else
                                                // Xử lý thêm vào giỏ hàng
                                                {
                                                    UserService.shared.addOrderChatBot(with: item,sl: sl)
                                                    self.replyText(message: "Thêm vào giỏ hàng thành công")
                                                    self.checkOrder = false
                                                    t1 = true
                                                    return
                                                }
                                            }
                                        }// HP Zenbook số lượng 2
                                        
                                    })
                                    
                                }
                            }
                            
                        }
                        
                    }
                }else {
                    replyText(message: "Tên sản phẩm hoặc số lượng không hợp lệ.\n Bạn vui lòng nhập lại")
                    return
                }
            }
            return
        }
        
        
        var dataIntent: [Intent] = []
        dataIntent.append(
            Intent(tag: "cart", patterns: ["giỏ hàng","my cart"], responses:  0))
        dataIntent.append(
            Intent(tag: "order", patterns: ["Chờ","chờ duyệt"], responses:  1))
        dataIntent.append(
            Intent(tag: "pending", patterns: ["đã duyệt","đang giao","sắp giao"], responses:  2))
        dataIntent.append(
            Intent(tag: "ship", patterns: ["Đã giao","hoàn tất","Đã nhận"], responses:  3))
        dataIntent.append(
            Intent(tag: "cancel", patterns: ["Đã huỷ","bị huỷ"], responses:  4))
        dataIntent.append(
            Intent(tag: "welcome", patterns: ["xin chào","hello"], responses:  5))
        dataIntent.append(
            Intent(tag: "me", patterns: ["là ai","bạn là","who"], responses:  6))
        dataIntent.append(
            Intent(tag: "detailOrder", patterns: ["chi tiết đơn hàng","detail order"], responses:  7))
        dataIntent.append(
            Intent(tag: "manufacturer", patterns: ["Máy tính dell","dell","asus","acer","hp","msi","lenovo"], responses:  8))
        dataIntent.append(
            Intent(tag: "pay", patterns: ["thanh toán","pay"], responses:  9))
        
        for item in dataIntent {
            let c =  item.patterns?.filter({ mess.lowercased().contains($0.lowercased())})
            
            if c?.capacity ?? 0 > 0 {
                if (item.responses == 7){
                    let words = mess.components(separatedBy: " ")
                    actionResponse(7, idGH: Int(words.last ?? "-1") ?? -1, name: "")
                    return
                }
                if (item.responses == 8){
                    let words = mess.components(separatedBy: " ")
                    actionResponse(8, idGH: -1, name: words.last ?? "" )
                    return
                }
                actionResponse(item.responses ?? -1 ,idGH: -1, name: "")
                return
            }
        }
        sendAction.delegate?.defaultReply()
    }
    //END SUPERVIEW
    
    func replyText(message: String){
        let newMessage = Message(sender: "BOT", body: message)
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func actionResponse(_ id: Int, idGH: Int,name: String) {
        switch id {
            case 0:
                sendAction.delegate?.dataCart()
            case 1:
                sendAction.delegate?.historyCart(status: 0 ) // Duyệt
            case 2:
                sendAction.delegate?.historyCart(status: 1 ) // Giao
            case 3:
                sendAction.delegate?.historyCart(status: 2 ) // Đã giao
            case 4:
                sendAction.delegate?.historyCart(status: 3 ) // Huỷ
            case 5:
                sendAction.delegate?.welcomeReply()
            case 6:
                sendAction.delegate?.meReply()
            case 7:
                sendAction.delegate?.detailHistoryCart(idGH: idGH)
            case 8:
                sendAction.delegate?.searchByManufacturer(name: name)
            case 9:
                sendAction.delegate?.paymentReply()
            default:
                sendAction.delegate?.defaultReply()
        }
    }
    
}
extension ChatBotViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        cell.messageBubble.sizeToFit()
        if message.sender != "BOT" {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor.systemBlue //UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = .white //UIColor(named: K.BrandColors.purple)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = .darkGray//UIColor(named: K.BrandColors.purple)
            cell.label.textColor = .white//UIColor(named: K.BrandColors.lightPurple)
            
        }
        return cell
    }
}

extension ChatBotViewController{
    //MARK: - Setup keyboard, user
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageViewBottomConstraints.constant == 0 {
                messageViewBottomConstraints.constant = keyboardSize.height
                tableView.setContentOffset(.init(x: 0, y: tableView.contentOffset.y + keyboardSize.height), animated: true)
            }
        }
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        if messageViewBottomConstraints.constant != 0 {
            messageViewBottomConstraints.constant = 0
            tableView.setContentOffset(.init(x: 0, y: tableView.contentSize.height), animated: true)
        }
    }
    //MARK: - End Setup keyboard
    
}

extension ChatBotViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.mic.isEnabled = true
        } else {
            self.mic.isEnabled = false
        }
    }
}

extension ChatBotViewController: BotResponseDelegate{
    func paymentReply() {
        if (UserService.shared.getlistGH().isEmpty){
            replyText(message: "Bạn chưa có sản phẩm nào trong giỏ hàng!")
            return
        }else {
            let vc = CartViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func welcomeReply(){
        let newMessage = Message(sender: "BOT", body: "Xin chào, rất vui khi được hỗ trợ bạn")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    func meReply() {
        let newMessage = Message(sender: "BOT", body: "Tôi là trợ lý sẽ hỗ trợ bạn")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    func defaultReply(){
        let newMessage = Message(sender: "BOT", body: "Tôi chưa hiểu, mong bạn nói lại")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    func dataCart() {
        let newMessage = Message(sender: "BOT", body: "        Thông tin giỏ hàng của bạn      \n     -------------------------------\n"+UserService.shared.getlistGH2())
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func historyCart(status: Int) {
        self.loadHistoryCart(status: status)
    }
    
    func detailHistoryCart(idGH: Int) {
        let a = dataHistory.filter({$0.idgiohang == idGH})
        print(dataHistory)
        if a.capacity > 0 {
            self.loadDetailOrder(idGH: idGH)
        }else {
            let newMessage = Message(sender: "BOT", body: "Đơn hàng của bạn không tồn tại!")
            self.messages.append(newMessage)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func searchByManufacturer(name:String) {
        for item in dataManufacture{
            if let nameManu = item.tenhang , let idManu = item.mahang{
                if nameManu.lowercased().contains(name){
                    let vc = ListLaptopViewController()
                    vc.typeHome = "Brand"
                    vc.maHang = idManu
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}
extension ChatBotViewController{
    //MARK: - Load History Cart
    func loadHistoryCart(status: Int){
        let params = HistoryModel(status: status, cmnd: UserService.shared.cmnd, dateFrom: nil, dateTo: nil).convertToDictionary()
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self , UserService.shared.cmnd != "" else { return }
            
            APIService.getHistoryOrder1(with: .getHistoryOrder, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        // self.dataHistory = data
                        var result = ""
                        for item in data {
                            if let idgiohang = item.idgiohang,
                               let ngaylapgiohang = item.ngaylapgiohang,
                               let nguoinhan = item.nguoinhan,
                               let diachi = item.diachi,
                               let sdt = item.sdt,
                               let ngaydukien = item.ngaydukien,
                               let tonggiatri = item.tonggiatri,
                               let phuongthuc = item.phuongthuc,
                               let tinhtrang = item.thanhtoan,
                               let tinhtrangdh = item.tentrangthai
                            {
                                result = result + """
                            Mã đơn hàng: \(idgiohang)
                            Ngày lập: \( Date().convertDateTimeSQLToView(date: ngaylapgiohang, format: "dd-MM-yyyy HH:mm:ss"))
                            Ngày nhận dự kiến: \( Date().convertDateTimeSQLToView(date: ngaydukien, format: "dd-MM-yyyy"))
                            Tổng giá trị: \(CurrencyVN.toVND(tonggiatri))
                            Người nhận: \(nguoinhan)
                            Địa chỉ: \(diachi)
                            Số điện thoại: \(sdt)
                            Phương thức thanh toán: \(phuongthuc)
                            Tình trạng: \(tinhtrang == true ? "Đã thanh toán": "Chưa thanh toán")
                            Trạng thái: \(tinhtrangdh)
                                   ------------------------------\n
                            """
                            }
                        }
                        
                        let newMessage = Message(sender: "BOT", body: "        Thông tin đơn hàng đang giao      \n       -------------------------------\n"+result)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                }
            })
        }
    }
    //MARK: - Load Detail Order
    func loadDetailOrder(idGH: Int){
        if (idGH == -1){
            sendAction.delegate?.defaultReply()
            return
        }
        print(idGH)
        DispatchQueue.init(label: "DetailOrder", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let params = ModelDetailHistory(idGioHang: idGH).convertToDictionary()
            
            APIService.getDetailHistoryOrder1(with: .getDetailHistory, params: params, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    var result = ""
                    if let data = base.data {
                        for item in data {
                            if let tenlsp = item.tenlsp,
                               let cardscreen = item.cardscreen,
                               let cpu = item.cpu,
                               let giaban = item.giaban,
                               let harddrive = item.harddrive,
                               let mota = item.mota,
                               let os = item.os,
                               let ram = item.ram,
                               let serial = item.serial
                            {
                                result = result + """
                            Sản phẩm: \(tenlsp)
                            Serial: \(serial)
                            Card: \(cardscreen)
                            Cpu: \(cpu)
                            Harddrive: \(harddrive)
                            Ram: \(ram)
                            OS: \(os)
                            Mô tả: \(mota)
                            ------------------------------\n
                            """
                            }
                        }
                        let newMessage = Message(sender: "BOT", body: "        Thông tin chi tiết đơn hàng \(idGH)     \n     -------------------------------\n"+result)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                    }
                    
                } else {
                    fatalError()
                }
                
            })
        }
    }
    //MARK: - Load data All Order CMND
    func loadOrderCMND(){
        
        let params = GioHangRequest(cmnd: UserService.shared.cmnd).convertToDictionary()
        DispatchQueue.init(label: "CartVC", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self , UserService.shared.cmnd != "" else { return }
            
            APIService.getHistoryOrderCMND(with: .getHistoryOrderCMND, params: params, headers: nil, completion: {
                [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    if let data = base.data {
                        self.dataHistory = data
                    }
                }
            })
        }
    }
    //MARK: - Load data Manufacturer
    
    func loadDataManufacture(){
        DispatchQueue.init(label: "Manufacture", qos: .utility).asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            APIService.getHangSX(with: .getHangSX, params: nil, headers: nil, completion: { [weak self] base, error in
                guard let self = self, let base = base else { return }
                if base.success == true {
                    self.dataManufacture = (base.data ?? [])
                }
            })
        }
        
    }
    //MARK: - Load Full LSP
    
    func getListLSP(){
        APIService.getLoaiSanPhamFull(with: .getLoaiSanPhamFull, params: nil, headers: nil, completion: { [weak self] base, error in
            guard let self = self, let base = base else { return }
            if base.success == true {
                self.dataLSP = base.data ?? []
            }
        })
    }
    //MARK: - Check So luong ton LSP
    
}
