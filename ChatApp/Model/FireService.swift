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
import FirebaseStorage
import UIKit



/// <#Description#>
class FireService {
    static let db = Firestore.firestore()
    static let firendsString = "friends"
    static let users = db.collection("users")
    static let groupString  = "groups"
    static let sharedInstance = FireService()
    static let messagesString = "messages"
    static let storage = Storage.storage()
    static let storageRef = storage.reference()
    static let savedMessages = "savedMessages"
    
    
    

    /// Deletes a temporary image URL to send
    /// - Parameters:
    ///   - user: The user  from whom the temporary image URL is deleted
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func DeleteImageToSend(user : FireUser , completionHandler : @escaping (Result<Bool , Error>)-> ()){
        let refName = "\(user.email)/selectedImage.png"
        let ref = FireService.storageRef.child(refName)
        ref.delete { (error) in
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            FireService.users.document(user.email).updateData(["selectedImageUrl":FieldValue.delete()]) { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                completionHandler(.success(true))
                           return
            }
        }
    }
    
    
    
    /// Retrieves a temporary selected image URL to send
    /// - Parameters:
    ///   - user: The user who is sending the image
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func getImageToSend(user : FireUser , completionHandler : @escaping (Result<URL , Error>)-> ()){
        
        FireService.users.document(user.email).getDocument { (documents, error) in
            
            guard let data = documents?.data() else {return}
            
            if let url = data["selectedImageUrl"] as? String {
                if  let finalUrl = URL(string: url){
                    completionHandler(.success(finalUrl))
                }else{
                   print("couldnt cast to url")
                }
                
                
            }else{
                print("couldnt cast to string")
            }
            
        }
        
        
    }
    
