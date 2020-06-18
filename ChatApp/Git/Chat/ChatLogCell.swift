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
        
            chatNameLabel.text = "Chat \(indexPath)"
            chatDateLabel.text = "9/1\(indexPath)/20"
        

        
    }
    
}
