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
    
    @IBOutlet weak var chatSenderNameLabel: UILabel!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatDateLabel: UILabel!
    @IBOutlet var profileImageview: UIImageView!
    
//    @IBOutlet weak var lastMessage: UILabel!
    
    func updateViews(indexPath: Int){
        chatDateLabel.chatLogPageLabels(type: Constants.mainPage.timeStamp)
        chatNameLabel.chatLogPageLabels(type: Constants.mainPage.groupNameHeader)
//        lastMessage.chatLogPageLabels(type: Constants.mainPage.messagesubHeader)
        chatNameLabel.text = "Chat \(indexPath)"
        chatDateLabel.text = "9/1\(indexPath)/20"
        contentView.darkmodeBackground()
        profileImageview.chatLogImageView()
        print("errr")
    }
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    var activity : Activity! {
        
        didSet{
            chatSenderNameLabel.text = ""
//            lastMessage.text = "No messages"
            chatDateLabel.text = ""
                switch activity.type {
                    case .GroupChat(group:let group):
                        chatNameLabel.text =  activity.name
                        setUpTimeandMessageForGroup(group: group)
                        FireService.sharedInstance.getGroupPictureDataFromChatLog(user: globalUser.toFireUser, group: group) { (url,completion,error) in
             
                                if let url = url{
                                //                self.profileImageView.af_setImage(withURL: url)
        //                        self.profileImageview.af.setImage(withURL: url)
                                self.profileImageview.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                               
                                //                    self.groupImageView.contentMode = .scaleAspectFit
                                }
                            if !completion{
                                    self.profileImageview.image = UIImage(systemName: "person.2")
        //                            self.profileImageview.image = UIImage(systemName: "person.crop.circle.fill")
                                }
              
                            }
                        break
                    case .FriendChat(let friend):
                        setUpTimeandMessageForFriend(freind: friend)
                        chatNameLabel.text =  activity.name
                        FireService.sharedInstance.getFriendPictureData(user: globalUser.toFireUser, friend: friend) { (result) in
                            
                            switch result{

                            case .success(let url):
                                self.profileImageview.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                            case .failure(_):
                                print("failed to set image url")
                            }

                        }
                        break
                }
        }
    }
    
    
    func setUpTimeandMessageForFriend(freind : Friend){
        
        FireService.sharedInstance.getLastMessageForFreind(freind: freind, user: globalUser.toFireUser) { (result) in
            switch result {
            case.success(let message):
                self.chatDateLabel.text = ChatDate(date: message.timeStamp).ChatDateFormat()
                let user = message.sender.name
                let messageContent = message.content.content
                self.chatSenderNameLabel.text = "\(messageContent)"
//                self.lastMessage.text = "\(messageContent)"
            case .failure(_):
                return
            }
        }
        
    }
    
    
    func setUpTimeandMessageForGroup(group : Group){
        FireService.sharedInstance.getLastMessageForGroup(group: group, user: globalUser.toFireUser) { (result) in
            switch result {
            case.success(let message):
                self.chatDateLabel.text = ChatDate(date: message.timeStamp).ChatDateFormat()
                let user = message.sender.name
                let messageContent = message.content.content
                self.chatSenderNameLabel.text = "\(user): \(messageContent)"
//                self.lastMessage.text = "\(messageContent)"
            case .failure(_):
                return
            }
        }
        
    }
    
    
    
    
}
