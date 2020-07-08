//
//  ChatVC-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC_Dara: UIViewController {
    @IBOutlet weak var chatTextView: UITextView!
    var messages = [Message]()

    
     var r : Friend?{
         didSet {
            title = r?.username
            loadMessages()
             
         }
     }
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTextView.layer.borderWidth = 0.5
        chatTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if r != nil {
            loadMessages()
        }
    }
    
    func sendMessage(){
        let messageContent = Content(type: .string, content: chatTextView.text ?? "No Value")
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
    }
    
    
    
    
    
    func loadMessages(){
            FireService.sharedInstance.loadMessagesWithFriend2(User: globalUser!,  freind: r!) { (messages, error) in
                self.messages.removeAll()
                self.chatTableView.reloadData()
                guard let messages = messages else {return}
                
                messages.forEach { (message) in
                    self.messages.append(message)
                    print(message.content.content as! String)
                }
                
                
                self.messages.sort { (message1, message2) -> Bool in
                    return message1.timeStamp < message2.timeStamp
                }
                if !messages.isEmpty{
                    self.chatTableView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                    self.chatTableView.scrollToRow(at:indexPath, at: .top, animated: true)
                    
                }
                
            }
        }
    
    
    
    
}


extension ChatVC_Dara :UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! ChatCell_Dara
        cell.updateViews()
        cell.message = messages[indexPath.row]
        return cell
        
    }
    
    //need to work on tap and hold cell
    
    
}


extension ChatVC_Dara : FreindDelegate {
    func didSendFriend(freind: Friend) {
        r = freind
    }
}
