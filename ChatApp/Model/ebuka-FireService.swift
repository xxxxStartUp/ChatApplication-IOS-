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
    
    func addFriendsToGroup (group: Group, friendsToAdd: [Friend]){
        
        if friendsToAdd.count == 0 {return}
        
            for friend in friendsToAdd{
                group.friends.append(friend)
            }
            
            //We can delete this once we are sure if works
            print ("\(group.friends.count) friends are in you group. They are:")
            
            for friend in group.friends {
                print("Name:", friend.username,"-", "E-mail:", friend.email)
            }
    }
    
    func deleteFriendsFromGroup(group: Group, groupID: Int, friendsToDelete: [Friend]){
        
        if friendsToDelete.count == 0 {return}
        
        for friend in friendsToDelete {
            
            // To be able to compare two Friends objects, we needed the Friend class to inherit the Equatable class. See the Friend class.
            if (group.friends.contains(friend)) {
                
                guard let index = group.friends.firstIndex(of: friend) else { return }
                
                group.friends.remove(at: index)
                
                print("Removed:", friend.email)
            }
        }
    }
    
    func addFriends (user: FireUser, friendsToAdd: [Friend]) {
        
        if friendsToAdd.count == 0 {return}
        
        for friend in friendsToAdd {
            if user.friends.contains(friend) {
                
                continue
                
            } else {
                
                user.friends.append(friend)
            }
        }
    }
    
    func removeFriends (user: FireUser, friendsToRemove: [Friend]) {
        
        if friendsToRemove.count == 0 {return}
        
        for friend in friendsToRemove {
            
            if (user.friends.contains(friend)) {
                
                guard let index = user.friends.firstIndex(of: friend) else { return }
                
                user.friends.remove(at: index)
                
                print("Removed:", friend.email)
            }
        }
    }
    
    
    
    
    //Firebase does not have a Swift function for a user to delete another user in the database. Refer to this website: https://stackoverflow.com/questions/38800414/delete-a-specific-user-from-firebase
    
    //Also looking at the Admin SDK, which aloows a user  to delete another user, Swift is not supported. Link: https://firebase.google.com/docs/auth/admin/manage-users
    func deleteUser (adminUser: Admin, userToDelete: FireUser){
    // so we are waiting on this function

        if (adminUser.isAdmin()) {
            
            
            
        } else {
            print ("\(adminUser.name) is not an admin user and therefore cannot delete a user from the database")
            return
        }
        
    }
    
    
    
    
}
