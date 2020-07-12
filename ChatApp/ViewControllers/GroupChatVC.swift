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
    var groupMessages : [Message] = []
    var group : Group? {
        didSet{
            
            print("group was set")
            loadAllGroupInfo()
        }
    }
    
    let texterView = TexterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        groupChatTable.delegate = self
        groupChatTable.dataSource = self
        groupChatTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
        self.setUptexter(texterView: texterView, controller: self)

       
    }
    
    
    func loadAllGroupInfo(){
         title = group?.name
       loadMessages()
        
        
    }
    
    
    
    func sendMessage(){
        
    }
    
    
    func loadMessages (){
        self.groupMessages.removeAll()
        FireService.sharedInstance.loadMessagesWithGroup(user: globalUser!, group: group!) { (messages, error) in
           self.groupMessages.removeAll()
           self.groupChatTable.reloadData()
            guard let messages = messages else {return}
            
            messages.forEach { (message) in
                self.groupMessages.append(message)
                print(message.content.content as! String)
            }
            
            
            self.groupMessages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            
            if !messages.isEmpty{
                //self.chatTableView.reloadData()
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
    }
    
    func didClickFile() {
        print("file")
    }
    
    func didClickCamera() {
        print("camera")
        sendMessage()
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
