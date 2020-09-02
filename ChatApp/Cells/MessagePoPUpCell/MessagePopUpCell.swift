//
//  MessagePopUpCell.swift
//  ChatApp
//
//  Created by ebuka Daniel egbunam on 9/1/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class MessagePopUpCell: UITableViewCell {
    
    lazy var title : UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.text = "Save"
        return label
    }()
    
    lazy var popUpIcon : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "chat")
        return image
    }()
    
    var icon : MessagepopUp! {
        didSet{
            popUpIcon.image = icon.image
            title.text =  icon.title
            
        }
    }
    
    
    lazy var stackView = UIStackView(arrangedSubviews: [title,popUpIcon])
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setUpView()
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    func setUpView(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
         //stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        popUpIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


struct MessagepopUp {
    
    var image : UIImage
    var title : String
}
