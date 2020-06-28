//
//  FireService.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore



// this class connects to firebase
class FireService {
    static let db = Firestore.firestore()
    
    
    static let users = db.collection("users")
    
     static let sharedInstance = FireService()
    
    
    
    func addData(user : FireUser , data : [String : Any] , completion : @escaping (Error? , Bool) -> ()) {
        
        
        FireService.users.document(user.email).setData(data, merge: true) { (error) in
            
            if let error = error{
                completion(error , false)
                return
            }
            //UserDefaults.standard.set(user, forKey: "user")

            completion(nil , true)
        }
        
    }
    
    
    
    
}



