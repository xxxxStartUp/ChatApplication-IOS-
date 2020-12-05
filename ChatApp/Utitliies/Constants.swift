//
//  Constants.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/20/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit
struct Constants{
    //identifiers
    
    static let mainTabStoryBoardSegue = "mainTabSBIdentifier"
    static let loginTabStoryBoardSegue = "loginSBIdentifier"
    static let settingsToProfileIdentifer = "settingstoprofileIdentifier"
    static let groupchatSBToGroupInfoIdentifier = "GroupInfoIdentifier"
    
    static let groupImagesType = "groupImageType"
    static let deviceTokenKey = "deviceTokenKey"
    
    
    struct onBoardingPage{
        static let filledButton = "filled"
        static let notFilledButton = "noFill"
        static let emailSubHeader = "email"
        static let nameSubHeader = "name"
        static let passwordSubHeader = "password"
        static let alreadyHaveAnAccoutSubHeader = "alreadyHaveAnAccount"
    }
    
    struct mainPage{
        static let groupNameHeader = "groupNameHeader"
        static let timeStamp = "timeStamp"
        static let messagesubHeader = "messageSubHeadercl"
        
    }
    struct newGroupPage {
        static let newGroupHeader = "newGroupHeader"
        static let lineSeparator = "separator"
    }
    struct newContactsPage {
        static let newContactsHeader = "newContactsHeader"
        static let filledButton = "filled"
        static let lineSeparator = "separator"
        
    }
    struct notificationPage{
        static let timeStampHeader = "newContactsHeader"
        static let notificationMessage = "notificationsMessage"
        static let notificationHeader = "notificationHeader"
        static let indicator = "indicatorView"
    }
    struct Identifiers{
        static let notificationsCellIdentifier = "notificationsCell"
        
        
    }
    
    struct profilePage {
        static let headers = "Headers"
        static let textfields = "Textfields"
        static var profileImageState = false
        static var globalProfileImage:UIImage? = nil
        static let profileImageType = "profileImageType"
        

    }
    struct settingsPage {
        static let userNameHeader = "userNameHeader"
        static let labelTitles = "labelTitle"
        static let statusTitleLabel = "statusTitleLabel"
        static let settingsImageType = "settingsImageType"
       static var displayModeSwitch = false
        
        //UserDefaults.standard.value(forKey: "displayModeSwitch") as Bool
        static var displaySwitch:UISwitch?
    }
    struct contactsPage{
        static let UserNameHeader = "userNameHeader"
        static let emailSubHeader = "emailSubHeader"
        
    }
    struct selectedContactsPage{
        static var fromGroupChatVCIndicator = false
        static var fromChatLogIndicator = false
        
    }
    struct groupInfoPage{
        static let settingsHeader = "settingsHeader"
        static let groupMemberTitleHeader = "groupMemberTitleHeader"
        static let userNameHeader = "UserNameHeader"
        static let emailHeader = "emailHeader"
        static let admin = "admin"
        static var groupImageState = false
        static var globalGroupImage:UIImage? = nil
        static let GroupImageType = "groupImageType"
    }
    struct chatPage{
        static let leftChatBubblev = "LeftChatBubble"
        static let rightchatBubble = "RightChatBubble"
        static let senderNameLabel = "SenderNameLabel"
        static let messageTimeStamp = "MessageTimeStamp"
        static let groupImagesType = "groupchatImageType"
        static var uploadTaskProgressIndicator = false
    }
    struct chatLogPage{
        static var chatLogToContactsSegueSignal = false
        static let ChatLogImageType = "chatLogImageType"
    }
    
}
