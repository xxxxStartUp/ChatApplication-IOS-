//
//  ChatVC-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC_Dara: UIViewController  {
    var messages = [Message]()
    var hasScrolled : Bool = false
    var cellId = "id"
    var r : Friend?{
         didSet {
            title = r?.username
            loadMessages()
         }
     }
    
    /*func dummy() {
        
        let content = Content(type: .string, content: "first saved message")
        let message = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: true)
        
        FireService.sharedInstance.saveMessages(user: globalUser!, messageToSave: message) { (result) in
            switch result{
                
            case .success(_):
                print("Successfully saved messages")
            case .failure(_):
                fatalError()
            }
        }
    }*/
    

    let texterView = TexterView()
    
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(MessgaeCell.self, forCellReuseIdentifier: cellId)
        self.setUptexter(texterView: texterView, controller: self)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.chatTableView.contentInset = insets
        //dummy()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if r != nil {
            loadMessages()
        }
    }
    
    func sendMessage(){
        let messageContent = Content(type: .string, content: texterView.textingView.text ?? "No Value")
        let dummyMessage = Message(content: messageContent, sender: globalUser!, timeStamp: Date(), recieved: false)
        FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: dummyMessage, freind: r!) { (sucess, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if sucess{
//                let controller = UIAlertController.alertUser(title: "you sent a message", message: "sucess", whatToDo: "check firebase")
//                self.present(controller, animated: true, completion: nil)
                print("sent message in chat_vc dara")
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
                self.chatTableView.scrollToRow(at:indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    
    
    
    
    
}


extension ChatVC_Dara :UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessgaeCell
        cell.message = messages[indexPath.row]
        return cell
        
    }
}


extension ChatVC_Dara : FreindDelegate {
    func didSendFriend(freind: Friend) {
        r = freind
    }
}


extension ChatVC_Dara : TexterViewDelegate {
    func didClickSend() {
        print("send")
        sendMessage()
    }
    
    func didClickFile() {
        print("file")
    }
    
    func didClickCamera() {
        print("open camera")
        
    }
}


extension UIViewController {
    
    
    
    func setUptexter<T : UIViewController>(texterView : TexterView , controller : T  ) -> Void where T : TexterViewDelegate  {
        texterView.translatesAutoresizingMaskIntoConstraints = false
        let view = controller.view!
        texterView.translatesAutoresizingMaskIntoConstraints = false
        texterView.delegate = controller
        //hides tab bar
        //self.tabBarController?.tabBar.isHidden = true
        //adding programmatic texterView
        view.addSubview(texterView)
        texterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        texterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        texterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}


//class MessageView : UIView {
//
//    lazy var messageBubble : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .black
//        return view
//    }()
//
//
//    lazy var  messageText : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = true
//        label.text = "This is a message"
//        label.backgroundColor = .red
//        return label
//    }()
//
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.layer.cornerRadius = 12
//        self.backgroundColor = .green
//        self.addSubview(messageBubble)
//        self.addSubview(messageText)
//
//        let constraints  =
//        [
//            messageBubble.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            messageBubble.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
//            messageBubble.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: 0),
//            messageBubble.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
//
//            messageText.topAnchor.constraint(equalToSystemSpacingBelow: messageBubble.topAnchor, multiplier: 20),
//            messageText.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 10),
//            messageText.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: 10)
//
//
//
//        ]
//
//
//
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//
//}







