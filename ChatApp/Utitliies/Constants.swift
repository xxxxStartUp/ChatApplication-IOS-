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
        

    }
    struct settingsPage {
        static let userNameHeader = "userNameHeader"
        static let labelTitles = "labelTitle"
        static let statusTitleLabel = "statusTitleLabel"
    
        static var displayModeSwitch = false
    }
    struct contactsPage{
        static let UserNameHeader = "userNameHeader"
        static let emailSubHeader = "emailSubHeader"
        
    }
    struct groupInfoPage{
        static let settingsHeader = "settingsHeader"
        static let groupMemberTitleHeader = "groupMemberTitleHeader"
        static let userNameHeader = "UserNameHeader"
        static let emailHeader = "emailHeader"
        static let admin = "admin"
    }
    struct chatPage{
        static var chatToContactsSegueSignal = false
    }
    struct chatLogPage{
        static var chatLogToContactsSegueSignal = false
    }
}
