//
//  UIView+Extension.swift
//  WiliamsGlobal
//
//  Created by Muhammad Asyraf Mohamad Fauzi on 15/10/2018.
//  Copyright © 2018 Muhammad Asyraf Mohamad Fauzi. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.3
        }, completion: completion)
    }
}

extension UIView{
    func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func addBlurEffect(_ style:UIBlurEffect.Style){
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func hide(){
        alpha = CGFloat(0)
        bounds.size.height = CGFloat(0)
    }
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}

extension UIView {
    
    func pinBackground(to stackView: UIStackView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(self, at: 0)
        self.pin(to: stackView)
    }
    
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: -8),
            trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            topAnchor.constraint(equalTo: view.topAnchor,constant: -8),
            bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 8)
            ])
    }
    func pinWith(to view: UIView,margin: CGFloat) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: margin)
            ])
    }
}
