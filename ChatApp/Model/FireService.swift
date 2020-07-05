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



// this class connects to firebasexx
class FireService {
    static let db = Firestore.firestore()
    
    static let firendsString = "friends"
    static let users = db.collection("users")
    
    static let sharedInstance = FireService()
    
    
    
    
    func loadAllActivity(){
        
    }
    
    func loadAllChats(){
        
    }
    
    func loadAllGroups(){
        
    }
    
    
    
    
    
    func loadAllFriends(user : FireUser , completion : @escaping ([Friend]? , Error?) -> ()){
        var friendList : [Friend] = []
        let friends =   FireService.users.document(user.email).collection(FireService.firendsString)
        
        friends.getDocuments { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                
                let id = data["id"] as! Int32
                let username = data["name"] as! String
                let email = data["email"] as! String
                let freind = Friend(email: email, username: username, id: id)
                friendList.append(freind)
            }
            
            completion(friendList , nil)
            
            
        }
        
        
        
    }
    
    func changeDictionaryToFireUser(data : ([String : Any])) -> FireUser{
        let id = data["id"] as! Int32
        let username = data["username"] as! String
        let email = data["email"] as! String
        let date = data["timecreated"] as! Timestamp
        let finalDate = date.dateValue()
        let fireUser = FireUser(userID: id, userName: username, userEmail: email, creationDate: finalDate)
        return fireUser
    }
    
    func changeDictionaryToFriend(data : ([String : Any])? = nil , user : FireUser? = nil) -> Friend?{
        
        if let user = user {
            let freind = Friend(email: user.email, username: user.name, id: user.id)
            return freind
        }else if let data = data{
            let id = data["id"] as! Int32
            let username = data["username"] as! String
            let email = data["email"] as! String
            let freind = Friend(email: email, username: username, id: id)
            return freind
            
        }else{
            return nil
        }
        
        
        
    }
    
    
    func searchOneUserWithEmail(email : String,completion : @escaping (FireUser? , Error?) -> ()){
        
        var data : [String : Any] = [:]
        let query = FireService.users.whereField("email", isEqualTo: email)
        
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let documents = snapshot?.documents else{return}
            let count = documents.count
            if count == 1 {
                for document in documents{
                    data = document.data()
                    let user = self.changeDictionaryToFireUser(data: data)
                    
                    completion(user, nil)
                    return
                }
                
                
            }
            if count == 0 {
                fatalError("email does not exists")
                return
            }
                
            else{
                fatalError("This shouldnt be happening")
                
            }
            
            
            
            
            
        }
    }
    
    
    func searchOneFreindWithEmail(email : String,completion : @escaping (Friend? , Error?) -> ()){
        var data : [String : Any] = [:]
        let query = FireService.users.whereField("email", isEqualTo: email)
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let documents = snapshot?.documents else{return}
            let count = documents.count
            if count == 1 {
                for document in documents{
                    data = document.data()
                    let user = self.changeDictionaryToFireUser(data: data)
                    let friend = self.changeDictionaryToFriend(user: user)
                    
                    completion(friend, nil)
                    return
                }
                
                
            }
            if count == 0 {
                fatalError("email does not exists")
            }
                
            else{
                fatalError("This shouldnt be happening")
                
            }
            
            
            
            
            
        }
        
    }
    
    
    
    func getCurrentUser(completion : @escaping (FirebaseAuth.User?) -> ()){
        let user = Auth.auth().currentUser
        
        if let user = user {
            completion(user)
        }else{
            completion(nil)
        }
    }
    
    
    
    func getCurrentUserData(email : String , completion : @escaping (FireUser? , Error?) -> ()){
        
        FireService.users.document(email).getDocument { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            
            let fireUser = self.changeDictionaryToFireUser(data: data)
            completion(fireUser , nil)
            return
            
        }
        
    }
    
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
    
    
    
    func addData(user : FireUser ,  completion : @escaping (Error? , Bool) -> ()) {
        
        let data = ["id" : user.id,
                    "username":user.name,
                    "email":user.email,
                    "timecreated":user.timeCreated] as [String : Any]
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
    func createGroup(group : Group ,completion : @escaping (Bool , Error?) -> ()){
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
    func addFriend(User :FireUser ,friend : Friend , completion : @escaping (Bool , Error?) -> ()) {
        
        let data = ["name" : friend.username,
                    "email":friend.email,
                    "id": friend.id] as [String : Any]
        
        if friend.email == User.email {
            fatalError("you cannot add yourself")
        }
        
        loadAllFriends(user: User) { (friends, error) in
            if let freinds = friends{
                if freinds.contains(friend){
                    fatalError("you have already added this person")
                }else{
                    FireService.users.document(User.email).collection(FireService.firendsString).document(friend.email).setData(data) { (error) in
                        if let error = error {
                            completion(false, error)
                        }else{
                            completion(true , nil)
                        }
                    }
                    
                }
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
    
    
    
    
    func sendMessagefinal(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        
        let sentdata = ["id":message.id ,
                        "timeStamp":message.timeStamp,
                        "email":message.sender.email,
                        "recived":false
            ] as [String : Any]
        
        
        let recicedData =  ["id":message.id ,
                            "timeStamp":message.timeStamp,
                            "email":message.sender.email,
                            "recived":true
            
            ] as [String : Any]
        
        
        
        
        
        
        let Content = ["type" : message.content.type.rawValue,
                       "content":message.content.content] as [String : Any]
        
        let sendDoc =           FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document(freind.email).collection(freind.email).document()
        
        
        let sendContentDoc = sendDoc.collection("content").document()
        
        
        
        
        
        let reciveDoc =                  FireService.users.document(freind.email).collection(FireService.firendsString).document(User.email).collection("messages").document(User.email).collection(User.email).document()
        
        
        let reciveContentDoc = reciveDoc.collection("content").document()
        
        sendDoc.setData(sentdata) { (error) in
            if let error = error{
                completion(false , error)
                fatalError()
                
            }
            
            reciveDoc.setData(recicedData, merge: false) { (error) in
                
                if let error = error{
                    completion(false , error)
                    fatalError()
                    
                }
                
                sendContentDoc.setData( Content, merge: false) { (error) in
                    
                    if let error = error{
                        completion(false , error)
                        fatalError()
                        
                    }
                    
                    reciveContentDoc.setData(Content) { (error) in
                        
                        if let error = error{
                            completion(false , error)
                            fatalError()
                            
                        }
                        
                        completion(true, nil)
                        
                    }
                    
                }
                
            }
            
            
            
            
            
            
        }
        
        
        
        
    }
    
    //need to test
    func SendMessage(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        if message.content.type == .string {
            let sentdata = ["id":message.id ,
                            "content" : message.content.content,
                            "timeStamp":message.timeStamp,
                            "email":message.sender.email,
                            "type":message.content.type.rawValue,
                            "recived":true
            ]
            
            let recicedData =  ["id":message.id ,
                                "content" : message.content.content,
                                "timeStamp":message.timeStamp,
                                "email":message.sender.email,
                                "type":message.content.type.rawValue,
                                "recived":false
                
            ]
            
            FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document(freind.email).setData(sentdata) { (error) in
                if let error = error {
                    completion(false , error)
                    return
                }
                
                
                FireService.users.document(freind.email).collection(FireService.firendsString).document(User.email).collection("messages").document(User.email).setData(recicedData) { (error) in
                    if let error = error {
                        completion(false , error)
                        return
                    }
                    
                    completion(true , nil)
                    
                }
                
                
                
                
            }
            
            
        }else{
            fatalError()
            print("Not supported Yet")
        }
        
    }
    
    //need to test
    func deleteMessage(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        
        if message.content.type == .string {
            
            FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document(freind.email).delete { (error) in
                if let error = error {
                    completion(false , error)
                    return
                }
                completion(true,nil)
                return
            }
            
        }else{
            print("Not supported Yet")
            fatalError()
            
        }
        
    }
    
    
    func loadMessagesWithFriend2(User : FireUser, freind : Friend ,completion : @escaping ([Message]? , Error?) -> ()){
        let ref =           FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document(freind.email).collection(freind.email)
        ref.addSnapshotListener { (snapshot, error) in
            var messages : [Message] = []
            guard let documents = snapshot?.documents else {
                completion(nil , error)
                return
            }
            documents.forEach { (document) in
                let id = document.documentID
                let data = document.data()
                let email = data["email"] as! String
                let recived = data["recived"] as! Bool
                let date = data["timeStamp"] as! Timestamp
                let finalDate = date.dateValue()
               // let messageId = data["id"] as! String
                ref.document(id).collection("content").addSnapshotListener { (snapshot, error) in
                    guard let contentDocuments = snapshot?.documents else {
                        completion(nil , error)
                        return
                    }
                    contentDocuments.forEach { (document) in
                       let contentData =  document.data()
                        let content = contentData["content"] as Any
                        let messagecontent = Content(type: .string, content: content)
                        self.searchOneUserWithEmail(email: email) { (user, error) in
                            guard let user = user else {return}
                             let message = Message(content: messagecontent, sender: user, timeStamp: finalDate, recieved: recived)
                            messages.append(message)
                            if messages.count == documents.count{
                                
                                completion(messages , nil)
                                return
                            }
                        }
                    }
                }
            }
            completion(messages, error)
            return
        }
        
        
    }
    
    
    
    
    func loadMessagesWithFriend(User : FireUser, freind : Friend ,completion : @escaping ([Message]? , Error?) -> ()){
        var messages : [Message] = []
        
        let ref =           FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document(freind.email).collection(freind.email)
        
        
        ref.addSnapshotListener { (snapshot, error) in
            
            messages.removeAll()
            guard let documents = snapshot?.documents else {
                completion(nil , error)
                return
            }
            print(documents.count , "this is the number of documents")
            
            for document in documents {
                
                
                let maindata = document.data()
                let id = document.documentID
                //print(id , "the id is thisssssss")
                
                let contentRef =  ref.document(id).collection("content")
                
                contentRef.getDocuments { (snapshot, error) in
                    
                    guard let documents = snapshot?.documents else {
                        completion(nil , error)
                        return
                    }
                    for document in documents{
                        let data = document.data()
                        let contentData = data["content"] as Any
                        _ = data["type"]
                        let content = Content(type: .string, content: contentData)
                        
                        let email = maindata["email"] as! String
                        
                        let recived = maindata["recived"] as! Bool
                        
                        let date = maindata["timeStamp"] as! Timestamp
                        let finalDate = date.dateValue()
                        self.searchOneUserWithEmail(email: email) { (user, error) in
                            guard let user = user else {
                                completion(nil , error)
                                return
                            }
                            if recived{
                                let message = Message(content: content, sender: user, timeStamp: finalDate, recieved: recived)
                                messages.append(message)
                                print(message.content.content as! String)
                            }
                            else{
                                let user = FireUser(userID: 1, userName: User.name, userEmail: User.email, creationDate: User.timeCreated)
                                
                                let message = Message(content: content, sender: user, timeStamp: finalDate, recieved: recived)
                                
                                messages.append(message)
                                print(message.content.content as! String)
                                
                            }
                        }
                        if messages.count == documents.count{
                            completion(messages , nil)
                            return
                        }else{
                            print(messages.count ,"this is the amount of messages avaialable")
                        }
                    }
                    
                    
                    
                    
                }
                
                
            }
            
            
            
            
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
    
    
    func createCodableUser<T: Codable>(for encodableObject : T) -> Void {
        do{
           let json = try encodableObject.toJson()
            FireService.db.collection("examplecodableuser").addDocument(data: json)
        }catch{
            print(error)
        }
    }
    
    
    func testActivity (){
        var activities : [Activity] = []
        let content = Content(type: .string, content: "yo")
        let fireUser = FireUser(userID: 1, userName: "E", userEmail: "E", creationDate: Date())
        let message = Message(content: content, sender: fireUser, timeStamp: Date(), recieved: false)
        let group = Group(GroupAdmin: fireUser, id: 1, name: "BJEHD")
        let activity = Activity(activityType: .GroupChat(group: group))
        activities.append(activity)
    }
    
    
    
    
    
    
}

/// dont worry about this here - Ebuka (this is practice for encodable and codable objects)



enum CodableChatError : String, Error{
    
    case enocdingError = "couldNotEncode"
}
extension Encodable {
    
    func toJson() throws -> [String : Any] {
        
        let objectData = try! JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String :Any] else{ throw CodableChatError.enocdingError}
        return json
    }
}



