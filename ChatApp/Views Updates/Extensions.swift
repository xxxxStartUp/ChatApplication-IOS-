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
            self.backgroundColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
            
        case Constants.onBoardingPage.notFilledButton:
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.setTitleColor(#colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1), for: .normal)
            
        default:
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            
        }
        
    }
    func contactsPageButton(){
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.backgroundColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
    }
    
    func settingsPageButtons(){
        
        if Constants.settingsPage.displayModeSwitch == false{
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            self.setTitleColor(#colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1), for: .normal)
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        else{
            self.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            self.setTitleColor(#colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1), for: .normal)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
    }
}
extension UILabel{
    func onBoardingPageHeaderLabels(){
        self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
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
        
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.mainPage.groupNameHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
                self.adjustsFontSizeToFitWidth = true
            case Constants.mainPage.timeStamp:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 15)
                self.adjustsFontSizeToFitWidth = true
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
                self.adjustsFontSizeToFitWidth = true
            }
            
        }
        else{
            switch type {
            case Constants.mainPage.groupNameHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
                self.adjustsFontSizeToFitWidth = true
            case Constants.mainPage.timeStamp:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 15)
                self.adjustsFontSizeToFitWidth = true
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
                self.adjustsFontSizeToFitWidth = true
            }
            
        }
    }
    func newGroupPageLabels(type:String){
        
        
        switch type {
        case Constants.newGroupPage.newGroupHeader:
            self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        default:
            self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        }
        
        
    }
    func contactsPageLabels(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.contactsPage.UserNameHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            case Constants.contactsPage.emailSubHeader:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            }
        }else{
            switch type {
            case Constants.contactsPage.UserNameHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            case Constants.contactsPage.emailSubHeader:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            }
            
        }
    }
    func addContactsPageLabels(type:String){
        
        switch type {
        case Constants.newContactsPage.newContactsHeader:
            self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        default:
            self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        }
        
    }
    
    func notificationsPageLabels(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.notificationPage.timeStampHeader:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 12.5)
            case Constants.notificationPage.notificationMessage:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            default:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            }
        }
        else{
            switch type {
            case Constants.notificationPage.timeStampHeader:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 12.5)
            case Constants.notificationPage.notificationMessage:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            default:
                self.textColor = #colorLiteral(red: 0.07376488298, green: 0.5370998383, blue: 0.8941982388, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            }
        }
    }
    
    func profilePageLabels(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.profilePage.headers:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
            default:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
            }
        }
        else{
            switch type {
            case Constants.profilePage.headers:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
            default:
                self.textColor = #colorLiteral(red: 0.7763852477, green: 0.7765197158, blue: 0.7763767838, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
            }
            
        }
    }
    
    
    func settingsPageLabels(type:String){
        
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.settingsPage.userNameHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            case Constants.settingsPage.labelTitles:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
            case Constants.settingsPage.statusTitleLabel:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
        else{
            switch type {
            case Constants.settingsPage.userNameHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            case Constants.settingsPage.labelTitles:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
            case Constants.settingsPage.statusTitleLabel:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
        
    }
    func GroupInfoPageLabels(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.settingsPage.userNameHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            case Constants.settingsPage.labelTitles:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.settingsPage.statusTitleLabel:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
            
            
        }
        else{
            switch type {
            case Constants.settingsPage.userNameHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            case Constants.settingsPage.labelTitles:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
            case Constants.settingsPage.statusTitleLabel:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
        
    }
    
    
}

extension UITextField{
    
    func profilePageTextFields(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
                
            case Constants.profilePage.textfields:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            }
        }
        else{
            switch type {
                
            case Constants.profilePage.textfields:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
                
            }
        }
    }
    func newGroupPageTextField(){
        
        if Constants.settingsPage.displayModeSwitch == false{
            self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
            
        }else{
            self.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        }
    }
    func addContactPage(){
        newGroupPageTextField()
    }
    
}

extension UIView{
    
    func profilePageViews(){
        self.backgroundColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
    }
    
    func profilePageImageView(){
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        
        
    }
    func settingsPageImageView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        
    }
    func darkmodeBackground(){
        if Constants.settingsPage.displayModeSwitch {
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    func navbar(){
        if Constants.settingsPage.displayModeSwitch {
            self.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
        else{
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}




