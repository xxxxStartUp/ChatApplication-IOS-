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
                print(error?.localizedDescription)
                return
            }
            else{
                completion(true)
            }

        }
    }
    
    
    
    
    func createGroup(group : Group ,completion : @escaping (Bool , Error?) -> () ){
        let data = ["grouppname":group.name, "groupadmin" : group.GroupAdmin.email]
        
        

        FireService.users.document(group.GroupAdmin.email).collection(group.name).document(group.name).setData(data, merge: true) { (error) in
            
            
            if let error = error {
                completion(false , error)
                return
            }
            completion(true, nil)
            
        
        }
        
        
        
    }
    
    func deleteGroup (group: Group){
        
        FireService.db.collection("users").document(group.GroupAdmin.email).collection(group.name).document(group.name).delete()
    }
    


}
