//
//  ChatVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/22/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var ChatTable: UITableView!
    
    @IBOutlet weak var messageStackview: UIStackView!
    
    @IBOutlet weak var messageView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    let identifier = "ChatCell"
    
    var messages = [Message]()
    
    var r : Friend? {
        
        didSet {
            
            title = r?.username
            
        }
    }
    
    override func viewDidLoad() {
        messageView.delegate = self
        super.viewDidLoad()
        setUpTableView()
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMessages()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //loadMessages()
    }
    
    func loadMessages(){

        FireService.sharedInstance.loadMessagesWithFriend2(User: globalUser!,  freind: r!) { (messages, error) in
            self.messages.removeAll()
            self.ChatTable.reloadData()
            guard let messages = messages else {return}
            
            messages.forEach { (message) in
                self.messages.append(message)
                print(message.content.content as! String)
            }
            
            
            self.messages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            if !messages.isEmpty{
                self.ChatTable.reloadData()
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
               self.ChatTable.scrollToRow(at:indexPath, at: .top, animated: true)
                return
            }
            
        }
    }
    
    
    func setUpTableView() -> Void {
        ChatTable.delegate = self
        ChatTable.dataSource = self
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let messageContent = Content(type: .string, content: messageView.text
        )
        let dummyMessage = Message(content: messageContent, sender: globalUser!, timeStamp: Date(), recieved: false)
        
        FireService.sharedInstance.sendMessagefinal(User: globalUser!, message: dummyMessage, freind: r!) { (sucess, error) in
            
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            
            if sucess{
                let controller = UIAlertController.alertUser(title: "you sent a message", message: "sucess", whatToDo: "check firebase")
                self.present(controller, animated: true, completion: nil)
                
            }
            
            
            
        }
        
        
        //        FireService.sharedInstance.SendMessage(User: globalUser!, message: dummyMessage, freind: r!) { (sucess, error) in
        //
        //
        //            if let error = error {
        //                fatalError(error.localizedDescription)
        //            }
        //
        //            if sucess{
        //                let controller = UIAlertController.alertUser(title: "you sent a message", message: "sucess", whatToDo: "check firebase")
        //                self.present(controller, animated: true, completion: nil)
        //            }
        //        }
    }
    
    
}

extension ChatVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = ChatTable.dequeueReusableCell(withIdentifier: identifier) as? ChatCell_ebuka {
            cell.message = messages[indexPath.row]
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    
    
}

extension ChatVC : FreindDelegate {
    func didSendFriend(freind: Friend) {
        r = freind
    }
}


extension ChatVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        //
        //        let size = CGSize(width: 1000.0, height: .infinity)
        //        messageView.frame.height = size.height
    }
    
}
