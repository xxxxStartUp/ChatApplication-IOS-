//
//  GroupChatVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class GroupChatVC: UIViewController {
    
    @IBOutlet weak var groupChatTable: UITableView!
    var cellID = "id"
    var loaded  = false
    var groupMessages : [Message] = []
    var group : Group? {
        didSet{
            title = group?.name
            loaded = true
            
        }
    }
    
    let texterView = TexterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        groupChatTable.delegate = self
        groupChatTable.dataSource = self
        groupChatTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
        self.setUptexter(texterView: texterView, controller: self)
        groupChatTable.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.groupChatTable.contentInset = insets

       
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
           loadMessages()
        
        
    }
    
    
    
    func sendMessage(){
        print("sending message to group")
        
        let content = Content(type: .string, content: "This is\(globalUser?.name ?? "no user")" + (texterView.textingView.text ?? ""))
        let message = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: false)
        FireService.sharedInstance.sendMessageToGroup(message: message, group: group!) { (result) in
            
            switch result{
                
            case .success( let bool):
                if bool {
                    print("messeage was sent ")
                    self.loadMessages()
                }
            case .failure(_):
                fatalError()
            }
        }
       
        
    }
    
    
    func loadMessages (){
        FireService.sharedInstance.loadMessagesWithGroup(user: globalUser!, group: group!) { (messages, error) in
           self.groupMessages.removeAll()
           self.groupChatTable.reloadData()
            guard let messages = messages else {return}
            print(messages.count , "this is printing is in groupvc")
            messages.forEach { (message) in
                self.groupMessages.append(message)
                print(message.content.content as! String, "this is printing in group vc")
            }
            
            
            self.groupMessages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            
            if !messages.isEmpty{
                self.groupChatTable.reloadData()
                let indexPath = IndexPath(row: self.groupMessages.count-1, section: 0)
                self.groupChatTable.scrollToRow(at:indexPath, at: .bottom, animated: true)
            }
            
        }
    }


}




extension GroupChatVC : GroupDelegate {
    func didSendGroup(group: Group) {
        self.group = group
        return
    }
    
    
}

extension GroupChatVC : TexterViewDelegate {
    func didClickSend() {
        print("send")
        sendMessage()
    }
    
    func didClickFile() {
        print("file")
    }
    
    func didClickCamera() {
        print("camera")
        
    }
    
    
}


extension GroupChatVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groupChatTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessgaeCell
        
        let message = groupMessages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    
    
    
}