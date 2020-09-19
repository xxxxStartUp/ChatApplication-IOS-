//
//  ChatVC-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AlamofireImage
import Alamofire

class ChatVC_Dara: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    var messages = [Message]()
    var hasScrolled : Bool = false
    var cellId = "id"
    let navBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var globalImageSent : UIImage?
    var globalVideoUrl: NSURL?
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
    var messageToBeSent : Message?
    var messagePopUptableView: UITableView!
    var messagelongTapped : Message?
     let messagePopUpCellId = "messagePopUpCellId"
    var MessagePopUpheightAnchor : NSLayoutConstraint?
    var MessagePopUpBottomAnchor : NSLayoutConstraint?
    let messagePopUptableViewList  = [MessagepopUp(image: UIImage(named: "chat")!, title: "Save"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Archive"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Favorite"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Reply")]

    
    var r : Friend?{
        didSet {
            title = r?.username
            loadMessages()
            handleNavBarImage()
        }
    }
    
    
    
    let texterView = TexterView()
    
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
       
       
        super.viewDidLoad()
        messagePopUptableView = UITableView()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(MessgaeCell.self, forCellReuseIdentifier: cellId)
        self.setUptexter(texterView: texterView, controller: self)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.chatTableView.contentInset = insets
        messagePopUptableView.register(MessagePopUpCell.self, forCellReuseIdentifier: messagePopUpCellId)
        setUpMessagePopUptableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeAnimateTableView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    func handleNavBarImage(){
        navBarButton.layer.cornerRadius = 20
        navBarButton.backgroundColor = .clear
        navigationItem.titleView = navBarButton
        navBarButton.addTarget(self, action: #selector(handleTapNavBarButton), for: .touchUpInside)
        let image = UIImage(named:"profile")
        navBarButton.setImage(image, for: .normal)
        handleNavBarImageView()
        

    }
    
    func handleNavBarImageView(){
        FireService.sharedInstance.searchOneUserWithEmail(email: r!.email) { (user, error) in
            guard let user = user else {return}
            
            FireService.sharedInstance.getProfilePicture(user: user) { (result) in
                switch result{
                case .success(let url):
                    self.navBarButton.imageView?.af.setImage(withURL: url)
                    break
                case .failure(let error):
                    print("profileImageview Cannot be set")
                    break
                }
            }
        }
        
    }
    
   @objc func handleTapNavBarButton(){
        
        guard let vc = UIStoryboard(name: "ContactInfoSB", bundle: nil).instantiateViewController(identifier: "ContactInfoVC") as? ContactInfoVC else {return}
        vc.friend = r
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if r != nil {
            //It's not loading the view: messages don't show up
            loadMessages()
            handleNavBarImage()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            self.texterView.textingView.text = imageURL.absoluteString
            globalImageSent = image
            self.dismiss(animated: true, completion: nil)
        }
            
        else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            self.texterView.textingView.text = imageURL.absoluteString
            globalImageSent = image
            self.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
            
        else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            self.texterView.textingView.text = videoURL.absoluteString
            globalVideoUrl = videoURL
            self.dismiss(animated: true, completion: nil)
            print(videoURL)
        }
        
    }
    
    
    private func sendImageMessage(image:UIImage){
        guard let data = image.jpeg(.lowest) else {return}
        
        
        FireService.sharedInstance.saveImageToBeSentToFriend(data: data, friend: r!, user: globalUser!) { (url, error) in
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            
            guard let url = url else {return}
            let message = Message(content: Content(type: .image, content: url), sender: globalUser!, timeStamp: Date(), recieved: false)
            self.messageToBeSent = message
            self.sendMessage()
            
            
        }
        
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
    
    private func SendStringMessage(){
        if texterView.textingView.text.isEmpty{ return }
        guard let messageText = texterView.textingView.text else {
            return
        }
        let content = Content(type: .string, content: messageText)
        let message = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: false)
        messageToBeSent = message
        sendMessage()
        
    }
    
    
    
    // Modified the sendMessage function to send images  URL.
    func sendMessage(){
        guard let message = messageToBeSent else {return}
        FireService.sharedInstance.sendMessageToFriend(User: globalUser!, message: message, freind: self.r!) { (success, error) in
            if let error = error{
                fatalError()
            }
            if success { self.loadMessages()}
        }
        
    }
    /// Takes a video, converts it to data and sends to firebase , collects the url and ceates a messagetobesent
    /// - Parameter image: image to be sent
    private func sendVideoMessage(url:NSURL){
        var messageUrl = String()
        
        FireService.sharedInstance.sendVideoToFriend(url: url, friend: r!, user: globalUser!) { (videoURL, error,properties) in
            
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            let thumbnailImage = properties["thumbNailImage"] as! UIImage
            guard let data = thumbnailImage.jpeg(.lowest) else {return}
            FireService.sharedInstance.saveImageToBeSentToFriend(data: data, friend: self.r!, user: globalUser!) { (url, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                    fatalError()
                }
                
                if let finalUrl = url, let videoURL = videoURL {
                    messageUrl = videoURL + "thumbNailURL\(finalUrl)"
                    //ebuka may need to refactor code for message to contain property dictionary for content.
                    
                    let message = Message(content: Content(type: .video, content: messageUrl), sender: globalUser!, timeStamp: Date(), recieved: false)
                    
                    
                    self.messageToBeSent = message
                    self.sendMessage()
                }
            }
            
        }
        
    }
    
    
    
    
    private func sendMessageFinal(){
        if let image = globalImageSent {
            sendImageMessage(image: image)
            globalImageSent = nil
        }else if let video = globalVideoUrl{
            sendVideoMessage(url: video)
            globalVideoUrl = nil
        }
        else{
            SendStringMessage()
        }
        
        texterView.textingView.text = ""
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
    
    
    func setUpMessagePopUptableView(){
        messagePopUptableView.removeFromSuperview()
        self.view.addSubview(messagePopUptableView)
        messagePopUptableView.delegate = self
        messagePopUptableView.dataSource = self
        messagePopUptableView.estimatedRowHeight = 40
        messagePopUptableView.rowHeight = UITableView.automaticDimension
        //messagePopUptableView.isScrollEnabled = false
        messagePopUptableView.layer.cornerRadius = 15
        messagePopUptableView.layer.borderWidth = 0.4
        messagePopUptableView.layer.borderColor = UIColor.gray.cgColor
        messagePopUptableView.allowsSelection = true
        messagePopUptableView.translatesAutoresizingMaskIntoConstraints = false
        constainMessagePopUpTableView()
    }
    
    @objc func  handleLongTap(gesture : UIGestureRecognizer){
        let cellView = gesture.view
        guard let newCellView = cellView else {return}
        let cell = newCellView as! MessgaeCell
        messagelongTapped = cell.message
        print("tapped for long")

        
        animateTableView()
    }
    
    
    
    
    
    
    func constainMessagePopUpTableView(){
        messagePopUptableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        messagePopUptableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        MessagePopUpheightAnchor = messagePopUptableView.heightAnchor.constraint(equalToConstant: 150)

        MessagePopUpBottomAnchor =  messagePopUptableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 150)
        MessagePopUpBottomAnchor?.isActive = true
        MessagePopUpheightAnchor?.isActive = true
    }
    
    private func animateTableView(){
        MessagePopUpBottomAnchor =  messagePopUptableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        MessagePopUpheightAnchor = messagePopUptableView.heightAnchor.constraint(equalToConstant: 150)


        MessagePopUpheightAnchor?.isActive = true
        MessagePopUpBottomAnchor?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    

    @objc private func removeAnimateTableView(){
       // MessagePopUpheightAnchor = messagePopUptableView.heightAnchor.constraint(equalToConstant: 0)

       // MessagePopUpBottomAnchor =  messagePopUptableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)

        //MessagePopUpheightAnchor?.isActive = true
        MessagePopUpBottomAnchor?.isActive = true

          let y = 500
        UIView.animate(withDuration: 0.3) {
            self.messagePopUptableView.frame.origin.y = CGFloat(y)
            //self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    
    
    
    
    
}


extension ChatVC_Dara :UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == messagePopUptableView {
                   return messagePopUptableViewList.count
               }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messagePopUptableView{
           
            let cell = messagePopUptableView.dequeueReusableCell(withIdentifier: messagePopUpCellId) as! MessagePopUpCell
            cell.tag = indexPath.row
            cell.icon = messagePopUptableViewList[indexPath.row]
          //  let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handlemessagePopUpTableViewTapped(gesture:)))
           // cell.addGestureRecognizer(tapgesture)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessgaeCell
        cell.message = messages[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
         let longMessageCellTapGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(gesture:)))
        cell.addGestureRecognizer(longMessageCellTapGesture)

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
        sendMessageFinal()
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


