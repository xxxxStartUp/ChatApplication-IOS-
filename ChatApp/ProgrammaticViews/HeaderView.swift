//
//  HeaderView.swift
//  ChatApp
//
//  Created by ebuka Daniel egbunam on 8/13/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit


class HeaderView: UIView {
    
    var headerText : String
    var headerImage : UIImage?
    private var stackView = UIStackView()
    
    lazy private var headerLabel : UILabel = {
        var label = UILabel()
        label.text = self.headerText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var headerImageView : UIImageView = {
        
        let imageView = UIImageView(image: self.headerImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    //designated initializer 
    override init(frame: CGRect) {
        self.headerText = ""
        self.headerImage = nil
        super.init(frame: frame)
        SetUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // will call designated initializer
    public convenience init(title : String , image : UIImage?) {
        self.init(frame: .zero)
        self.headerText = title
        self.headerImage = image
        
    }
    
    func SetUpView(){
        //adding stackview to view and setting to use auto layout and adding views to stackview
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(headerImageView)
        stackView.alignment = .leading
        stackView.axis = .horizontal
        
        //constarints
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        headerLabel.backgroundColor = .red
    }
    
    
}


