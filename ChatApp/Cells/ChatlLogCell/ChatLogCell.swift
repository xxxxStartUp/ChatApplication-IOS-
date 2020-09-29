//
//  ChatLogCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import AlamofireImage

class ChatLogCell: UITableViewCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatDateLabel: UILabel!
    @IBOutlet var profileImageview: UIImageView!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    func updateViews(indexPath: Int){
        chatNameLabel.chatLogPageLabels(type: Constants.mainPage.groupNameHeader)
        chatDateLabel.chatLogPageLabels(type: Constants.mainPage.timeStamp)
//        chatNameLabel.text = "Chat \(indexPath)"
        chatDateLabel.text = "9/1\(indexPath)/20"
    
        profileImageview.chatLogImageView()
        
        print("errr")
        
        
        
    }
    
    
    var activity : Activity! {
        
        didSet{
            lastMessage.text = "No messages"
            chatDateLabel.text = "No time"
            switch activity.type {
            case .GroupChat(group:let group):
                chatNameLabel.text =  activity.name
                setUpTimeandMessageForGroup(group: group)
                FireService.sharedInstance.getGroupPictureDataFromChatLog(user: globalUser!, group: group) { (url,completion,error) in
     
                        if let url = url{
                        //                self.profileImageView.af_setImage(withURL: url)
//                        self.profileImageview.af.setImage(withURL: url)
                        self.profileImageview.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                       
                        //                    self.groupImageView.contentMode = .scaleAspectFit
                        }
                    if !completion{
                            self.profileImageview.image = UIImage(systemName: "person.crop.circle.fill")
                        }
      
                    }

                
                break
            case .FriendChat(let friend):
                setUpTimeandMessageForFriend(freind: friend)
                chatNameLabel.text =  activity.name
                
            }
            
            
        }
    }
    
    func setUpTimeandMessageForFriend(freind : Friend){
        
        FireService.sharedInstance.getLastMessageForFreind(freind: freind, user: globalUser!) { (result) in
            switch result {
            case.success(let message):
                self.chatDateLabel.text = ChatDate(date: message.timeStamp).ChatDateFormat()
                self.lastMessage.text = message.content.content as? String
            case .failure(_):
                return
            }
        }
        
    }
    
    
    func setUpTimeandMessageForGroup(group : Group){
        FireService.sharedInstance.getLastMessageForGroup(group: group, user: globalUser!) { (result) in
            switch result {
            case.success(let message):
                self.chatDateLabel.text = ChatDate(date: message.timeStamp).ChatDateFormat()
                self.lastMessage.text = message.content.content as? String
            case .failure(_):
                return
            }
        }
        
    }
    
    
    
    
}
