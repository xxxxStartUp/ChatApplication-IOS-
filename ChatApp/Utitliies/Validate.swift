//
//  Validate.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit


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


extension String{
    func saveWithKey(key:String){
        let preferences = UserDefaults.standard
        preferences.set(self, forKey: key)
        let didSave = preferences.synchronize()
        if !didSave {
//            print("save Failed :\(self) key:\(key)")
        }else{
            print("saved string :\(self) key:\(key)")
        }
    }
    func loadWithKey(key: String)->String{
        if let value = UserDefaults.standard.string(forKey: key) {
//            print("load string :\(value) key:\(key)")
            return value
        }else{
//            print("load Failed : key:\(key)")
            return ""
        }
    }
    func load()->String{
        if let value = UserDefaults.standard.string(forKey: self) {
            print("load string :\(value) key:\(self)")
            return value
        }else{
            print("load Failed : key:\(self)")
            return ""
        }
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
            var user_creationDate = Date()
            if let data = self as? [String:Any]{
                if let id = data["id"] as? String{
                    user_id = id
                }
                if let name = data["name"] as? String{
                    user_name = name
                }
                if let email = data["email"] as? String{
                    user_email = email
                }
                if let deviceToken = data["deviceToken"] as? String{
                    user_token = deviceToken
                }
                if let creationDate = data["creationDate"] as? Date{
                    user_creationDate = creationDate
                }
                return FireUser.init(userID: user_id, userName: user_name, userEmail: user_email, deviceToken: user_token, creationDate: user_creationDate)
            }
            return FireUser.init(userID: user_id, userName: user_name, userEmail: user_email, deviceToken: user_token, creationDate: user_creationDate)
        }
    }
}
extension Optional {
    var asString:String{
        if let string = self as? String{
            return string
        }else{
            return ""
        }
    }
    var asInt:Int{
        if(self.asString == "" || self.asString == "<null>")
        {
            return Int(0)
        }else{
            return self.asString.toInt(defaultValue: 0)
            //            let value : Int = self as! Int
            //            return value
        }
    }
    var asBool:Bool{
        if let bool = self as? Bool{
            return bool
        }else{
            return false
        }
    }
    var asFloat:Float{
        if(self.asString == "<null>" || self.asString == ""){
            return Float(0)
        }else{
            let value : Float = self as! Float
            return value
        }
    }
    
    var asUIImage:UIImage{
        if let image = self as? UIImage{
            return image
        }else{
            return UIImage()
        }
    }
}

extension String{
    func toInt(defaultValue: Int) -> Int {
        if let n = Int(self) {
            return n
        } else {
            return defaultValue
        }
    }
    
}
