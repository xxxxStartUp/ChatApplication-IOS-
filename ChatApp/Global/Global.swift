//
//  Global.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/29/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit

var globalUser : FireUser?

extension UIViewController {
    // to user this just type: let user = UIViewController.user
    
    var user : FireUser? {
        return  globalUser
    }
    
    func refreshCurrentUser(){
        FireService.sharedInstance.getCurrentUserData(email: globalUser.toFireUser.email) { (fireUser, error) in
            if let currentUser = fireUser{
                globalUser = currentUser
            }
        }
    }
    func checkForUser(){
        FireService.sharedInstance.getCurrentUser { (user) in
            if let email = user?.email{
                print("email:IS \(email)")
                FireService.sharedInstance.getCurrentUserData(email: email) { (fireUser, error) in
                    if let fireUser = fireUser{
                        globalUser = fireUser
                        self.goToTab()
                    }else{
                        self.goToLogin()
                    }
                }
            }else{
                self.goToLogin()
            }
        }
    }
    

}


