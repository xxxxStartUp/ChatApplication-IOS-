//
//  Message.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/17/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation


class Message  : Messaging  {
    var id : String
    var content : Content
    var sender : FireUser
    var timeStamp : Date
    var recieved : Bool
    
    init(content : Content , sender : FireUser , timeStamp : Date , recieved : Bool) {
        self.recieved = recieved
        self.id = UUID().uuidString
        self.content = content
        self.sender = sender
        self.timeStamp = timeStamp
        
        
    }
    
}


struct Content  {
    
    var type : ContentType
    var content : Any
}

enum ContentType  {

    
    case string
    case video
    case file
    case image
    
    
    var rawValue: String {
        switch self {
        case .string:
            return "string"
        case .video:
            return "video"
        case .file:
            return "file"
        case .image:
            return "image"
        }
    }
    
}
