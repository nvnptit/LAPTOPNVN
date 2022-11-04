//
//  ChatBotViewController.swift
//  LAPTOPNVN
//
//  Created by Nhat on 04/11/2022.
//

import UIKit

class ChatBotViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        let newMessage = Message(sender: "BOT", body: "Xin chào các bạn")
        self.messages.append(newMessage)
        let newMessage2 = Message(sender: "NVN", body: "Chào bạn")
        self.messages.append(newMessage2)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        //        loadMessages()
        
    }
    
    //    func loadMessages() {
    //
    //        db.collection(K.FStore.collectionName)
    //            .order(by: K.FStore.dateField)
    //            .addSnapshotListener { (querySnapshot, error) in
    //
    //            self.messages = []
    //
    //            if let e = error {
    //                print("There was an issue retrieving data from Firestore. \(e)")
    //            } else {
    //                if let snapshotDocuments = querySnapshot?.documents {
    //                    for doc in snapshotDocuments {
    //                        let data = doc.data()
    //                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
    //                            let newMessage = Message(sender: messageSender, body: messageBody)
    //                            self.messages.append(newMessage)
    //
    //                            DispatchQueue.main.async {
    //                                   self.tableView.reloadData()
    //                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
    //                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let mess = messageTextfield.text else {return}
        let newMessage = Message(sender: "NVN", body: mess)
        self.messages.append(newMessage)
        DispatchQueue.main.async {
            self.messageTextfield.text = ""
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        
        //        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
        //            db.collection(K.FStore.collectionName).addDocument(data: [
        //                K.FStore.senderField: messageSender,
        //                K.FStore.bodyField: messageBody,
        //                K.FStore.dateField: Date().timeIntervalSince1970
        //            ]) { (error) in
        //                if let e = error {
        //                    print("There was an issue saving data to firestore, \(e)")
        //                } else {
        //                    print("Successfully saved data.")
        //
        //                    DispatchQueue.main.async {
        //                         self.messageTextfield.text = ""
        //                    }
        //                }
        //            }
        //        }
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
        
        //This is a message from the current user.
        //        if message.sender == Auth.auth().currentUser?.email {
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

