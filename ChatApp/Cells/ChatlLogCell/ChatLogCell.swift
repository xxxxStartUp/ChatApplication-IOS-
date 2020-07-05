//
//  ChatLogCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatLogCell: UITableViewCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatDateLabel: UILabel!
    
    func updateViews(indexPath: Int){
        chatNameLabel.chatLogPageLabels(type: Constants.mainPage.groupNameHeader)
        chatDateLabel.chatLogPageLabels(type: Constants.mainPage.timeStamp)
//        chatNameLabel.text = "Chat \(indexPath)"
        chatDateLabel.text = "9/1\(indexPath)/20"
        
        
        
    }
    
    
    var activity : Activity! {
        
        didSet{
            switch activity.type {
            case .GroupChat:
                chatNameLabel.text =  "Group : \(activity.name)"
                break
            case .FriendChat:
                chatNameLabel.text =  "Chat : \(activity.name)"
                
            }
            
            
        }
    }
    
}
