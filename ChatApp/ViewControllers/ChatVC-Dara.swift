//
//  ChatVC-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC_Dara: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    var messages = [Message]()
    var hasScrolled : Bool = false
    var cellId = "id"
    
    var r : Friend?{
         didSet {
            //title = r?.username
            loadMessages()
         }
     }
    
    /*func dummy() {
        
        let content = Content(type: .string, content: "first saved message")
        let message = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: true)
        
        FireService.sharedInstance.saveMessages(user: globalUser!, messageToSave: message) { (result) in
            switch result{
                
            case .success(_):
                print("Successfully saved messages")
            case .failure(_):
                fatalError()
            }
        }
    }*/
    

    let texterView = TexterView()
    
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(MessgaeCell.self, forCellReuseIdentifier: cellId)
        self.setUptexter(texterView: texterView, controller: self)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.chatTableView.contentInset = insets

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if r != nil {
            //It's not loading the view: messages don't show up
            loadMessages()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        
        
        let selectedImage = image
        
        let data = selectedImage.pngData()!
        
        saveImageToSend(data: data)
    }
    
    /// Function that saves the image to send to Firebase
    /// - Parameter data: Data containing the image to send
    func saveImageToSend(data : Data){
       
        FireService.sharedInstance.saveImageToSend(data: data, user: globalUser!) { (result) in
            switch result {
            case .success(_):
                print("sucess")
                self.dismiss(animated: true, completion: nil)

            case .failure(_):
                print("falure")
            }
        }
        
    }
    
    
    
    // Modified the sendMessage function to send images  URL.
    func sendMessage(){
        
        let dummyMessage = Message(content: Content(type: .string, content: self.texterView.textingView.text ?? ""), sender: globalUser!, timeStamp: Date(), recieved: false)
        
        FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: dummyMessage, freind: self.r!) { (success, error) in
            if let error = error{
                fatalError()
            }
        }
        
        
        
        /*var stringContent = String("Test")
        FireService.sharedInstance.getImageToSend(user: globalUser!) { (result) in
            switch result{
                
            case .success(let url):
                //sendImage()
                stringContent = url.absoluteString
                print("An image was selected to be sent", stringContent)
                let content = Content(type: .string, content: stringContent)
                let singleMessage = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: false)
                FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: singleMessage, freind: self.r!) { (sucess, error) in
                   
                    if let error = error{
                        fatalError()
                    }
                     if sucess{ print("sucessfully sent image")}
                }
                FireService.sharedInstance.DeleteImageToSend(user: globalUser!) { (result) in switch result{
                    
                    case .success(_):
                        print("A temp image existed and was deleted.")
                        
                        
                    case .failure(_):
                    print("No temporary image existe, so nothing was deleted")
                    }
                }                
                
                
            case .failure(_):
                //messageFailed()
                stringContent = self.texterView.textingView.text ?? ""
                let content = Content(type: .string, content: stringContent)
                let singleMessage = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: false)
                FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: singleMessage, freind: self.r!) { (sucess, error) in
                   
                    if let error = error{
                        fatalError()
                    }
                     if sucess{ print("sucessfully sent image")}
                }
                print("No image was selected to send. So the text in the TextView box will be send")
            }
        }
        
        /*let messageContent = Content(type: .string, content: stringContent)
        
        
        let dummyMessage = Message(content: messageContent, sender: globalUser!, timeStamp: Date(), recieved: false)
        FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: dummyMessage, freind: r!) { (sucess, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            if sucess{
//                let controller = UIAlertController.alertUser(title: "you sent a message", message: "sucess", whatToDo: "check firebase")
//                self.present(controller, animated: true, completion: nil)
                FireService.sharedInstance.DeleteImageToSend(user: globalUser!) { (result) in switch result{
                    
                    case .success(_):
                        print("A temp image existed and was deleted.")
                        
                        
                    case .failure(_):
                    print("No temporary image existe, so nothing was deleted")
                    }
                }
                print("sent message in chat_vc dara")
            }
        }*/
 
 */
    }
    
    
    
    
    
    func loadMessages(){
        FireService.sharedInstance.loadMessagesWithFriend(User: globalUser!,  freind: r!) { (messages, error) in
            
            
            self.messages.removeAll()
            
            self.chatTableView.reloadData()
            guard let messages = messages else {
                
                print("Message was nil")
                return
                
            }
            
            messages.forEach { (message) in
                self.messages.append(message)
            }
            
            
            self.messages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            if !messages.isEmpty{
                self.chatTableView.reloadData()
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.chatTableView.scrollToRow(at:indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    
    
    
    
    
}


extension ChatVC_Dara :UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessgaeCell
        cell.message = messages[indexPath.row]
        return cell
        
    }
}


extension ChatVC_Dara : FreindDelegate {
    func didSendFriend(freind: Friend) {
        r = freind
    }
}


extension ChatVC_Dara : TexterViewDelegate {
    func didClickSend() {
        print("send")
        sendMessage()
    }
    
    func didClickFile() {
        print("file")
    }
    
    func didClickCamera() {
        let cameraRoll = UIImagePickerController()
        cameraRoll.delegate = self
        cameraRoll.sourceType = .photoLibrary
        cameraRoll.allowsEditing = false
        self.present(cameraRoll, animated: true, completion: nil)
        print("open camera")
        
    }
}


extension UIViewController {
    
    
    
    func setUptexter<T : UIViewController>(texterView : TexterView , controller : T  ) -> Void where T : TexterViewDelegate  {
        texterView.translatesAutoresizingMaskIntoConstraints = false
        let view = controller.view!
        texterView.translatesAutoresizingMaskIntoConstraints = false
        texterView.delegate = controller
        //hides tab bar
        //self.tabBarController?.tabBar.isHidden = true
        //adding programmatic texterView
        view.addSubview(texterView)
        texterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        texterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        texterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        texterView.darkmodeBackground()
    }
}


