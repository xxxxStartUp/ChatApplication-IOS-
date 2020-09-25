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
            switch activity.type {
            case .GroupChat(group:let group):
                chatNameLabel.text =  activity.name
                
                FireService.sharedInstance.getGroupPictureData(user: globalUser!, group: group) { (result) in
                   
                    switch result{
                        
                    case .success(let url):
                        //                self.profileImageView.af_setImage(withURL: url)
                        self.profileImageview.af.setImage(withURL: url)
                       // self.profileImageview.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                       
                        //                    self.groupImageView.contentMode = .scaleAspectFit
                        
                    case .failure(_):
                        print("failed to set image url")
                    }

                }
                break
            case .FriendChat:
                chatNameLabel.text =  activity.name
                
            }
            
            
        }
    }
    
}
