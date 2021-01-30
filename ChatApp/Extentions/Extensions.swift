//
//  ExtensionLabel.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
let cachedImage = NSCache<NSString,UIImage>()

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
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.settingsPage.statusTitleLabel:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
        
    }
    func chatPageLabel(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.chatPage.senderNameLabel:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            case Constants.chatPage.messageTimeStamp:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
            }
        }
            else{
            switch type {
            case Constants.chatPage.senderNameLabel:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            case Constants.chatPage.messageTimeStamp:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            default:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
            }
            }
        
    }
    func GroupInfoPageLabels(type:String){
        if Constants.settingsPage.displayModeSwitch == false{
            switch type {
            case Constants.groupInfoPage.settingsHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.groupInfoPage.userNameHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.groupInfoPage.groupMemberTitleHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            case Constants.groupInfoPage.emailHeader:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            case Constants.groupInfoPage.admin:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            default:
                self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
            
            
        }
        else{
            switch type {
            case Constants.groupInfoPage.settingsHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.groupInfoPage.userNameHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            case Constants.groupInfoPage.groupMemberTitleHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            case Constants.groupInfoPage.emailHeader:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            case Constants.groupInfoPage.admin:
                self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.font = UIFont(name: "HelveticaNeue-Light", size: 10)
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
    func groupInfoTextField(){
        if Constants.settingsPage.displayModeSwitch == false{
            self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            
        }else{
            self.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
        }
        
    }


    
}

extension UIView{
    
    func profilePageViews(){
        self.backgroundColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
    }
    
    func profilePageImageView(){
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    func newGroupImageView(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
    }
    func chatLogImageView(){
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    func settingsPageImageView(){
        
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
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
    func texterViewBackground(){
        if Constants.settingsPage.displayModeSwitch {
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else{
            self.backgroundColor = #colorLiteral(red: 0.9761944413, green: 0.976330936, blue: 0.9761514068, alpha: 1)
        }
    }
    func chatPageViews(type:String){
        
        switch type {
        case Constants.chatPage.leftChatBubblev:
            self.backgroundColor = #colorLiteral(red: 0.7176470588, green: 0.9333333333, blue: 0.1333333333, alpha: 1)
        case Constants.chatPage.rightchatBubble:
            self.backgroundColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
        default:
             self.backgroundColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
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

extension UIImageView{
    
    
    func loadImages(urlString:String,mediaType:String){
            
        switch mediaType {
        case Constants.profilePage.profileImageType:
                self.image = nil
                
                //check cache for image
                if let cachedImage = cachedImage.object(forKey: urlString as NSString){
                    self.image = cachedImage
                    return
                }
                
                //otherwise fire off a new download

                if let url =
                    URL(string:urlString){
                    print(url,"URL")
                    
                    self.af.setImage(withURL: url, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true) { (reponse) in

                        switch reponse.result {
                        case .success(let image):
                            self.image = image
                            self.isUserInteractionEnabled = true
                            Constants.profilePage.profileImageState = true
                            Constants.profilePage.globalProfileImage = image
                            cachedImage.setObject(image, forKey: urlString as NSString)
                        case .failure(let error):
                            print(error.localizedDescription)
                             self.isUserInteractionEnabled = true

                        }

                    }
            }
        case Constants.chatPage.groupImagesType:
            defaultLoadImageFromGroup(urlString: urlString)
            
        case Constants.settingsPage.settingsImageType:
            self.settingsPageImageView()
            self.image = nil
            
            //check cache for image
            if let cachedImage = cachedImage.object(forKey: urlString as NSString){
                self.image = cachedImage
                return
            }
            
            //otherwise fire off a new download

            if let url =
                URL(string:urlString){
                print(url,"URL")
                
                self.af.setImage(withURL: url, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true) { (reponse) in

                    switch reponse.result {
                    case .success(let image):
                        self.image = image
                        
                        
                        cachedImage.setObject(image, forKey: urlString as NSString)
                    case .failure(let error):
                        print(error.localizedDescription)

                    }

                }
                
            }
        case Constants.groupInfoPage.GroupImageType:
                self.image = nil
                
                //check cache for image
                if let cachedImage = cachedImage.object(forKey: urlString as NSString){
                    self.image = cachedImage
                    return
                }
                
                //otherwise fire off a new download

                if let url =
                    URL(string:urlString){
                    print(url,"URL")
                    
                    self.af.setImage(withURL: url, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true) { (reponse) in

                        switch reponse.result {
                        case .success(let image):
                            self.image = image
                            self.isUserInteractionEnabled = true
                            Constants.groupInfoPage.groupImageState = true
                            Constants.groupInfoPage.globalGroupImage = image
                            cachedImage.setObject(image, forKey: urlString as NSString)
                        case .failure(let error):
                            print(error.localizedDescription)
                             self.isUserInteractionEnabled = true

                        }

                    }
            }
            
        default:
            defaultLoadImageFromGroup(urlString: urlString)
        
            }}
    func defaultLoadImageFromGroup(urlString:String){
        self.image = nil
        
        //check cache for image
        if let cachedImage = cachedImage.object(forKey: urlString as NSString){
            self.image = cachedImage
            self.contentMode = .scaleAspectFill
            return
            
        }
        //otherwise fire off a new download

        if let url =
            URL(string:urlString){
            print(url,"URL")
            
            self.af.setImage(withURL: url, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: true) { (reponse) in

                switch reponse.result {
                case .success(let image):
                    self.image = image
                    self.contentMode = .scaleAspectFill
                    
                    cachedImage.setObject(image, forKey: urlString as NSString)
                case .failure(let error):
                    print(error.localizedDescription)

                }

            }
        }}
    
    func clearCachedImage(url:String){
    
        cachedImage.removeObject(forKey: url as NSString)
    }
    
    func thumbnailImageForFileUrl(fileUrl:NSURL){
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
//        var properties = [String:Any]()
        
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
        
            let thumbnailImage = UIImage(cgImage: thumbnailCGImage)
            self.image = thumbnailImage
        } catch let err {
            print(err)
        }
        
    }

}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}

extension UIViewController {
    // DARA PLEASE TAKE A LOOK AT THIS
    enum userStrings : String{
        typealias RawValue = String
        case currentUser = "CurrentUser"
    }
    
    var currentUser : FireUser? {
        // use this to get current user any where as long as user has been saved
        return getCurrentUserFromDisk()
    }
    
    func getCurrentUserFromDisk () -> FireUser? {
        let dict = UserDefaults.standard.dictionary(forKey: userStrings.currentUser.rawValue)
        guard let unWrappedDict = dict else {
            return nil
            
        }
        let user = FireService.sharedInstance.changeDictionaryToFireUser(data: unWrappedDict)
        return user
        
    }
    
    func saveCurrentUserToDisk(user : FireUser) {
        //add to signup and sign in functions
        let dict = FireService.sharedInstance.changeUserToDictionary(user)
        UserDefaults.standard.set(dict, forKey: userStrings.currentUser.rawValue)
        UserDefaults.standard.synchronize()
        
    }
    
    func deleteCurrentUserFromDisk(){
        // add to signOut Function
        UserDefaults.standard.removeObject(forKey: userStrings.currentUser.rawValue)
    }
    
    
    func reSaveUserToDisk(user : FireUser){
        //call if you change something about a user
        saveCurrentUserToDisk(user: user)
    }
}



