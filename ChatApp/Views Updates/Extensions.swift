//
//  ExtensionLabel.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func onBoardingPageButton(type:String){
        
        switch type {
        case Constants.onBoardingPage.filledButton:
            self.layer.cornerRadius = 5
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            
        case Constants.onBoardingPage.notFilledButton:
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            self.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
            
        default:
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            
        }
        
        
        
    }
}
extension UILabel{
    func onBoardingPageHeaderLabels(){
        self.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 40)

    }
    func onBoardingPageSubHeaderLabels(type:String){
        
        switch type {
        case Constants.onBoardingPage.emailSubHeader:
            self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        case Constants.onBoardingPage.passwordSubHeader:
            self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        case Constants.onBoardingPage.alreadyHaveAnAccoutSubHeader:
            self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        default:
            self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        }

    }
    func chatLogPageLabels(type:String){
        
        switch type {
        case Constants.mainPage.groupNameHeader:
            self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        case Constants.mainPage.timeStamp:
            self.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        default:
            self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        }
        
    }
}
