//
//  ChatCellProgrammatic.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/11/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

import UIKit
class MessgaeCell: UITableViewCell {
    
    var leadingContstraints : NSLayoutConstraint?
    var tarilingConstraints : NSLayoutConstraint?
    
    
    var message : Message! {
        didSet{
            messageLabel.text = message.content.content as! String
            messageBackgroundView.backgroundColor = message.recieved ? .lightGray : .darkGray
            
            if  message.recieved{
                leadingContstraints?.isActive = true
                tarilingConstraints?.isActive = false
            }else{
                leadingContstraints?.isActive = false
                tarilingConstraints?.isActive = true
            }
            
            
        }
    }

    
    var messageBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        //label.backgroundColor = .green
        label.text =  """
               Called as the scene is being released by the system.
                       This occurs shortly after the scene enters the background, or when its session is discarded.
               """
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(messageBackgroundView)
        self.addSubview(messageLabel)
        self.backgroundColor = .clear
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -32).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant:  250).isActive = true
        
        
        messageBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
        messageBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor , constant: 16).isActive = true
        messageBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor , constant: 16).isActive = true
        messageBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
        
        
        //working with message constrains for incoming
        
          leadingContstraints =  messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
          tarilingConstraints =  messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        
    }
    




    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

