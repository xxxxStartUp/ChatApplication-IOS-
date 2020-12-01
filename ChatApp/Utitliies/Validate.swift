//
//  Validate.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit
import SafariServices


class Validate {
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        // validates passowrd
        
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
//        return passwordTest.evaluate(with: password)
        
        return true
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        // validates email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
    
    
    
}

// MARK :- Optional
extension Optional{
    
    var toFireUser : FireUser{
        if let currentUser = self as? FireUser{
            return currentUser
        }else{
            var user_id = ""
            var user_name = ""
            var user_email = ""
            var user_token = ""
            var profile_ImageUrl = ""
            var user_status = ""
            var user_creationDate = Date()
            if let data = self as? [String:Any]{
                if let id = data["id"] as? String{
                    user_id = id
                }else{
                    print("failed to get id")
                }
                if let name = data["name"] as? String{
                    user_name = name
                }else{
                    print("failed to get name")
                    if let name = data["username"] as? String{
                        user_name = name
                    }else{
                        print("failed to get username")
                    }
                }
                if let email = data["email"] as? String{
                    user_email = email
                }else{
                    print("failed to get email")
                }
                if let deviceToken = data["deviceToken"] as? String{
                    user_token = deviceToken
                }else{
                    print("failed to get deviceToken")
                }
                if let status = data["status"] as? String{
                    user_status = status
                }else{
                    print("failed to get status")
                }
                if let creationDate = data["creationDate"] as? Date{
                    user_creationDate = creationDate
                }else{
                    print("failed to get creationDate")
                }
                if let profileImageUrl = data["profileImageUrl"] as? String{
                    profileImageUrl.saveWithKey(key: "profileImageUrl")
                    profile_ImageUrl = profileImageUrl
                }
                return FireUser.init(userID: user_id, token: user_token, userName: user_name, userEmail: user_email,profileImageUrl: profile_ImageUrl,status: user_status, creationDate: user_creationDate)
            }
            return FireUser.init(userID: user_id, token: user_token, userName: user_name, userEmail: user_email,profileImageUrl: profile_ImageUrl,status: user_status, creationDate: user_creationDate)
        }
    }
}

extension UIViewController{
    func openURLInApp(request: String){
        let shareString = "\(request)"
        let url = URL(string: shareString)!
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
}
extension UIViewController{ //keyboardHandler
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    //Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func KeyboardDismiss(_ sender: Any) {
        dismissKeyboard()
    }
}

extension Date{
    func DateConvert(_ newFormat:String)-> String{
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = newFormat
        return formatter.string(from: self)
    }
    func next(day:Int)->Date{
        var dayComponent    = DateComponents()
        dayComponent.day    = day
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        return nextDate!
    }
    func past(day:Int)->Date{
        var pastCount = day
        if(pastCount>0){
            pastCount = day * -1
        }
        var dayComponent    = DateComponents()
        dayComponent.day    = pastCount
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        return nextDate!
    }
}
