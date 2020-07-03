//
//  ChatCell-ebuka.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/22/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatCell_ebuka: UITableViewCell {
    
    
    @IBOutlet weak var messageContent: UILabel!
    
    @IBOutlet weak var senderView: UIView!
    
    
    @IBOutlet weak var recieverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var message : Message! {
        
        didSet {
            messageContent.text = message.content.content as! String
            
            
            if message.recieved{
                //user recived the message
                senderView.backgroundColor = .clear
                recieverView.backgroundColor = .red
            }else{
                //user sent the message
                senderView.backgroundColor = .black
                recieverView.backgroundColor = .clear
            }
        }
        
        
    }

}
