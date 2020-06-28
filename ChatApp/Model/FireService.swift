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
    
    static let firendsString = "friends"
    static let users = db.collection("users")
    
    static let sharedInstance = FireService()
    
    
    
    
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
    
    
    
    /**
     Signs up  a user
     
     - Parameter email:  the email to signUp with
     - Parameter password: the passowrd of the user
     - Returns: Void
     */
    //tested
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
    
    
    
    //tested
    func createGroup(group : Group ,completion : @escaping (Bool , Error?) -> () ){
        let data = ["grouppname":group.name, "groupadmin" : group.GroupAdmin.email]
        
        
        
        FireService.users.document(group.GroupAdmin.email).collection("groups").document(group.name).collection(group.name).document(group.name).setData(data, merge: true) { (error) in
            
            
            if let error = error {
                completion(false , error)
                return
            }
            completion(true, nil)
        }
    }
    //need to test
    func deleteGroup (group: Group){
        FireService.users.document(group.GroupAdmin.email).collection("groups").document(group.name).delete()
    }
    
    
    //need to test
    func addFriend(data :[String:Any] ,User :FireUser ,friend : Friend , completion : @escaping (Bool , Error?) -> ()) {
        FireService.users.document(User.email).collection(FireService.firendsString).document(friend.email).setData(data) { (error) in
            if let error = error {
                completion(false, error)
            }else{
                completion(true , nil)
            }
        }
    }
    //nned to test
    func deleteFriend(User :FireUser ,friend : Friend , completion : @escaping (Bool , Error?) -> ()){
        
        FireService.users.document(User.email).collection(FireService.firendsString).document(friend.email).delete { (error) in
            if let error = error {
                completion(false , error)
                return
            }
            completion(true , nil)
        }
        
    }
    
    
    
    //need to test
    func SendMessage(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        if message.content.type == .string {
            let data = ["id":message.id ,
                        "content" : message.content.content,
                        "timeStamp":message.timeStamp,
                        "email":message.sender.email,
                        "type":message.content.type.rawValue
            ]
            
            FireService.users.document(User.email).collection("messages").document(freind.email).collection("messages").document(freind.email).setData(data) { (error) in
                if let error = error {
                    completion(false , error)
                    return
                }
                completion(true , nil)
            }
            
            
        }else{
            fatalError()
            print("Not supported Yet")
        }
        
    }
    
    //need to test
    func deleteMessage(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        
        if message.content.type == .string {
            
            FireService.users.document(User.email).collection("messages").document(freind.email).collection("messages").document(freind.email).delete { (error) in
                if let error = error {
                    completion(false , error)
                    return
                }
                completion(true,nil)
                return
            }
            
        }else{
            fatalError()
            print("Not supported Yet")
        }
        
    }
    
    
    //need to test
    func loadMessages(User : FireUser, freind : Friend ,completion : @escaping ([[String:Any]]? , Error?) -> ()){
        var data  : [[String:Any]] = [[:]]
        FireService.users.document(User.email).collection("messages").document(freind.email).collection("messages").addSnapshotListener { (snapshots, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let snapShots = snapshots else {return}
            
            for  document in snapShots.documents{
                let documentData = document.data()
                data.append(documentData)
            }
            
            completion(data , nil)
            
        }
    }
    
    
    func loadGroups(User : FireUser,completion : @escaping ([[String:Any]]? , Error?) -> ()){
         var data  : [[String:Any]] = [[:]]
        FireService.users.document(User.email).collection("groups").addSnapshotListener { (snapshots, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let snapShots = snapshots else {return}
            
            for  document in snapShots.documents{
                let documentData = document.data()
                data.append(documentData)
            }
            completion(data , nil)
        }
        
    }
    
    
    
    
    
    //need to test
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
    //need to test
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
    //need to test
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
    //need to test
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



