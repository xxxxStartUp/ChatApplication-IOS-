//
//  ramzi-FireService.swift
//  ChatApp
//
//  Created by Ramzi on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

extension FireService {
    
    /**
      Sign up a user
      - Parameter email: The user's email
      - Parameter password: The user's password.
      - Returns: true  or false for completion
        // Need to add a function to let user know there was an error
    */
    func signIn(email: String, password: String, completion : @escaping (Bool) -> ()) {
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        
            if error != nil{
                completion(false)
            }
            else{
                completion(true)
            }
            //commented off this code
//            if authResult  != nil {
//                completion(true)
//            }
        }
    }
    
    /**
      Sign out a user
      - Returns: Void
        // Need to add a function to let user know there was an error
    */
    
    func signOut() -> Void {
       do {
        
        try Auth.auth().signOut()
        
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }
    }
    
}
