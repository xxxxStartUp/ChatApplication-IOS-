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
            
            
            //write code for load url as a message here

            if !urldetector(message: message.content.content as! String).isEmpty{
                setUpView(type: "Image")
                let url = urldetector(message: message.content.content as! String)
                messageImageView.loadImageFromGroups(urlString: url)
                if  message.sender.email != globalUser!.email{
                    leadingContstraints?.isActive = true
                    tarilingConstraints?.isActive = false
                    nameLabel.textAlignment = .left
                    timeLabel.textAlignment = .right
                     messageBackgroundView.chatPageViews(type: Constants.chatPage.leftChatBubblev)
                }else{
                    leadingContstraints?.isActive = false
                    tarilingConstraints?.isActive = true
                    nameLabel.textAlignment = .right
                    timeLabel.textAlignment = .left
                     messageBackgroundView.chatPageViews(type: Constants.chatPage.rightchatBubble)
                }

            }
            else{
            messageLabel.text = message.content.content as! String

            messageBackgroundView.backgroundColor = message.recieved ? .lightGray : .darkGray
            nameLabel.text = message.sender.name
            nameLabel.chatPageLabel(type: Constants.chatPage.senderNameLabel)
            timeLabel.text = ChatDate(date: message.timeStamp).ChatDateFormat()
            timeLabel.chatPageLabel(type: Constants.chatPage.messageTimeStamp)
            if  message.sender.email != globalUser!.email{
                leadingContstraints?.isActive = true
                tarilingConstraints?.isActive = false
                nameLabel.textAlignment = .left
                timeLabel.textAlignment = .right
                 messageBackgroundView.chatPageViews(type: Constants.chatPage.leftChatBubblev)
            }else{
                leadingContstraints?.isActive = false
                tarilingConstraints?.isActive = true
                nameLabel.textAlignment = .right
                timeLabel.textAlignment = .left
                 messageBackgroundView.chatPageViews(type: Constants.chatPage.rightchatBubble)
            }
      
            
       }
        }
    }
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Ebuka"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        return label
    }()
    
    var timeLabel : UILabel = {
         let label = UILabel()
         label.text = "10:10"
         label.backgroundColor = .clear
         label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
         
         return label
     }()
    
    

    
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
        label.backgroundColor = .clear
        return label
    }()
     lazy var stackView = UIStackView(arrangedSubviews: [nameLabel,messageBackgroundView , timeLabel])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView(type: "String")
    }

    
    
    
    func setUpView(type:String){
        
        switch type {
        case "Image":
             nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
             timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
             self.addSubview(stackView)
             self.addSubview(messageImageView)
             stackView.translatesAutoresizingMaskIntoConstraints = false
             stackView.alignment = .fill
             stackView.distribution = .fill
             stackView.axis = .vertical
             stackView.spacing = 4
             
             
             stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
             stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
             
             leadingContstraints = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
             
             tarilingConstraints = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
             
            // stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
             stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
             
             messageImageView.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 0).isActive = true
             messageImageView.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -16).isActive = true
             messageImageView.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 0).isActive = true
             messageImageView.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -16).isActive = true
        case "String":
            setUpViewDefault()
        default:
            setUpViewDefault()
        }

        
    
    }
    func setUpViewDefault(){
         nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
         timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
         self.addSubview(stackView)
         self.addSubview(messageLabel)
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.alignment = .fill
         stackView.distribution = .fill
         stackView.axis = .vertical
         stackView.spacing = 4
         
         
         stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
         
         leadingContstraints = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
         
         tarilingConstraints = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
         
        // stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
         stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
         
         messageLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 16).isActive = true
         messageLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: -16).isActive = true
         messageLabel.topAnchor.constraint(equalTo: messageBackgroundView.topAnchor, constant: 16).isActive = true
          messageLabel.bottomAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: -16).isActive = true
    }
    func urldetector(message:String) -> String{
        let input = message
        var url = String()
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else {continue}
            url = String(input[range])
            print(url,"This is the url from url detector")
        }
        return url
    }
    
    func setupImageView(){

        
    }
    




    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