    /// Uploads a temporary image to send
    /// - Parameters:
    ///   - data: The data containing image to be sent
    ///   - user: User sending the image to be uploaded
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    func saveImageToSend(data : Data , user : FireUser, completionHandler: @escaping (Result<Bool, Error>) -> Void){
        
        
        let refName = "\(user.email)/selectedImage.png"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/png"
        
        ref.putData(data, metadata: newMetadata) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(error))
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completionHandler(.failure(error!))
                    return
                }
                let data = ["selectedImageUrl" : url.absoluteString]
                
                self.addCustomData(data: data, user: user) { (error, sucess) in
                    if let error = error {
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                    if sucess{
                        print("sucessful completion of selected image upload ")
                        completionHandler(.success(true))
                    }
                }
            })
        }
        
        
    }
    
    /// Backend function to  save  a message. This  creates a document (a message) in FireBase in the user's 'savedMessages' collection.
    /// - Parameters:
    ///   - user: The current user sqving the message
    ///   - messageToSave: Message to be saved
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    func saveMessages(user : FireUser, messageToSave: Message, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        let Content = ["type" : messageToSave.content.type.rawValue,
                       "content": messageToSave.content.content,
                       "sender": messageToSave.sender.email] as [String : Any]
                        
        let ref =         FireService.users.document(user.email).collection(FireService.savedMessages).document()
        
        
        
      ref.setData(Content) { (error) in
            
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(true))
            
        }
    }
    

    
    /// Deletes the profile picture of a user
    /// - Parameters:
    ///   - user: User whose profile picture is to be deleted
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
     func DeleteProfilePicture(user : FireUser , completionHandler : @escaping (Result<Bool , Error>)-> ()){


        let refName = "\(user.email)/profileImage.png"
        let ref = FireService.storageRef.child(refName)
        ref.delete { (error) in
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            FireService.users.document(user.email).updateData(["profileImageUrl":FieldValue.delete()]) { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                completionHandler(.success(true))
                return
                
                
            }


        }
        
    }
    
    
    


    /// Retrieves the profile picture of a user.
    /// - Parameters:
    ///   - user: User whose profile picture is to be retrieved
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: <#description#>


    func getProfilePicture(user : FireUser , completionHandler : @escaping (Result<URL , Error>)-> ()){
        
        FireService.users.document(user.email).getDocument { (documents, error) in
            
            guard let data = documents?.data() else {return}
            
            if let url = data["profileImageUrl"] as? String {
                if  let finalUrl = URL(string: url){
                    completionHandler(.success(finalUrl))
                }else{
                    print("couldnt cast to url")
                }
                
                
            }else{
                print("couldnt cast to string")
            }
            
        }
        
        
    }
    
    
    
    
    /// Uploads the profile picture of a user
    /// - Parameters:
    ///   - data: The data containing image to be saved
    ///   - user: User whose profile picture is to be uploaded
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    func saveProfilePicture(data : Data , user : FireUser , completionHandler: @escaping (Result<Bool, Error>) -> Void){
        let refName = "\(user.email)/profileImage.png"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/png"
        
        ref.putData(data, metadata: newMetadata) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(error))
            }
            ref.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    completionHandler(.failure(error!))
                    return
                }
                let data = ["profileImageUrl" : url.absoluteString]
                
                self.addCustomData(data: data, user: user) { (error, sucess) in
                    if let error = error {
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                    if sucess{
                        print("sucessful completion of profile image upload ")
                        completionHandler(.success(true))
                    }
                    
                }
            })
        }
    }
    
    
    /// Loads all the activity from a user.
    /// - Parameters:
    ///   - User: User whose activity is to be loaded
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func loadAllActivity(User : FireUser , completion : @escaping ([Activity]? , Error?) -> ()){
        var activities  : [Activity] = []
        loadGroups(User: User) { (groups, error) in
            if let error = error{
                completion(nil , error)
            }
            guard let groups = groups else {fatalError()}
            groups.forEach { (group) in
                let activity = Activity(activityType: .GroupChat(group: group))
                activities.append(activity)
            }
            
            
            self.loadAllFriends(user: User) { (friends, error) in
                if let error = error{
                    completion(nil , error)
                }
                guard let friends = friends else {fatalError()}
                friends.forEach { (freind) in
                    let activity = Activity(activityType: .FriendChat(friend: freind))
                    activities.append(activity)
                    completion(activities , nil)
                }
                
            }
            
            
        }
    }
    
    
    /// Function to get all the friends of a user. It stores the retrieved friends of the user in an array.
    /// - Parameters:
    ///   - user: The user for whom the friends are  to be retrieved
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func loadAllFriends(user : FireUser , completion : @escaping ([Friend]? , Error?) -> ()){
        var friendList : [Friend] = []
        let friends =   FireService.users.document(user.email).collection(FireService.firendsString)
        
        friends.order(by: "name", descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                
                let id = data["id"] as! String
                let username = data["name"] as! String
                print(username)
                let email = data["email"] as! String
                let freind = Friend(email: email, username: username, id: id)
                friendList.append(freind)
            }
            
            completion(friendList , nil)
            
            
        }
        
        
        
    }
    func changeFriendToDictionary( _ friend : Friend) -> [String:Any]{
        
        return ["id" : friend.id,
                "username":friend.username,
                "email":friend.email
        ]
        
    }
    func changeUserToDictionary( _ user : FireUser) -> [String:Any]{
        
        return ["id" : user.id,
                "username":user.name,
                "email":user.email,
                "timecreated":user.timeCreated
        ]
        
    }
    
    func changeContentToDictionary( _ content : Content) -> [String : Any]{
        switch  content.type {
        case .string:
            return [ "type": "string",
                            "content": content.content]
        case .video:
            return [ "type": "video",
                            "content": content.content]
        case .file:
            return [ "type": "file",
                            "content": content.content]
        case .image:
            return [ "type": "image",
                            "content": content.content]
        }
    }
    
    func changeDictionaryToContent( dictionary : [String: Any]) -> Content{
        
        if (dictionary["type"] as! String == "string"){
            return Content(type: .string, content: dictionary["content"] ?? "")
        }
        
        if (dictionary["type"] as! String == "image"){
            return Content(type: .image, content: dictionary["content"] ?? "")
        }
        
        if (dictionary["type"] as! String == "video"){
            return Content(type: .video, content: dictionary["content"] ?? "")
        }
        
        if (dictionary["type"] as! String == "file"){
            return Content(type: .file, content: dictionary["content"] ?? "")
        }
        
        return Content(type: .string, content: "")
    }
    
    func changeMessageToDictionary( _ message: Message) -> [String : Any]{

        return [ "Content" :self.changeContentToDictionary(message.content),
                 "user":self.changeUserToDictionary(message.sender),
                 "timeStamp": message.timeStamp,
                 "recived": message.recieved
        ]
    }
    
    
    
    
    
    /// Function to turn the provided data to create a FireUser
    /// - Parameter data: Data inputted in the form of dictionary that will be used to create a FireUser
    /// - Returns: Created FireUser with the data that was provided in the function's parameter
    func changeDictionaryToFireUser(data : ([String : Any])) -> FireUser{
        let id = data["id"] as! String
        let username = data["username"] as! String
        let email = data["email"] as! String
        let date = data["timecreated"] as! Timestamp
        let finalDate = date.dateValue()
        let fireUser = FireUser(userID: id, userName: username, userEmail: email, creationDate: finalDate)
        return fireUser
    }
    
    
    /// Function to turn the provided data to create a Friend
    /// - Parameters:
    ///   - data: Data inputted in the form of dictionary that will be used to create a Friend.
    ///   - user: FireUser provided in the function to turn a FireUser info into a Friend. If user is null, the parameter data will be used instead to create the Friend
    /// - Returns: Created Friend. Returns null if inputted data and user are null
    func changeDictionaryToFriend(data : ([String : Any])? = nil , user : FireUser? = nil) -> Friend?{
        
        if let user = user {
            let freind = Friend(email: user.email, username: user.name, id: user.id)
            return freind
        }else if let data = data{
            let id = data["id"] as! String
            let username = data["username"] as! String
            let email = data["email"] as! String
            let freind = Friend(email: email, username: username, id: id)
            return freind
            
        }else{
            return nil
        }
        
        
        
    }
    
    
    /// Refreshes the  information of a user to the globalUser variable
    /// - Parameter email: Email address used to refresh the information of the globalUser variable
    func refreshUserInfo(email : String){
        self.searchOneUserWithEmail(email: email) { (user, error) in
            guard user != nil else {
                globalUser = nil
                print(error?.localizedDescription ?? "no error but user was nil")
                fatalError()
            }
            globalUser = user
        }
    }
    
    
    /// Function to determine if a FireUser is associated to an email address
    /// - Parameters:
    ///   - email: Email used to determine if a FireUser is associated with this email address
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
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
                    print(data, "data is here")
                    let user = self.changeDictionaryToFireUser(data: data)
                    
                    completion(user, nil)
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
    
    
    /// Function to determine if a Friend is associated to an email address
    /// - Parameters:
    ///   - email: Email used to determine if a Friend  is associated with this email address
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
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
    
    
    
    /// Gets the current user that is logged in
    /// - Parameter completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
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
    
    func addCustomData(data : [String : Any] ,user : FireUser ,  completion : @escaping (Error? , Bool) -> ()) {
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
    
    
    func sendMessageToGroup(message : Message ,group :  Group , completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        
        let sentdata = ["id":message.id ,
                        "timeStamp":message.timeStamp,
                        "email":message.sender.email,
                        "recived":false //I think we need to spell check as retrieving the data later on won't work
            ] as [String : Any]
        
        let Content = ["type" : message.content.type.rawValue,
                       "content":message.content.content] as [String : Any]
        
        let ref =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.name).collection("messages").document()
        
        ref.setData(sentdata) { (error) in
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            
            ref.collection("content").document().setData(Content) { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(true))
                
            }
            
            
            
        }
        
        
        
    }
    
    
    
    //tested
    func createGroup(group : Group ,completion : @escaping (Bool, Error?) -> ()){
        
        let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
        FireService.users.document(group.GroupAdmin.email).collection("groups").document(group.name).setData(data, merge: true) { (error) in
            
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
            
        }
        
    }
    //tested
    func createGroupFromReceivingDynamicLink(groupname:String,groupID:String,groupAdmin:String,currentUserEmail:String,completion : @escaping (Bool, Error?) -> ()){
        
        let data = ["groupname":groupname, "groupadmin" : groupAdmin, "groupid": groupID] as [String : Any]
        FireService.users.document(currentUserEmail).collection("groups").document(groupname).setData(data, merge: true) { (error) in
            
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
            
        }
        
    }
    
    
    //Function that searches for the max groupID.
    func searchForMaxGroupId(group:Group,completion: @escaping (Bool,Int,Error?) -> ()){
        var data:[Int] = []
        var maxIDplusone:Int = 0
        FireService.users.document(group.GroupAdmin.email).collection("groups").whereField("groupid", isGreaterThanOrEqualTo: 0).getDocuments { (querySnapshot, error) in
            if let error = error{
                print("completion is false")
                completion(false,0, error)
                return
            }
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let groupidData = document.data()["groupid"] as! Int
                data.append(groupidData)
                
                
            }
            print(data)
            
            if let maxid = data.max(){
                maxIDplusone = maxid + 1
                print("Max ID = \(maxIDplusone), \(data.max())")
                completion(true,maxIDplusone,nil)
                
            }
            else{
                completion(true,maxIDplusone,nil)
            }
            
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
                    print("you have already added this person")
                    completion(true , nil)
                    return
                }else{
                    FireService.users.document(User.email).collection(FireService.firendsString).document(friend.email).setData(data) { (error) in
                        if let error = error {
                            completion(false, error)
                        }else{
                            completion(true , nil)
                            return
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
    
    
    
    //Updating this to send
    func sendMessageToFriend(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        let newSendRef = FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document()
        
        let newReceivedRef = FireService.users.document(freind.email).collection(FireService.firendsString).document(User.email).collection("messages").document()
        
        let messageDictionary = self.changeMessageToDictionary(message)
        
        
        newSendRef.setData(messageDictionary) { (error) in
            if let error = error {
                completion(false, error)
            }
            
            newReceivedRef.setData(messageDictionary) { (error) in
                if let error = error {
                    completion(false, error)
                }
                completion(true, nil)
            }
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
    
    
    
    
    
    
    //works
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
                let recived = data["recived"] as! Bool // I think we need to spell check as it will not work later on once we try to retrieve data
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
    //need testing
    /// Gets Friends froma  group return empty list if there are no friends , fails if it cant
    /// cast document to friend
    /// - Parameters:
    ///   - user: The user currently using the application
    ///   - group: The group the user is in
    ///   - completionHandler: comlets with a list of friends or error
    /// - Returns: None
    func getFriendsInGroup(user : FireUser , group : Group , completionHandler : @escaping (Result<[Friend] , Error>)-> ()){
        var Finalfriends : [Friend] = []
        //refreence to final List of friends that the function will be completing with
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.name)
        
        //ref to freinds in group
        let groupFreindsRef = groupRef.collection("Freinds")
        // getting all friends from collection
        groupFreindsRef.getDocuments { (snapShot, error) in
            if let error = error{
                completionHandler(.failure(error))
            }
            //if the unwrapping failing this means there was no friends
            guard let documents = snapShot?.documents else {
                print("no error but there was no friends yet")
                completionHandler(.success(Finalfriends))
                return
            }
            // looks through the documents and gets all friends3
            documents.forEach { (document) in
                let data = document.data()
                let singleFriend = self.changeDictionaryToFriend(data: data)
                Finalfriends.append(singleFriend!)
                // completes the function when we are sure all documents have been chnaged to freinds
                if Finalfriends.count == documents.count {
                    completionHandler(.success(Finalfriends))
                    return
                }
            }
        }
        
        
    }
    
    //need testing
    /// Add Freinds to a roup by making  network call. Completes with true if it was sucessful
    /// - Parameters:
    ///   - user: The user currently using the application
    ///   - group: The group the user is in
    ///   - completionHandler: completes with true if the network call was sucessful, or faliure if the etwork call was unsucesfull
    /// - Returns: None
    func addFriendToGroup(user : FireUser , group : Group ,freind : Friend, completionHandler : @escaping (Result<Bool , Error>)-> ()){
         let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.name)
        let frieindAsData = self.changeFriendToDictionary(freind)
        
        groupRef.collection("Freinds").addDocument(data: frieindAsData) { (error) in
            if let error = error{
                completionHandler(.failure(error))
            }
            
            completionHandler(.success(true))
        }
          
    }
    
    
    //need testing
    func sendMessgeToAllFriendsInGroup(message : Message , user : FireUser , group : Group , completionHandler : @escaping (Result<Bool , Error>)-> ()){
        //gets all the friends in current group
        var count = 0
        self.getFriendsInGroup(user: user, group: group) { (result) in
            switch result{
                
            case .success(let friends):
                count = friends.count
                if friends.isEmpty {return}
                //sends the same message to every person in the group
                friends.forEach { (friend) in
                    let groupRef =         FireService.users.document(friend.email).collection(FireService.groupString).document(group.name).collection("messages").document()
                    let message = self.changeMessageToDictionary(message)
                    groupRef.setData(message) { (error) in
                        if let error = error {
                            print("failed while senidng to friends")
                            completionHandler(.failure(error))
                            
                        }
                        count -= 1
                        if count == 0 {
                            print("sent all messages")
                            completionHandler(.success(true))
                        }
                    }
                    
                }
                
                
                
                
            case .failure(let error):
                completionHandler(.failure(error))
                return

            }
        }
        
        
    }
    
    
    
    // Need to test
    func loadMessagesWithGroup(user : FireUser, group: Group ,completion : @escaping ([Message]? , Error?) -> ()){
        
        var messages : [Message] = []
        
        let ref = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.name).collection("messages")
        
        ref.addSnapshotListener { (snapshot, error) in
            
            guard let documents = snapshot?.documents else {
                completion(nil , error)
                return
            }
            
            documents.forEach { (document) in
                
                let id = document.documentID
                let data = document.data()
                let received = data["recived"] as! Bool  //We need to spell check for the properties, as some spelling in Firestore will not correspond to this
                let date = data["timeStamp"] as! Timestamp
                let finalDate = date.dateValue()
                let messageId = data["id"] as! String
                let sender = data["email"] as! String
                
                
                ref.document(id).collection("content").addSnapshotListener { (snapshot, error) in
                    
                    
                    guard let contentDocuments = snapshot?.documents else {
                        completion(nil , error)
                        return
                    }
                    
                    
                    contentDocuments.forEach { (document) in
                        let contentData =  document.data()
                        let content = contentData["content"] as Any
                        let messagecontent = Content(type: .string, content: content)
                        
                        // Need to verify this
                        
                        self.searchOneUserWithEmail(email: sender) { (user, error) in
                            guard let tempUser = user else {return}
                            let message = Message(content: messagecontent, sender: tempUser, timeStamp: finalDate, recieved: received)
                            print(message.content.content as! String , "this is printing in loadmessages" )
                            messages.append(message)
                            
                            
                            if messages.count == documents.count{
                                completion(messages , nil)
                                return
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    
    
    
    // need to test
    func loadGroups(User : FireUser,completion : @escaping ([Group]? , Error?) -> ()){
        var groups  : [Group] = []
        FireService.users.document(User.email).collection(FireService.groupString).addSnapshotListener { (snapshots, error) in
            
            if let error = error{
                completion(nil , error)
                return
            }
            
            guard let snapShots = snapshots else {return}
            print(snapShots.documents.count)
            for  document in snapShots.documents{
                let documentData = document.data()
                let email = documentData["groupadmin"] as! String
                let id = documentData["groupid"] as! String
                let name = documentData["groupname"] as! String
                
                self.searchOneUserWithEmail(email: email) { (user, error) in
                    guard let user = user else {return}
                    
                    let group = Group(GroupAdmin: user, id: id, name: name)
                    groups.append(group)
                    
                    if snapShots.count == groups.count {
                        completion (groups, nil)
                    }
                    
                    
                }
                
                
            }
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
        let fireUser = FireUser(userID: "1", userName: "E", userEmail: "E", creationDate: Date())
        let message = Message(content: content, sender: fireUser, timeStamp: Date(), recieved: false)
        let group = Group(GroupAdmin: fireUser, id: "1", name: "BJEHD")
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




