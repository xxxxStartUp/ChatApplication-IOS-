//
//  TexterView.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/11/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit


class TexterView : UIView, UITextViewDelegate {
    
    var delegate : TexterViewDelegate?
    
    
    let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textingView : UITextView  = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textColor = .black
        textView.isEditable = true
        textView.layer.cornerRadius = 12
        textView.isScrollEnabled = false
        return textView
        
    }()
    
    
    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(send), for: .touchUpInside)
        return button
    }()
    
    
    
    lazy var pictureButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(handleCameraSelecation), for: .touchUpInside)
        return button
    }()
    
    lazy var filesButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(named: "file"), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(handlefileSelection), for: .touchUpInside)
    
        return button
    }()
    
    
    @objc func handlefileSelection() -> Void {
        delegate?.didClickFile()
    }
    
    @objc func send() -> Void {
        delegate?.didClickSend()
    }
    
    
    
    @objc func handleCameraSelecation() -> Void {
        delegate?.didClickCamera()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [sendButton, pictureButton , filesButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        textingView.delegate = self
        addSubview(backgroundView)
        addSubview(textingView)
        addSubview(stackView)
        
        let constaints = [
            stackView.widthAnchor.constraint(equalToConstant: 130),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            textingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            textingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            textingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            textingView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -25),
            textingView.heightAnchor.constraint(equalToConstant: 35),
            
            
            backgroundView.leadingAnchor.constraint(equalTo: textingView.leadingAnchor , constant: -25),
            backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            backgroundView.topAnchor.constraint(equalTo: textingView.topAnchor, constant: -16),
            backgroundView.bottomAnchor.constraint(equalTo: textingView.bottomAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constaints)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        print("editing")
        var width : CGFloat = 0
        textView.isScrollEnabled = false
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        guard let text = textView.text  else {return}
        textView.constraints.forEach { (c) in
            if c.firstAttribute == .width{
                width = c.constant
            }
        }
        var height = text.height(withConstrainedWidth: width + 10, font: textView.font!)
        
        
        textView.constraints.forEach { (c) in
            if c.firstAttribute == .height{
                if c.constant < 100{
                    c.constant = height + 30//estimatedSize.height + 5
                    textView.isScrollEnabled = false
                }else{
                    textView.isScrollEnabled = true
                }
                
                
            }
        }
    }
    


}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}


