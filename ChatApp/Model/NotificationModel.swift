//
//  NotificationModel.swift
//  ChatApp
//
//  Created by  Muhammad Asyraf on 30/11/2020.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation

class NotificationModel    {
    var id : String
    var notification_type : String
    var user_id : String
    var user_name : String
    var user_email : String
    var dynamicLink : String
    var title : String
    var subtitle : String
    var photo_url : String
    
    var timeStamp : Date
    
    init(_ id:String,_ notification_type:String,_ user_id:String,_ user_name:String,_ user_email:String,_ dynamicLink:String,_ title:String,_ subtitle:String,_ photo_url:String,_ timeStamp:Date) {
        self.id =  id
        self.notification_type = notification_type
        self.user_id = user_id
        self.user_name = user_name
        self.user_email = user_email
        self.dynamicLink = dynamicLink
        self.title = title
        self.subtitle = subtitle
        self.photo_url = photo_url
        self.timeStamp = timeStamp
        
    }
    
}
