//
//  ChatCell-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatCell_Dara: UITableViewCell {

    @IBOutlet weak var userEmail: UILabel!
    

    @IBOutlet weak var messageContentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var RecivedViewOn: UIView!
    
    
    @IBOutlet weak var SentViewOn: UIView!
    
    func updateViews(){
        messageContentLabel.layer.cornerRadius = 12
     
        
    }
    
    
    var message : Message! {

         didSet {
            messageContentLabel.text = message.content.content as? String
            userEmail.text = message.sender.name
            if message.recieved{
                handleRecviedMessage()
            }else{
                hanldleSentMessage()
            }
        }
        
    }
    
    func handleRecviedMessage(){
      //  user recived the message
        
        userEmail.textAlignment = .left
        RecivedViewOn.backgroundColor = .red
        SentViewOn.backgroundColor = .clear
        timeLabel.textAlignment = .left
        
        
    }
    
    func hanldleSentMessage(){
        //user sent the message
        userEmail.textAlignment = .right
        SentViewOn.backgroundColor = .black
        RecivedViewOn.backgroundColor = .clear
        timeLabel.textAlignment = .right
        
    }
    
    
    


}
