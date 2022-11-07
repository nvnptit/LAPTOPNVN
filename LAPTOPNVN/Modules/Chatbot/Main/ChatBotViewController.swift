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
    func defaultReply()
    func dataCart()
    func historyCart(status: Int)
    func detailHistoryCart()
    func searchByManufacturer()
}
class ChatResponse {
    var delegate: BotResponseDelegate?
    init(){  }
    
}
class ChatBotViewController: UIViewController, UITableViewDelegate {
    
    var result = ""
    @IBOutlet weak var mic: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    private var sendAction = ChatResponse()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageViewBottomConstraints: NSLayoutConstraint!
    
    var messages: [Message] = []
    
    var speechRecognizer:  SFSpeechRecognizer?
    //        = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    
    @IBAction func btnMicSpeechToText(_ sender: UIButton, forEvent event: UIEvent) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.mic.isEnabled = false
            self.mic.setTitle("", for: .normal)
        } else {
            self.startRecording()
            self.mic.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func setupSpeech() {
        
        self.mic.isEnabled = false
        self.speechRecognizer?.delegate = self
        
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
    
    func startRecording() {
        
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
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                self.messageTextfield.text = result?.bestTranscription.formattedString
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        let alert = UIAlertController(title: "Mời bạn chọn ngôn ngữ", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tiếng Anh 🇺🇸", style: .cancel, handler:{ _ in
            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Tiếng Việt 🇻🇳", style: .default, handler:{ _ in
            self.speechRecognizer =  SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
        
        self.setupSpeech()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        tableView.dataSource = self
        title = K.appName
        //        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        let newMessage = Message(sender: "BOT", body: "Xin chào các bạn")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        sendAction.delegate = self
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        self.audioEngine.stop()
        self.recognitionRequest = nil
        self.mic.setTitle("", for: .normal)
        self.recognitionTask?.cancel()
        self.recognitionTask = nil
        self.mic.isEnabled = true
        
        guard let mess = messageTextfield.text else {return}
        
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
        
        for item in dataIntent {
            let c =  item.patterns?.filter({ mess.lowercased().contains($0.lowercased())})
            if c?.capacity ?? 0 > 0 {
                actionResponse(item.responses ?? -1 )
            }
        }
        //        if  (mess.lowercased().contains("giỏ hàng") || mess.lowercased().contains("my cart") ){
        //            sendAction.delegate?.dataCart()
        //        }
    }
    //END SUPERVIEW
    
    func actionResponse(_ id: Int) {
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
                sendAction.delegate?.searchByManufacturer()
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
        
        if message.sender != "BOT" {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = .cyan //UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = .lightGray//UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
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
    
    func detailHistoryCart() {
        //
    }
    
    func searchByManufacturer() {
        //
    }
    
}
extension ChatBotViewController{
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
                               let tinhtrang = item.thanhtoan
                            {
                                //(Date().convertDateSQLToView(item.ngaydukien ?? "1970-01-01"))
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
                            ------------------------------\n
                            """
                            }
                        }
                        
                        let newMessage = Message(sender: "BOT", body: "        Thông tin giỏ hàng của bạn      \n     -------------------------------\n"+result)
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
}
