//
//  ChatBotViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 04/11/2022.
//

import UIKit
import Speech
import AVKit


class ChatBotViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var mic: UIButton!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageViewBottomConstraints: NSLayoutConstraint!
    
    var messages: [Message] = []
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Variables
    //------------------------------------------------------------------------------
    
//    var timerz = Timer()
//    var time = 5
//    var isTimeOut = false
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))
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
//            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
//                 if self.time > 0 {
//                     print ("\(self.time) seconds")
//                     self.time -= 1
//                 } else {
//                     self.audioEngine.stop()
//
//                     self.recognitionRequest = nil
//                     self.mic.setTitle("Start Recording", for: .normal)
//                     self.recognitionTask?.cancel()
//                     self.recognitionTask = nil
//                     self.mic.isEnabled = true
//                     Timer.invalidate()
//                 }
//             }
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

        self.messageTextfield.text = "Say something, I'm listening!"
    }


    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- View Life Cycle Methods
    //------------------------------------------------------------------------------



    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        self.setupSpeech()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        let newMessage = Message(sender: "BOT", body: "Xin chào các bạn")
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
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
