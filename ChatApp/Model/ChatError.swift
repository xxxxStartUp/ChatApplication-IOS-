//
//  ChatError.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

struct ChatError : Error{
    
    
    enum AuthenticationError : String, Error {
        case invalidUsername = "This User name is Invalid"
        
    }
    
    
    enum MessagingError : String , Error {
        case couldNotSendMessge = "This message could not be sent"
    }
    
}


