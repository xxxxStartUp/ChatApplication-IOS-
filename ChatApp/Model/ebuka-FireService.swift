//
//  ebuka-FireService.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


extension FireService {
    /**
        Signs up  a user

        - Parameter email:  the email to signUp with
        - Parameter password: the passowrd of the user
        - Returns: Void
    */
    func SignUp(email : String , password : String, completion : @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                completion(false)
                return
            }
            
            guard result != nil else {
                completion(true)
                return
            }
        }
    }
    
    
}
