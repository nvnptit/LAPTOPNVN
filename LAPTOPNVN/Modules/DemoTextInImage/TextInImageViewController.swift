//
//  TextInImageViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 15/11/2022.
//

import UIKit
import Vision


import VisionKit

class TextInImageViewController: UIViewController , VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextField!
    var recognizedText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takingPicture(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.textView.text = ""
                self.recognizedText = ""
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = true
                vc.delegate = self
                present(vc, animated: true)
            }
        }

}
extension TextInImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageView.image = image
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    for observation in requestResults {
                        guard let candidate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidate.string
                        self.recognizedText += "\n"
                    }
                    self.textView.text = self.recognizedText
                }
            }
        })
        textRecognitionRequest.recognitionLanguages = ["vi-VN"]
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }

}
