//
//  Global.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/29/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit

var globalUser : FireUser? {
    didSet{
        if globalUser != nil{
            globalUser.toFireUser.email.saveWithKey(key: "email")
            FireService.sharedInstance.updateDeviceToken(globalUser.toFireUser.email, "deviceToken".load()) { (error, isSuccess) in
                if(isSuccess){
                    print("Global user push notification token register success")
                }else{
                    print("Global user push notification token register failed")
                }
            }
        }
    }
}
