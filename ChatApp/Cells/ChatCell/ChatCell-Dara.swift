//
//  ChatCell-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatCell_Dara: UITableViewCell {

    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightTimeStamp: UILabel!
    @IBOutlet weak var rightNameHeader: UILabel!
    @IBOutlet weak var rightChatBubble: UIView!
    @IBOutlet weak var leftNameHeader: UILabel!
    @IBOutlet weak var leftChatBubbl: UIView!
    @IBOutlet weak var leftTimeStamp: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    func updateViews(){
        
        rightLabel.text = "HAHAHAHAHHAHAHA"
        rightNameHeader.text = "Daramfon Akpan"
        rightTimeStamp.text = "10.44PM"
        leftLabel.text = "Nope you got me"
        leftNameHeader.text = "Ebuka EGB"
        leftTimeStamp.text = "10.55PM"
        
        leftStackView.isHidden = false
        rightChatBubble.layer.cornerRadius = 10
        leftChatBubbl.layer.cornerRadius = 10
        
    }
    
    
    
    


}
