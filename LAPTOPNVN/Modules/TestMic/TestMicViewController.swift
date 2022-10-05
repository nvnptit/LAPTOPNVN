//
//  TestMicViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 05/10/2022.
//

import UIKit
import Speech
import AVKit


class TestMicViewController: UIViewController {

    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Outlets
    //------------------------------------------------------------------------------

    @IBOutlet weak var btnStart: UIButton!
  
    @IBOutlet weak var lblText: UILabel!
    var timerz = Timer()
    var time = 5
    var isTimeOut = false
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Variables
    //------------------------------------------------------------------------------

    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN"))

    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()


    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Action Methods
    //------------------------------------------------------------------------------

    
    @IBAction func btnStartSpeechToText(_ sender: UIButton, forEvent event: UIEvent) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.btnStart.isEnabled = false
            self.btnStart.setTitle("Start Recording", for: .normal)
        } else {
            self.time = 5
            self.startRecording()
            self.btnStart.setTitle("Stop Recording", for: .normal)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                 if self.time > 0 {
                     print ("\(self.time) seconds")
                     self.time -= 1
                 } else {
                     self.audioEngine.stop()

                     self.recognitionRequest = nil
                     self.btnStart.setTitle("Start Recording", for: .normal)
                     self.recognitionTask?.cancel()
                     self.recognitionTask = nil
                     self.btnStart.isEnabled = true
                     Timer.invalidate()
                 }
             }
        }
    }
    


    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Custom Methods
    //------------------------------------------------------------------------------

    func setupSpeech() {

        self.btnStart.isEnabled = false
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
            }

            OperationQueue.main.addOperation() {
                self.btnStart.isEnabled = isButtonEnabled
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
                self.lblText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal || self.time == 0{
                print("KẾT THÚC")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.btnStart.setTitle("Start Recording", for: .normal)
                self.recognitionTask?.cancel()
                self.recognitionTask = nil
                self.btnStart.isEnabled = true
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

        self.lblText.text = "Say something, I'm listening!"
    }


    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- View Life Cycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSpeech()
    }
}


//------------------------------------------------------------------------------
// MARK:-
// MARK:- SFSpeechRecognizerDelegate Methods
//------------------------------------------------------------------------------

extension TestMicViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnStart.isEnabled = true
        } else {
            self.btnStart.isEnabled = false
        }
    }
}
