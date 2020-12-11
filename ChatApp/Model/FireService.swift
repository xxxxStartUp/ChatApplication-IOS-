//
//  FireService.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import UIKit
import AVFoundation



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
    
    
    
    
    ////////////////////////Group functions///////////////////////////
    
    
    // need to test
    func loadGroups(User : FireUser,completion : @escaping ([Group]? , Error?) -> ()){
        var groups  : [Group] = []
        print("loadGroup \(User.email)")
        FireService.users.document(User.email).collection(FireService.groupString).getDocuments{ (snapshots, error) in
                if let error = error{
                    completion(nil , error)
                    return
                }
                guard let snapShots = snapshots else {return}
                print(snapShots.documents.count)
                for  document in snapShots.documents{
                    let documentData = document.data()
                    print(documentData)
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
    
    
    
    
    
    
    /// Load all messages with  group
    /// - Parameters:
    ///   - user: user object
    ///   - group: group object
    ///   - completion: complets with list of messages
    /// - Returns: None
    func loadMessagesWithGroup(user : FireUser, group: Group ,completion : @escaping ([Message]? , Error?) -> ()){
        //refrence to get list of documents that are actaully messages
        let ref = FireService.users.document(user.email).collection(FireService.groupString).document(group.id).collection("messages")
        
        //listening for new messages
        ref.addSnapshotListener{ (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil ,error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no messages")
                completion(messages , nil)
                return
            }
            
            documents.forEach { (document) in
                let message = self.changeDictionaryToMessage(document.data())
                messages.append(message)
                print(message.content.content as! String , "this is from loadmessageswithgroup",message.content.type.rawValue)
                if messages.count == documents.count {
                    completion(messages , nil)
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
        let groupRef =  FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        
        let frieindAsData = self.changeFriendToDictionary(freind)
        
        checkIfFriendInGroup(freindToAdd: freind, group: group) { (result) in
            switch result {
                
            case .success(let bool):
                if bool {
                    
                    groupRef.collection("Freinds").document(freind.email).setData(frieindAsData) { (error) in
                        if let error = error{
                            completionHandler(.failure(error))
                        }
                        self.searchOneUserWithEmail(email: freind.email) { (user, error) in
                            if let error = error {
                                completionHandler(.failure(error))
                            }
                            guard let user = user else {return}
                            let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
                            
                            FireService.users.document(user.email).collection("groups").document(group.id).setData(data, merge: true) { (error) in
                                
                                if let error = error {
                                    completionHandler(.failure(error))
                                    return
                                }
                                
                                completionHandler(.success(true))
                                return
                            }
                            
                        }
                        
                        
                    }
                    
                }
                else { completionHandler(.success(false)) }
                
                return
                
            case .failure(let error):
                completionHandler(.failure(error))
                return
                
            }
        }
        
        
        
    }
    
    func addAdminToGroup(user : FireUser , group : Group ,freind : Friend, completionHandler : @escaping (Result<Bool , Error>)-> ()){
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        
        let frieindAsData = self.changeFriendToDictionary(freind)
        
        groupRef.collection("Freinds").document(freind.email).setData(frieindAsData) { (error) in
            if let error = error{
                completionHandler(.failure(error))
            }
            self.searchOneUserWithEmail(email: freind.email) { (user, error) in
                if let error = error {
                    completionHandler(.failure(error))
                }
                guard let user = user else {return}
                let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
                
                FireService.users.document(user.email).collection("groups").document(group.id).setData(data, merge: true) { (error) in
                    
                    if let error = error {
                        completionHandler(.failure(error))
                        return
                    }
                    
                    completionHandler(.success(true))
                }
                
            }
            
            
            
            
        }
    }
    //        let frieindAsData = self.changeFriendToDictionary(freind)
    //        self.searchOneUserWithEmail(email: freind.email) { (user, error) in
    //            if let error = error {
    //                completionHandler(.failure(error))
    //            }
    //            guard let user = user else {return}
    //
    //            groupRef.collection("Freinds").getDocuments { (snapshot, error) in
    //                if let error = error{
    //                    completionHandler(.failure(error))
    //                }
    //                guard let documents = snapshot?.documents else {return}
    //                for document in documents {
    //                    let data = document.data()
    //                    let email = data["email"] as! String
    //
    //                    if user.email == email{
    //                        print("user exists and cant be added",user.email,email)
    //                        return
    //                    }
    //                    else{
    //                        groupRef.collection("Freinds").addDocument(data: frieindAsData) { (error) in
    //                            if let error = error{
    //                                completionHandler(.failure(error))
    //                            }
    //                            self.searchOneUserWithEmail(email: freind.email) { (user, error) in
    //                                if let error = error {
    //                                    completionHandler(.failure(error))
    //                                }
    //                                guard let user = user else {return}
    //
    //                                let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
    //
    //                                FireService.users.document(user.email).collection("groups").document(group.id).setData(data, merge: true) { (error) in
    //
    //                                    if let error = error {
    //                                        completionHandler(.failure(error))
    //                                        return
    //                                    }
    //                                    completionHandler(.success(true))
    //                                }
    //
    //                            }}
    //                    }
    //                }
    //            }
    //        }
    //
    //
    //
    //    }
    
    
    /// Checks if  a friend is in a paticular group
    /// - Parameters:
    ///   - freindToAdd: a friend object to be added
    ///   - group: the group to add the friend
    ///   - completionHandler: completes with a true or false if a friend is in a group or error if a network error occurs
    /// - Returns: None
    func checkIfFriendInGroup(freindToAdd : Friend , group : Group , completionHandler : @escaping (Result<Bool , Error>)-> ()){
        
        self.getFriendsInGroup(user: group.GroupAdmin, group: group) { (result) in
            switch result {
            case .success(let friends):
                //when a friend is in a group complete with a false
                if friends.contains(freindToAdd) { completionHandler(.success(false)) }
                    //when a friend is not in a group; then now we know the friend is not the group
                else { completionHandler(.success(true)) }
                return
            case .failure(let error):
                //when an error occurs
                completionHandler(.failure(error))
                return
            }
            
        }
        
    }
    
    
    
    
    
    
    
    func createGroup(user:FireUser,group : Group ,completion : @escaping (Bool, Error?) -> ()){
        
        let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
        //creating group
        FireService.users.document(user.email).collection("groups").document(group.id).setData(data, merge: true) { (error) in
            
            if let error = error {
                completion(false, error)
                return
            }
            //add the groupadmin as a friend in the group
            self.addAdminToGroup(user: group.GroupAdmin, group: group, freind: group.GroupAdmin.asAFriend) { (result) in
                switch result{
                case .success(_):
                    completion(true, nil)
                    return
                case .failure(_):
                    completion(false , error)
                    return
                }
            }
            
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
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        
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
    
    
    
    
    
    /// Adds Multiple Friends to a group
    /// - Parameters:
    ///   - user: fireUser object
    ///   - group: the group that will be used
    ///   - friendsToAdd: list of friends
    ///   - completionHandler: complets with a true boolen if all friends are added else error
    /// - Returns: None
    func addMultipleFriendsToGroup (user : FireUser , group: Group, friendsToAdd: [Friend], completionHandler : @escaping (Result<Bool , Error>)-> ()){
        
        var count = friendsToAdd.count
        //loop through freinds
        friendsToAdd.forEach { (friend) in
            // add a single freind
            self.addFriendToGroup(user: user, group: group, freind: friend) { (result) in
                switch result {
                case .success(let bool):
                    count -= 1
                    //check if we added everyone
                    if count == 0 {
                        // we are done dding friends
                        completionHandler(.success(bool))
                        return
                    }
                case .failure(let error):
                    //complete with with error
                    completionHandler(.failure(error))
                    return
                }
            }
        }
    }
    
    //view all group participants
    func viewGroupParticipants(user : FireUser, group:Group,completionHandler : @escaping ([Friend],Bool,Error?)-> ()){
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        var participants = [Friend]()
        groupRef.collection("Freinds").getDocuments { (snapshot, error) in
            
            if let error = error{
                completionHandler(participants,false,error)
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                let email = data["email"] as! String
                let username = data["username"] as! String
                let id = data["id"] as! String
                
                let friend = Friend(email: email, username: username, id: id)
                participants.append(friend)
            }
            
            completionHandler(participants,true,nil)
        }
    }
    
    
    
    
    
    ////////////////end of group funcions/////////////////////
    
    
    
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
    
    
    
    func saveMessageWithFreind(user : FireUser , freind : Friend , message : Message, completionHandler: @escaping (Result<Bool, Error>) -> Void){
        let ref = FireService.users.document(user.email).collection(FireService.savedMessages).document(freind.id)
        let data = self.changeMessageToDictionary(message)
        ref.collection("FreindMessages").document("\(message.id)").setData(data) { (error) in
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(true))
        }
        
    }
    
    
    
    
    func getLastMessageForGroup(group : Group , user : FireUser, completionHandler: @escaping (Result<Message, Error>) -> Void){
        
        self.loadMessagesWithGroup(user: user, group: group) { (messages, error) in
            
            guard var messages = messages else {return}
            
            messages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            let lastMessage = messages[messages.count-1]
            completionHandler(.success(lastMessage))
        }
    }
    
    
    func getLastMessageForFreind(freind : Friend , user : FireUser, completionHandler: @escaping (Result<Message, Error>) -> Void){
        
        self.loadMessagesWithFriend(User: user, freind: freind) { (messages, error) in
            guard var messages = messages else {return}
            messages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            let lastMessage = messages[messages.count-1]
            completionHandler(.success(lastMessage))
        }
    }
    
    
    
    
    
    
    
    func loadSavedMessagesWithFriend(user:FireUser, freind:Friend, completion: @escaping ([Message]?,Error?)-> ()){
        let ref =         FireService.users.document(user.email).collection(FireService.savedMessages).document(freind.id).collection("Messages")
        //listening for new messages
        ref.getDocuments{ (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil , error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no messages")
                completion(messages , nil)
                return
            }
            
            documents.forEach { (document) in
                
                //checks if documentID is equal to group id then it returns the messages
                
                let message = self.changeDictionaryToMessage(document.data())
                messages.append(message)
                print(message.content.content as! String , "this is from loadmessageswithgroup",message.content.type.rawValue)
                if messages.count == documents.count {
                    completion(messages, nil)
                    return
                }
            }
            
            
        }
    }
    
    
    
    /// Backend function to  save  a message. This  creates a document (a message) in FireBase in the user's 'savedMessages' collection.
    /// - Parameters:
    ///   - user: The current user sqving the message
    ///   - messageToSave: Message to be saved
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    func saveMessages(user : FireUser, group:Group, messageToSave: Message, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
        let ref = FireService.users.document(user.email).collection(FireService.savedMessages).document(group.id)
        ref.setData(data, merge: true) { (error) in
            if let error = error{
                completionHandler(.failure(error))
            }
            ref.collection("Messages").document("\(messageToSave.id)").setData(self.changeMessageToDictionary(messageToSave)) { (error) in
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(true))
            }
        }
        
        

    }
    
    func loadSavedMessages(user:FireUser, group:Group, completion: @escaping ([Message]?,Error?)-> ()){
        
        
        let ref =         FireService.users.document(user.email).collection(FireService.savedMessages).document(group.id).collection("Messages")
        //listening for new messages
        ref.getDocuments{ (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil , error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no messages")
                completion(messages , nil)
                return
            }
            
            documents.forEach { (document) in
                
                //checks if documentID is equal to group id then it returns the messages
                
                let message = self.changeDictionaryToMessage(document.data())
                messages.append(message)
                print(message.content.content as! String , "this is from loadmessageswithgroup",message.content.type.rawValue)
                if messages.count == documents.count {
                    completion(messages, nil)
                    return
                }
            }
            
            
        }
    }
    func loadSavedMessagesFromSettings(user:FireUser, completion: @escaping ([Message]?,Error?)-> ()){
        
        
        let ref =         FireService.users.document(user.email).collection(FireService.savedMessages)
        
        var messageDocumentArray = [QueryDocumentSnapshot]()
        
        
        var groupAndMessageDictionary = [String:[Message]]()
        //gets all the group documents
        ref.getDocuments{ (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil , error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no saved messages from anygroup")
                completion(messages , nil)
                return
            }
                //set variable doccount that is equal to the counts of documents.
                
             
                var docCount = documents.count
            //for each document in documents, get all the message documents in the collection messages.
                documents.forEach { (document) in
                let messageRef = ref.document(document.documentID).collection("Messages")
                messageRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        completion(nil , error)
                    }
                   
                    guard let messageDocuments = snapshot?.documents else {
                        print("no messages")
                        //completion(messages , nil)
                        return
                    }
                    if messageDocuments.isEmpty{
                        ref.document(document.documentID).delete { (error) in
                            if let error = error{
                            completion(nil , error)
                            }
                            print("Deleted document")
                        }
                    }
                    //store the message document for each of the documents  in an array.
                    messageDocumentArray.append(contentsOf: messageDocuments)
                    
                    docCount -= 1
                    
                    //if document count == 0. it has gone through all the documents and gotten the contents then loop into the message document array and append the messages to a message array and send back to front end.
                    if docCount == 0{
                    messageDocumentArray.forEach { (document) in
                        let message = self.changeDictionaryToMessage(document.data())
                        messages.append(message)
                        print(message.content.content as! String , "this is from  loadmessageswithgroup",message.content.type.rawValue)
                        if messages.count == messageDocumentArray.count {
                            completion(messages, nil)
                            return
                        }
                    }}
            }
                }
            }
            
        
    }
    
    func loadSavedMessagesFromSettings2(user:FireUser, completion: @escaping ([String:[Message]]?,Error?)-> ()){
        
        
        let ref =         FireService.users.document(user.email).collection(FireService.savedMessages)
        
        var messageDocumentArray = [QueryDocumentSnapshot]()
        
        var groupAndSnapshotDictionary = [String:[QueryDocumentSnapshot]]()
        var groupAndMessageDictionary = [String:[Message]]()
        //gets all the group documents
        ref.getDocuments{ (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil , error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no saved messages from anygroup")
                completion(groupAndMessageDictionary , nil)
                return
            }
                //set variable doccount that is equal to the counts of documents.
                
             
                var docCount = documents.count
            //for each document in documents, get all the message documents in the collection messages.
                documents.forEach { (document) in
                let messageRef = ref.document(document.documentID).collection("Messages")
                messageRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        completion(nil , error)
                    }
                   
                    guard let messageDocuments = snapshot?.documents else {
                        print("no messages")
                        //completion(messages , nil)
                        return
                    }
                    if messageDocuments.isEmpty{
                        ref.document(document.documentID).delete { (error) in
                            if let error = error{
                            completion(nil , error)
                            }
                            print("Deleted document")
                        }
                    }
                    //store the message document for each of the documents  in an array.
                    messageDocumentArray.append(contentsOf: messageDocuments)
                    groupAndSnapshotDictionary["\(document.documentID)"] = messageDocuments
                    docCount -= 1
                    
                    //if document count == 0. it has gone through all the documents and gotten the contents then loop into the message document array and append the messages to a message array and send back to front end.
                    var docIDCount = groupAndSnapshotDictionary.keys.count
                    if docCount == 0{
                        for(documentID,messageSnapShot) in groupAndSnapshotDictionary{
                            messages.removeAll()
                            messageSnapShot.forEach { (document) in
                                let message = self.changeDictionaryToMessage(document.data())
                                messages.append(message)
                                
                                groupAndMessageDictionary[documentID] = messages
                                
                            }
                            docIDCount -= 1
                            if docIDCount == 0 {
                                completion(groupAndMessageDictionary, nil)
                                return
                            }
                    }
                        
                    }
            }
                }
            }
            
        
    }
    
    
    func deleteAllSavedMessages(user : FireUser, group:Group, MessageToDelete: [Message], completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        for message in MessageToDelete {
            let ref =         FireService.users.document(user.email).collection(FireService.savedMessages).document(group.id).collection("Messages").document(message.id)
            
            ref.delete { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(true))
                
            }
        }
    }
    
    
    func deleteOneSavedMessage(user : FireUser, group:Group, MessageToDelete: Message, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        let ref = FireService.users.document(user.email).collection(FireService.savedMessages).document(group.id).collection("Messages").document(MessageToDelete.id)
        
        ref.delete { (error) in
            
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(true))
            
        }
        
    }
    
    func deleteSavedMessageFromSettings(user : FireUser, MessageToDelete: Message, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    
    let ref =         FireService.users.document(user.email).collection(FireService.savedMessages)
        
//            .document(group.id).collection("Messages")
    //listening for new messages
    ref.getDocuments{ (snapshot, error) in
        if let error = error {
            completionHandler(.failure(error))
        }
        //unwarps documents
        guard let documents = snapshot?.documents else {
            print("no saved messages from anygroup")
            completionHandler(.success(true))
            return
        }
        if documents.count > 0 {
        documents.forEach { (document) in
            let messageRef = ref.document(document.documentID).collection("Messages")
            messageRef.getDocuments { (snapshot, error) in
                if let error = error {
                    completionHandler(.failure(error))
                }
                guard let messageDocuments = snapshot?.documents else {
                    print("no messages")
                    //completion(messages , nil)
                    return
                }
                messageDocuments.forEach { (document) in
                    if MessageToDelete.id == document.documentID{
                        messageRef.document(MessageToDelete.id).delete { (error) in
                            if let error = error{
                            completionHandler(.failure(error))
                            }
                            completionHandler(.success(true))
                            
                        }
                    }
                }}

        }
        }else{
            completionHandler(.success(true))
        }
        
    }
    }
    func clearChatGroups(user : FireUser, group:Group, MessageToDelete: [Message], completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        for message in MessageToDelete {
            let ref =         FireService.users.document(user.email).collection(FireService.groupString).document(group.id).collection("messages").document(message.id)
            
            ref.delete { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(true))
                
            }
        }
    }
    func clearChatFriends(user : FireUser, friend:Friend, MessagesToDelete: [Message], completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        for message in MessagesToDelete {
            let ref =         FireService.users.document(user.email).collection("friends").document(friend.email).collection("messages").document(message.id)
            
            ref.delete { (error) in
                
                if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(true))
                
            }
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
    
    
    
    /// Deletes the profile picture of a user
    /// - Parameters:
    ///   - user: User whose profile picture is to be deleted
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func DeleteGroupPicture(user : FireUser, group:Group,friends:[Friend], completionHandler : @escaping (Result<Bool , Error>)-> ()){
        
        
        let refName = "\(group.id)/groupPicture.png"
        let ref = FireService.storageRef.child(refName)
        ref.delete { (error) in
            if let error = error{
                completionHandler(.failure(error))
                return
            }
            for friend in friends{
                let ref = FireService.users.document(friend.email).collection(FireService.groupString).document(group.id)
                ref.updateData(["groupPictureUrl":FieldValue.delete()]) { (error) in
                    
                    if let error = error{
                        completionHandler(.failure(error))
                        return
                    }
                    
                    
                    completionHandler(.success(true))
                    return
                    
                }
                
            }
            
        }
        
    }
    
    //Updating this to send
    func sendMessageToFriend(User : FireUser, message : Message , freind : Friend ,completion : @escaping (Bool , Error?) -> ()){
        
        let newSendRef = FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages").document("\(message.id)")
        
        let newReceivedRef = FireService.users.document(freind.email).collection(FireService.firendsString).document(User.email).collection("messages").document("\(message.id)")
        
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
    
    enum NotificationType {
        case FriendRequest
        case GroupInvitation
        case Misc
    }
    //Updating this to send
//    func notificationDelete(_ id:String,completion : @escaping (Bool , Error?) -> ()){
//        print("notificationDelete")
//        FireService.users.document(globalUser.toFireUser.email).collection("Notifications").document(id).delete() { err in
//            if let err = err {
//                print("notificationDelete ERROR")
//                completion(false,err)
//            } else {
//                print("notificationDelete SUCCESS")
//                completion(true,nil)
//            }
//        }
//    }
    
    func notificationDelete(_ id:String, completion : @escaping (Bool , Error?) -> ()) {
        print("notificationDelete \(id)")
        let ref = FireService.users.document(globalUser.toFireUser.email).collection("Notifications").document(id)
        ref.delete { (error) in
            if let error = error{
                completion(false,error)
                return
            }
            completion(true,nil)
        }
    }
    
    
    func notification(_ notificationType: NotificationType,_ sender : FireUser,_ dynamicLink : String, _ friendEmail:String,_ notificationTitle:String,_ notificationSubtitle:String,completion : @escaping (Bool , Error?) -> ()){
        print("notification log")
        let newNotificationRef = FireService.users.document(friendEmail).collection("Notifications")
        
        let photoUrl = sender.profileImageUrl
        let uuid = NSUUID().uuidString
        var notificationKey = ""
        switch notificationType{
            case .FriendRequest:
                notificationKey = "friend_request"
//                FireService.sharedInstance.getProfilePicture(user: globalUser.toFireUser) {  (result) in
//                    switch result{
//                    case .success(let url):
//                        photoUrl = url.absoluteString
//                    case .failure(_):
//                        print("failed to set image url")
//                    }
//                }
                break
            case .GroupInvitation:
                notificationKey = "group_request"
//                FireService.sharedInstance.getProfilePicture(user: globalUser.toFireUser) {  (result) in
//                    switch result{
//                    case .success(let url):
//                        photoUrl = url.absoluteString
//                    case .failure(_):
//                        print("failed to set image url")
//                    }
//                }
                break
            case .Misc:
                notificationKey = "misc"
                break
        }
        let post : [String:Any] = ["id": uuid,
                   "notification_type": notificationKey,
                   "user_id": sender.id,
                    "user_name": sender.name,
                    "user_email": sender.email,
                    "dynamicLink": dynamicLink,
                    "title": notificationTitle,
                    "subtitle": notificationSubtitle,
                    "photo_url": photoUrl,
                    "timeStamp": Date()]
        newNotificationRef.document(uuid).setData(post){ (error) in
            if let error = error {
                completion(false, error)
            }
            completion(true, nil)
        }
    }
    func getNotificationLog(completion : @escaping ([NotificationModel]? , Error?) -> ()){
        var data : [String : Any] = [:]
        let query = FireService.users.document(globalUser.toFireUser.email).collection("Notifications").order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error{
                completion(nil , error)
                return
            }
            guard let documents = snapshot?.documents else{return}
            var count = documents.count
          //  if count != 0 {
                var notificationList : [NotificationModel] = [NotificationModel]()
                for document in documents{
                    data = document.data()
                    
                    let post = NotificationModel.init(((data["id"] as? String) != nil) ? data["id"] as! String : "",
                                           ((data["notification_type"] as? String) != nil) ? data["notification_type"] as! String : "",
                                           ((data["user_id"] as? String) != nil) ? data["user_id"] as! String : "",
                                           ((data["user_name"] as? String) != nil) ? data["user_name"] as! String : "",
                                           ((data["user_email"] as? String) != nil) ? data["user_email"] as! String : "",
                                           ((data["dynamicLink"] as? String) != nil) ? data["dynamicLink"] as! String : "",
                                           ((data["title"] as? String) != nil) ? data["title"] as! String : "",
                                           ((data["subtitle"] as? String) != nil) ? data["subtitle"] as! String : "",
                                           ((data["photo_url"] as? String) != nil) ? data["photo_url"] as! String : "",
                                           ((data["timeStamp"] as? Date) != nil) ? data["timeStamp"] as! Date : Date())
                    
                    print(data["timeStamp"])
                    print(data["timeStamp"] as? Date)
                    notificationList.append(post)
                    print("notificationList is here:\(notificationList)")
                    count -= 1
                    print("count -= 1 =\(count)")
                    if(count == 0){
                        print("notificationList when count is zero:\(notificationList)")
                        completion(notificationList, nil)
                    }
                }
          //  }
//            else if count == 0 {
//
//                completion([NotificationModel](), nil)
//                print("no notification log")
//            }else{
//                print("notication log \(count)")
//            }
        }
    }
    
    
    
    
    /// Retrieves the profile picture of a user.
    /// - Parameters:
    ///   - user: User whose profile picture is to be retrieved
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    /// - Returns:
    
    
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
    /// Uploads the profile picture of a user
    /// - Parameters:
    ///   - data: The data containing image to be saved
    ///   - user: User whose profile picture is to be uploaded
    ///   - completionHandler: Completion handler to determine if the function completed correctly or with errors
    func saveGroupPicture(data : Data , user : FireUser , group:Group,friend:[Friend], completionHandler: @escaping (Result<Bool, Error>) -> Void){
        let refName = "\(group.id)/groupPicture.png"
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
                let data = ["groupPictureUrl" : url.absoluteString]
                
                self.addCustomDataToAllFriendsInGroup(data: data ,user : globalUser.toFireUser , group:group, friends: friend) { (error, sucess) in
                    if let error = error {
                        print(error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                    if sucess{
                        print("Added group picture data to all group friends")
                        completionHandler(.success(true))
                    }
                    
                }
                
            })
        }
    }
    
    func getGroupPictureData(user : FireUser , group:Group, completionHandler : @escaping (Result<URL, Error>)-> ()){
        
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        groupRef.getDocument { (documents, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let data = documents?.data() else {return}
            
            if let url = data["groupPictureUrl"] as? String {
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
    func getGroupPictureDataFromChatLog(user : FireUser , group:Group, completionHandler : @escaping (URL?,Bool,Error?)-> ()){
        
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        groupRef.getDocument { (documents, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let data = documents?.data() else {return}
            
            if let url = data["groupPictureUrl"] as? String {
                if  let finalUrl = URL(string: url){
                    completionHandler(finalUrl,true,nil)
                }else{
                    print("couldnt cast to url")
                }
            }else{
                completionHandler(nil,false,nil)
                print("couldnt cast to string")
            }
        }
        
        
    }

    func getFriendPictureData(user : FireUser , friend:Friend, completionHandler : @escaping (Result<URL , Error>)-> ()){
        
        
        let groupRef = FireService.users.document(friend.email)
        groupRef.getDocument { (documents, error) in
            
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
    func getFriendPictureDataFromFriendVC(user : FireUser , friend:Friend, completionHandler : @escaping (URL?,Bool,Error?)-> ()){
        
        let ref = FireService.users.document(friend.email)
        ref.getDocument { (documents, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let data = documents?.data() else {return}
            
            if let url = data["profileImageUrl"] as? String {
                if  let finalUrl = URL(string: url){
                    completionHandler(finalUrl,true,nil)
                }else{
                    print("couldnt cast to url")
                }
            }else{
                completionHandler(nil,false,nil)
                print("couldnt cast to string")
            }
        }
        
        
    }

    
    
    

    func saveImageToBeSentToFriend (data : Data , friend : Friend , user : FireUser , completionHandler: @escaping (String?,Error?) -> ()) {
        
        
        let uuid = NSUUID().uuidString
        
        let refName = "\(user.email)/\(friend.id)/Images.png/\(uuid)"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        ref.putData(data, metadata: newMetadata) { (metadata, error) in
            if let error = error{
                completionHandler(nil,error)
            }
            
            
            ref.downloadURL { (url, error) in
                guard let url = url else{
                    completionHandler(nil,error)
                    return
                }
                
                
                let finalUrl = url.absoluteString
                completionHandler(finalUrl,nil)
                
            }
        }
        
        
    }
    
    
    func saveImageToBeSentToGroupChat(data:Data,user:FireUser,group:Group,completionHandler: @escaping (String?,Error?) -> ()){
        
        let uuid = NSUUID().uuidString
        
        let refName = "\(user.email)/\(group.id)/groupChatImages.png/\(uuid)"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        ref.putData(data, metadata: newMetadata) { (metadata, error) in
            if let error = error{
                completionHandler(nil,error)
            }
            
            
            ref.downloadURL { (url, error) in
                guard let url = url else{
                    completionHandler(nil,error)
                    return
                }
                
                
                let finalUrl = url.absoluteString
                completionHandler(finalUrl,nil)
                
            }
        }
    }
    
    func thumbnailImageForFileUrl(fileUrl:NSURL) -> UIImage?{
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func sendVideoToFriend(url : NSURL ,friend : Friend , user : FireUser,completionHandler: @escaping (String?,Error?,[String:Any?]) -> ()){
        let uuid = NSUUID().uuidString
        
        let refName = "\(user.email)/\(friend.id)/Videos.mov/\(uuid)"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        var properties = [String:Any]()
        newMetadata.contentType = "video/quicktime"
        
        
        do{
            let videoData = try Data(contentsOf: url as URL)
            let uploadTask = ref.putData(videoData, metadata: newMetadata){ (metadata, error) in
                if let error = error{
                    completionHandler(nil,error,properties)
                }
                
                
                ref.downloadURL { (videoUrl, error) in
                    guard let videoUrl = videoUrl else{
                        completionHandler(nil,error,properties)
                        return
                    }
                    let finalUrl = videoUrl.absoluteString
                    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl:url){
                        properties = ["thumbNailWidth":thumbnailImage.size.width,"thumbNailHeight":thumbnailImage.size.height,"thumbNailImage":thumbnailImage]
                    }
                    
                    
                    print(finalUrl)
                    completionHandler(finalUrl,nil,properties)
                    
                }
            }
            //use to get progress update
            uploadTask.observe(.progress) { (snapshot) in
                if let completedUnitCount = snapshot.progress?.completedUnitCount{
                    print(completedUnitCount)
                }
                //get if the task is successful
                uploadTask.observe(.success) { (snapshot) in
                    print("Yupppp")
                }
                
            }
            
        }catch {
            print(error)
        }
        
        
        
    }
    
    
    func saveVideoToBeSentToGroupChat(url:NSURL,user:FireUser,group:Group,completionHandler: @escaping (String?,Error?,[String:Any?]) -> ()){
        
        let uuid = NSUUID().uuidString
        
        let refName = "\(user.email)/\(group.id)/groupChatVideos.mov/\(uuid)"
        let ref = FireService.storageRef.child(refName)
        let newMetadata = StorageMetadata()
        var properties = [String:Any]()
        newMetadata.contentType = "video/quicktime"
        
        
        
        do {
            let videoData = try Data(contentsOf: url as URL)
            let uploadTask = ref.putData(videoData, metadata: newMetadata){ (metadata, error) in
                if let error = error{
                    completionHandler(nil,error,properties)
                }
                
                
                ref.downloadURL { (videoUrl, error) in
                    guard let videoUrl = videoUrl else{
                        completionHandler(nil,error,properties)
                        return
                    }
                    let finalUrl = videoUrl.absoluteString
                    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl:url){
                        properties = ["thumbNailWidth":thumbnailImage.size.width,"thumbNailHeight":thumbnailImage.size.height,"thumbNailImage":thumbnailImage]
                    }
                    
                    
                    print(finalUrl)
                    completionHandler(finalUrl,nil,properties)
                    
                }
            }
            //use to get progress update
            uploadTask.observe(.progress) { (snapshot) in
                if let completedUnitCount = snapshot.progress?.completedUnitCount{
                    print(completedUnitCount)
                }
                //get if the task is successful
                uploadTask.observe(.success) { (snapshot) in
                    print("Yupppp")
                }
                
            }
            
        } catch {
            print(error)
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
            print(groups,"Groups")
            var count = groups.count
            groups.forEach { (group) in
                let activity = Activity(activityType: .GroupChat(group: group))
                count -= 1
                activities.append(activity)
                if count == 0 {
                    self.loadAllFriends(user: User) { (friends, error) in
                        if let error = error{
                            completion(nil , error)
                        }
                        guard let friends = friends else {fatalError()}
                        if friends.isEmpty{
                            completion(activities,nil)
                        }
                        print(friends,"Friends")
                        friends.forEach { (freind) in
                            let activity = Activity(activityType: .FriendChat(friend: freind))
                            activities.append(activity)
                            completion(activities , nil)
                        }
                        
                    }
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
        
        friends.order(by: "name", descending: true).getDocuments{ (snapshot, error) in
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
                "timecreated":user.timeCreated,"deviceToken":user.deviceToken
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
        
        return [ "id": message.id, "Content" :self.changeContentToDictionary(message.content),
                 "user":self.changeUserToDictionary(message.sender),
                 "timeStamp": message.timeStamp,
                 "recived": message.recieved
        ]
    }
    
    func changeDictionaryToMessage( _ dict : [String : Any]) -> Message {
        
        let contentDictionary = dict["Content"] as! [String : Any]
        
        let userDictionary = dict["user"] as! [String : Any]
        
        let date = (dict["timeStamp"] as! Timestamp).dateValue()
        
        let recieved = dict["recived"] as! Bool
        
        let id = dict["id"] as! String
        
        return Message(id:id,content: self.changeDictionaryToContent(dictionary: contentDictionary), sender: self.changeDictionaryToFireUser(data: userDictionary), timeStamp: date, recieved: recieved)
    }
    
    
    
    
    
    /// Function to turn the provided data to create a FireUser
    /// - Parameter data: Data inputted in the form of dictionary that will be used to create a FireUser
    /// - Returns: Created FireUser with the data that was provided in the function's parameter
    func changeDictionaryToFireUser(data : ([String : Any])) -> FireUser{
        var user_id = ""
        var user_name = ""
        var user_email = ""
        var user_token = ""
        var profile_ImageUrl = ""
        var user_status = ""
        var user_creationDate = Date()
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
    ///   - hashKey: Email used to determine if a FireUser is associated with this email address
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func searchOneFriendWithhashKey(hashKey : String,completion : @escaping (FireUser? , Error?) -> ()){
        var data : [String : Any] = [:]
        let query = FireService.users.whereField("hashKey", isEqualTo: hashKey)
        query.getDocuments { (snapshot, error) in
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
                self.snackbar("email does not exists")
            }
                
            else{
                fatalError("This shouldnt be happening")
                
            }
        }
    }
    /// Function to determine if a FireUser is associated to an email address
    /// - Parameters:
    ///   - email: Email used to determine if a FireUser is associated with this email address
    ///   - completion: Completion handler to determine if the function completed correctly or with errors
    /// - Returns: Nothing
    func searchOneUserWithEmail(email : String,completion : @escaping (FireUser? , Error?) -> ()){
        let email1 = email.lowercased().replace(this: " ", with: "")
        var data : [String : Any] = [:]
        let query = FireService.users.whereField("email", isEqualTo: email1)
        
        
        query.getDocuments { (snapshot, error) in
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
                self.snackbar("email does not exists")
            }
                
            else{
                fatalError("This shouldnt be happening")
                
            }
        }
    }
    
    //This function checks for the device token for 1-1 chats
    // this function is for getting the group member device token
        func searchDeviceToken(email : String,completion : @escaping (String? , Error?) -> ()){
            let email1 = email.lowercased().replace(this: " ", with: "")
            var data : [String : Any] = [:]
            let query = FireService.users.whereField("email", isEqualTo: email1)
            query.getDocuments { (snapshot, error) in
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
                        if let token = data["deviceToken"] as? String{
                            completion(token, nil)
                        }
                        return
                    }
                }
                if count == 0 {
                    self.snackbar("email does not exists")
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
        let email1 = email.lowercased().replace(this: " ", with: "")
        var data : [String : Any] = [:]
        let query = FireService.users.whereField("email", isEqualTo: email1)
        
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
                self.snackbar("email does not exists")
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
            print("I have found the data-\(data)")
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
                    "timecreated":user.timeCreated,"deviceToken":user.deviceToken] as [String : Any]
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
    func addCustomDataToGroup(data : [String : Any] ,user : FireUser , group:Group, completion : @escaping (Error? , Bool) -> ()) {
        FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).setData(data, merge: true) { (error) in
            if let error = error{
                completion(error , false)
                return
            }
            //UserDefaults.standard.set(user, forKey: "user")
            completion(nil , true)
        }
        
    }
    //add group picture data to all the users in the group
    func addCustomDataToAllFriendsInGroup(data: [String : Any] ,user : FireUser , group:Group, friends:[Friend], completion : @escaping (Error? , Bool) -> ()){
        
        for friend in friends{
            let ref = FireService.users.document(friend.email).collection(FireService.groupString).document(group.id)
            ref.setData(data, merge: true) { (error) in
                if let error = error{
                    completion(error , false)
                    return
                }
                //UserDefaults.standard.set(user, forKey: "user")
                completion(nil , true)
            }
        }
    }
    
    func addCustomGroupNameData(data : [String : Any] ,user : FireUser, group:Group,friends:[Friend], completion : @escaping (Error? , Bool, Bool) -> ()){
        
        let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        var isAdmin = false
        
        //get all the group documents
        groupRef.getDocument { (document, error) in
            if let error = error{
                
                completion(error,false,isAdmin)
                return
            }
            //check document and unwrap groupdata to get groupadmin
            if let document = document{
                guard let groupData = document.data() else {return}
                let admin = groupData["groupadmin"] as! String
                
                //check if admin is the global user and set data(change group name in group for admin) and return completion of true
                if admin == globalUser?.email{
                    
                    //                    let ref = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
                    
                    for friend in friends {
                        let ref = FireService.users.document(friend.email).collection(FireService.groupString).document(group.id)
                        ref.setData(data, merge: true) { (error) in
                            if let error = error{
                                completion(error, false, isAdmin)
                                return
                            }
                            isAdmin = true
                            completion(nil,true,isAdmin)
                            
                        }
                    }
                    
                }
                    //else change groupname for all the members of the group and return completion of true but admin completion of false.
                else{
                    isAdmin = false
                    completion(nil,false,false)
                }
            }
        }
        
        
        
    }
    
    
    func assignAdminAndLeaveGroup(data : [String : Any] ,user : FireUser, group:Group,friends:[Friend], completion : @escaping (Error? , Bool, [String:Any]?) -> ()){
        let oldGroupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(user.email)
        let groupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        var newFriends = [Friend]()
        var dataToBeSent = [String:Any]()
        let newAdmin = data["groupadmin"] as! String
        
        //get all the group documents
        groupRef.getDocument { (document, error) in
            if let error = error{
                
                completion(error,false,dataToBeSent)
                return
            }
            //check document and unwrap groupdata to get groupadmin
            if let document = document{
                guard let groupData = document.data() else {return}
                let admin = groupData["groupadmin"] as! String
                
                
                FireService.sharedInstance.searchOneUserWithEmail(email: newAdmin) { (user, error) in
                    if let error = error {
                        print("could not find group admin user while adding new user to group",error.localizedDescription)
                        
                        return
                    }
                    guard let user = user else {return}
                    let finalGroup = Group(GroupAdmin: user, id: group.id, name: group.name)
                    
                    
                    for friend in friends{
                        if admin != friend.email{
                            newFriends.append(friend)
                        }
                    }
                    
                    dataToBeSent["user"] = user
                    dataToBeSent["group"] = finalGroup
                    dataToBeSent["friends"] = newFriends
                    
                    var count = newFriends.count
                    for friend in friends {
                        
                        let ref = FireService.users.document(friend.email).collection(FireService.groupString).document(group.id)
                        let oldGroupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(friend.email)
                        let oldGroupDataRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
                        ref.setData(data, merge: true) { (error) in
                            if let error = error{
                                completion(error, false, dataToBeSent)
                                return
                            }
                            print("Data successfully set")
                            oldGroupRef.delete { (error) in
                                if let error = error{
                                    completion(error, false, dataToBeSent)
                                    print(error.localizedDescription)
                                    return
                                }
                                oldGroupDataRef.updateData(["groupInvitationUrl":FieldValue.delete()]) { (error) in
                                    
                                    if let error = error{
                                       completion(error, false, dataToBeSent)
                                        return
                                    }
                                   
                                }
                            
                            }

                            count -= 1
                    if count == 0{
                            self.addAdminToGroup(user: user, group: finalGroup, freind: finalGroup.GroupAdmin.asAFriend) { (result) in
                                switch result{
                                case .success(_):
                                    self.addMultipleFriendsToGroup(user: user, group: finalGroup, friendsToAdd: newFriends) { (result) in
                                        switch result {
                                        case .success( let bool):
                                            if bool || !bool {

                                                completion(nil,true,dataToBeSent)
                                            
                                                print("Successfully added to group")
      
                                            }
                                            
                                        case .failure(let error):
                                            //complete with with error
                                            completion(error,false,dataToBeSent)
                                        }
                                    }
                                    return
                                case .failure(_):
                                    completion(error,false,dataToBeSent)
                                    return
                                }
                                
                            }
                            }
                            
                        }
                    }
                }
                //check if admin is the global user and set data(change group name in group for admin) and return completion of true
                
                
            }
        }
    }
    
    func assignNewAdmin(data : [String : Any] ,user : FireUser, group:Group,friends:[Friend], completion : @escaping (Error? , Bool, [String:Any]?) -> ()){
        let oldGroupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(user.email)
        let groupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        var newFriends = [Friend]()
        var dataToBeSent = [String:Any]()
        let newAdmin = data["groupadmin"] as! String
        
        //get all the group documents
        groupRef.getDocument { (document, error) in
            if let error = error{
                
                completion(error,false,dataToBeSent)
                return
            }
            //check document and unwrap groupdata to get groupadmin
            if let document = document{
                guard let groupData = document.data() else {return}
                let admin = groupData["groupadmin"] as! String
                
                
                FireService.sharedInstance.searchOneUserWithEmail(email: newAdmin) { (user, error) in
                    if let error = error {
                        print("could not find group admin user while adding new user to group",error.localizedDescription)
                        
                        return
                    }
                    guard let user = user else {return}
                    let finalGroup = Group(GroupAdmin: user, id: group.id, name: group.name)
                    
                    
                    
                    dataToBeSent["user"] = user
                    dataToBeSent["group"] = finalGroup
                    dataToBeSent["friends"] = friends
                    
                    var count = friends.count
                    
                        
    
        
                            for friend in friends {
                            let ref = FireService.users.document(friend.email).collection(FireService.groupString).document(group.id)
                                let oldGroupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(friend.email)
                                let oldGroupDataRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
                                ref.setData(data, merge: true) { (error) in
                                    if let error = error{
                                        completion(error, false, dataToBeSent)
                                        return
                                    }
                                    print("Data successfully set")
                                    oldGroupRef.delete { (error) in
                                        if let error = error{
                                            completion(error, false, dataToBeSent)
                                            print(error.localizedDescription)
                                            return
                                        }
                                        oldGroupDataRef.updateData(["groupInvitationUrl":FieldValue.delete()]) { (error) in
                                            
                                            if let error = error{
                                               completion(error, false, dataToBeSent)
                                                return
                                            }
                                           
                                        }
                                    }
                                    
                                    count -= 1
                            if count == 0{
                                    self.addAdminToGroup(user: user, group: finalGroup, freind: finalGroup.GroupAdmin.asAFriend) { (result) in
                                        switch result{
                                        case .success(_):
                                            self.addMultipleFriendsToGroup(user: user, group: finalGroup, friendsToAdd: friends) { (result) in
                                                switch result {
                                                case .success( let bool):
                                                    if bool || !bool {
                                                           completion(nil,true,dataToBeSent)
                                                        print("Successfully added to group")
                                           
                                                    }
                                                    
                                                case .failure(let error):
                                                    //complete with with error
                                                    completion(error,false,dataToBeSent)
                                                }
                                            }
                                            return
                                        case .failure(_):
                                            completion(error,false,dataToBeSent)
                                            return
                                        }
                                        
                                    
                                    }
                                }
                                
                            
                        }

                    }
                }
                //check if admin is the global user and set data(change group name in group for admin) and return completion of true
                
                
            }
        }
    }
    func leaveGroup(user : FireUser, group:Group,friends:[Friend],completion : @escaping (Error? , Bool) -> ()){

    
        let groupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(user.email)
        let groupDataRef = FireService.users.document(user.email).collection(FireService.groupString).document(group.id)
 
        
        groupRef.delete { (error) in
            if let error = error{
                completion(error,false)
                return
            }
            groupDataRef.updateData(["groupInvitationUrl":FieldValue.delete()]) { (error) in
                
                if let error = error{
                   completion(error, false)
                    return
                }
                completion(nil,true)
               
            }

               
            }
 
    }
    func deleteFriendFromGroup(user : FireUser, group:Group,friend:Friend,completion : @escaping (Error? , Bool) -> ()){
        let groupRef = FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(friend.email)
        groupRef.delete { (error) in
            if let error = error{
                completion(error,false)
                return
            }
                completion(nil,true)
            }
    }
    func deleteFriend(user : FireUser, friend:Friend,completion : @escaping (Error? , Bool) -> ()){
        let groupRef = FireService.users.document(user.email).collection(FireService.firendsString).document(friend.email)
        groupRef.delete { (error) in
            if let error = error{
                completion(error,false)
                return
            }

                completion(nil,true)
            }
        
        
    }
    
    func dissolveGroup(user : FireUser, group:Group,completion : @escaping (Error? , Bool) -> ()){
        let groupRef = FireService.users.document(user.email).collection(FireService.groupString).document(group.id).collection("Freinds").document(user.email)
        groupRef.delete { (error) in
            if let error = error{
                completion(error,false)
            }
            completion(nil,true)
        }
    }
    func getGroupname(user : FireUser, group:Group,completionHandler : @escaping (Group?,Bool,Error?)-> ()){
        let groupRef =  FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
        var group:Group?
        groupRef.getDocument { (document, error) in
            if let error = error{
                
                completionHandler(group,false,error)
                return
            }
            if let document = document{
                guard let data = document.data() else {return}
                
                let id = data["groupid"] as! String
                let name = data["groupname"] as! String
                let admin = data["groupadmin"] as! String
                
                self.searchOneUserWithEmail(email: admin) { (fireuser, error) in
                    if let error = error{
                        completionHandler(group,false,error)
                        return
                    }
                    group = Group(GroupAdmin: fireuser!, id: id, name: name)
                    completionHandler(group,true,error)
                }
            }
        }
        
    }
    
    func getGroupURL(user : FireUser, group:Group,completion : @escaping (String?,Bool,Error?)-> ()){
        var url = String()
        let groupRef =  FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
            
            groupRef.getDocument { (snapshot, error) in
            if let error = error {
                      completion(url,false,error)
                  }
                  //unwarps documents
                guard let data = snapshot?.data() else {
                      print("no messages")
                      completion(url,false,error)
                      return
                  }
            
             let url = data["groupInvitationUrl"] as! String
                
                completion(url,true,nil)

           
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
    //    func createGroup(group : Group ,completion : @escaping (Bool, Error?) -> ()){
    //
    //        let data = ["groupname":group.name, "groupadmin" : group.GroupAdmin.email, "groupid": group.id] as [String : Any]
    //        FireService.users.document(group.GroupAdmin.email).collection("groups").document(group.name).setData(data, merge: true) { (error) in
    //
    //            if let error = error {
    //                completion(false, error)
    //                return
    //            }
    //            //add the groupadmin as a friend in the group
    //            self.addFriendToGroup(user: group.GroupAdmin, group: group, freind: group.GroupAdmin.asAFriend) { (result) in
    //                switch result{
    //                case .success(_):
    //                    completion(true, nil)
    //                    return
    //                case .failure(_):
    //                    completion(false , error)
    //                    return
    //                }
    //            }
    //
    //
    //
    //        }
    //
    //    }
    //tested
    func createGroupFromReceivingDynamicLink(user : FireUser, group : Group , friend : Friend,completion : @escaping (Bool, Error?) -> ()){
        
        
        self.addFriendToGroup(user: user, group: group, freind: friend) { (result) in
            switch result {
                
            case .success(let bool):
                completion(bool , nil)
            case .failure(let error):
                completion(false ,error)
            }
        }
        
        /*
         let data = ["groupname":groupname, "groupadmin" : groupAdmin, "groupid": groupID] as [String : Any]
         FireService.users.document(currentUserEmail).collection("groups").document(groupname).setData(data, merge: true) { (error) in
         
         if let error = error {
         completion(false, error)
         return
         }
         completion(true, nil)
         
         }
         */
        
    }
    
    
    //need to test
    func deleteGroup (group: Group){
        FireService.users.document(group.GroupAdmin.email).collection("groups").document(group.name).delete()
    }
    
    
    //need to test
    func addFriend(user:FireUser,sender :FireUser ,friend : Friend , completion : @escaping (Bool , Error?) -> ()) {
        
        let data = ["name" : friend.username,
                    "email":friend.email,
                    "id": friend.id] as [String : Any]
        let data2 = ["name" : sender.name,
                    "email":sender.email,
                    "id": sender.id] as [String : Any]
        
        if friend.email == sender.email {
            fatalError("you cannot add yourself")
        }
        
        loadAllFriends(user: user) { (friends, error) in
            if let freinds = friends{
                if freinds.contains(friend){
                    print("you have already added this person")
                    completion(true , nil)
                    return
                }else{
                    FireService.users.document(sender.email).collection(FireService.firendsString).document(friend.email).setData(data) { (error) in
                        if let error = error {
                            completion(false, error)
                        }else{
                            FireService.users.document(friend.email).collection(FireService.firendsString).document(sender.email).setData(data2) { (error) in
                                if let error = error {
                                completion(false, error)
                                }
                                completion(true , nil)
                                return
                            }
                          
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
    
    
    
    
    
    
    
    /// Loads all messges with with a freind
    /// - Parameters:
    ///   - User: a fireuser
    ///   - freind: a firend object
    ///   - completion: complets with a list of messages if messages exsistes else complets with empty list
    /// - Returns: None
    func loadMessagesWithFriend(User : FireUser, freind : Friend ,completion : @escaping ([Message]? , Error?) -> ()){
        //refrenec to the collaction with all messages
        let ref =           FireService.users.document(User.email).collection(FireService.firendsString).document(freind.email).collection("messages")
        
        //gets all the documents
        ref.addSnapshotListener { (snapshot, error) in
            var messages : [Message] = []
            if let error = error {
                completion(nil ,error)
            }
            //unwarps documents
            guard let documents = snapshot?.documents else {
                print("no messages")
                completion(messages , nil)
                return
            }
            
            documents.forEach { (document) in
                let message = self.changeDictionaryToMessage(document.data())
                messages.append(message)
                if messages.count == documents.count {
                    completion(messages , nil)
                    return
                }
            }
        }
    }
    
    
    
    
    
    //    //need testing
    //    /// Add Freinds to a roup by making  network call. Completes with true if it was sucessful
    //    /// - Parameters:
    //    ///   - user: The user currently using the application
    //    ///   - group: The group the user is in
    //    ///   - completionHandler: completes with true if the network call was sucessful, or faliure if the etwork call was unsucesfull
    //    /// - Returns: None
    //    func addFriendToGroup(user : FireUser , group : Group ,freind : Friend, completionHandler : @escaping (Result<Bool , Error>)-> ()){
    //         let groupRef =         FireService.users.document(group.GroupAdmin.email).collection(FireService.groupString).document(group.id)
    //        let frieindAsData = self.changeFriendToDictionary(freind)
    //
    //        groupRef.collection("Freinds").addDocument(data: frieindAsData) { (error) in
    //            if let error = error{
    //                completionHandler(.failure(error))
    //            }
    //
    //            completionHandler(.success(true))
    //        }
    //
    //    }
    //
    //
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
                    let groupRef =         FireService.users.document(friend.email).collection(FireService.groupString).document(group.id).collection("messages").document("\(message.id)")
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
    
    
    
    
    
    
    
    
    
    
    
    //    //need to test
    //    func deleteFriendsFromGroup(group: Group, groupID: Int, friendsToDelete: [Friend]){
    //
    //        if friendsToDelete.count == 0 {return}
    //
    //        for friend in friendsToDelete {
    //
    //            // To be able to compare two Friends objects, we needed the Friend class to inherit the Equatable class. See the Friend class.
    //            if (group.friends.contains(friend)) {
    //
    //                guard let index = group.friends.firstIndex(of: friend) else { return }
    //
    //                group.friends.remove(at: index)
    //
    //                print("Removed:", friend.email)
    //            }
    //        }
    //    }
    
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
        let deviceToken = Constants.deviceTokenKey.load()
        let fireUser = FireUser(userID: "1", token: deviceToken, userName: "E", userEmail: "E",profileImageUrl: "",status: "" , creationDate: Date())
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
// MARK: - PushNotificationHelper
extension FireService{
    func pushNotificationToEmail(title : String,subtitle:String,reciever_email: String,completion : @escaping (Bool) -> ()){
        self.searchDeviceToken(email: reciever_email) { (deviceToken, error) in
            if(error == nil){
                if let token = deviceToken{
                    let pushNotificationSender = PushNotificationSender()
                    pushNotificationSender.sendPushNotification(to: token, title: title, body: subtitle)
                    completion(true)
                }
                completion(false)
            }
            completion(false)
        }
    }
    func pushNotificationGroup(title : String,subtitle:String,group : Group,completion : @escaping (Result<Bool , Error>)-> ()){
        self.searchGroupDeviceToken(group: group) { (result) in
            switch result{
            case .success(let deviceTokenList):
                print("TokenIDList:\(deviceTokenList)")
                print("group.id:\(group.id)")
//                if friends.isEmpty {return}
                //sends the same message to every person in the group
                let pushNotificationSender = PushNotificationSender()
                deviceTokenList.forEach { (token) in
                    if(token != "deviceToken".load()){
                        pushNotificationSender.sendPushNotification(to: token, title: title, body: subtitle)
                    }
                }
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    func pushNotificationFriend(title : String,subtitle:String,friends : [String],completion : @escaping (Result<Bool , Error>)-> ()){
        self.searchFriendListDeviceToken(friends: friends) { (result) in
            switch result{
            case .success(let deviceTokenList):
                print("TokenIDList:\(deviceTokenList)")
               
//                if friends.isEmpty {return}
                //sends the same message to every person in the group
                let pushNotificationSender = PushNotificationSender()
                deviceTokenList.forEach { (token) in
                    if(token != "deviceToken".load()){
                        pushNotificationSender.sendPushNotification(to: token, title: title, body: subtitle)
                    }
                }
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    func searchGroupDeviceToken(group : Group,completion : @escaping (Result<[String] , Error>)-> ()){
        if let currentUser = globalUser{
            self.getFriendsInGroup(user: currentUser, group: group) { (result) in
                var deviceTokenList = [String]()
                switch result{
                case .success(let friends):
                    if friends.isEmpty {return}
                    //sends the same message to every person in the group
                    var count = friends.count
                    friends.forEach { (friend) in
                        if friend.email != currentUser.email{
                        self.searchDeviceToken(email: friend.email) { (deviceToken, error) in
                            if let error = error{
                                print(error.localizedDescription)
                            }
                            
                                if let deviceToken = deviceToken{
                                    deviceTokenList.append(deviceToken)
                                    count -= 1
                                    if count == 0 {
                                    completion(.success(deviceTokenList))
                                    }
                                }
                            
                        }
                    }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    func searchFriendListDeviceToken(friends : [String],completion : @escaping (Result<[String] , Error>)-> ()){
        if let currentUser = globalUser{
                var deviceTokenList = [String]()
                if friends.isEmpty {return}
                    //sends the same message to every person in the group
                var count = friends.count
                friends.forEach { (friend) in
                        self.searchDeviceToken(email: friend) { (deviceToken, error) in
                            if let error = error{
                                completion(.failure(error))
                            }
                                if let deviceToken = deviceToken{
                                    deviceTokenList.append(deviceToken)
                                    count -= 1
                                    if count == 0 {
                                        completion(.success(deviceTokenList))
                                    }
                                }
                            
                        }
                    }
                }
    }
    
        
}
extension Encodable {
    
    func toJson() throws -> [String : Any] {
        
        let objectData = try! JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? [String :Any] else{ throw CodableChatError.enocdingError}
        return json
    }
}




