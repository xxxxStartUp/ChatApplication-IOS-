//
//  GroupChatVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class GroupChatVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var groupChatTable: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    var globalImageSent : UIImage?
    var messageToBeSent : Message?
    var cellID = "id"
    var loaded  = false
    var groupMessages : [Message] = []
    var groupDelegate : GroupDelegate?
    var startingFrame:CGRect?
    var startingImageView:UIImageView?
    var blackBackgroundView:UIView?
    var group : Group?{
        didSet{
            title = group?.name
            loaded = true
        }
    }
    var groupParticipants = [Friend]()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        self.texterView.textingView.text = imageURL.absoluteString
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        globalImageSent = image
        self.dismiss(animated: true, completion: nil)
        
    }
        else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            globalImageSent = image
            self.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }

    }
    
    /// Takes a image , converts it to data and sends to firebase , collects the url and ceates a messagetobesent
    /// - Parameter image: image to be sent
    private func sendImageMessage(image:UIImage){
        guard let data = image.jpeg(.lowest) else {return}
        FireService.sharedInstance.saveImageToBeSentToGroupChat(data: data, user: globalUser!, group: group!) { (url, error) in
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            let message = Message(content: Content(type: .image, content: url!), sender: globalUser!, timeStamp: Date(), recieved: false)
            self.messageToBeSent = message
            self.sendMessage()
        }
    }

    
    let texterView = TexterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundViews()
        groupChatTable.delegate = self
        groupChatTable.dataSource = self
        groupChatTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
        self.setUptexter(texterView: texterView, controller: self)
        groupChatTable.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.groupChatTable.contentInset = insets
        
        FireService.sharedInstance.viewGroupParticipants(user: globalUser!, group: group!) { (participants, true, error) in
            if let error = error{
                print(error)
                fatalError()
            }
           self.groupParticipants = participants
            

        }

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        loadMessages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        updateBackgroundViews()
           loadMessages()
            
        
        
    }
    
    private func SendStringMessage(){
        guard let messageText = texterView.textingView.text else {
            return
        }
        let content = Content(type: .string, content: messageText)
        let message = Message(content: content, sender: globalUser!, timeStamp: Date(), recieved: false)
        messageToBeSent = message
        sendMessage()
        
    }
    
    
    private func sendMessageFinal(){
        if let image = globalImageSent {
            sendImageMessage(image: image)
            globalImageSent = nil
        }else{
         SendStringMessage()
        }
        
        texterView.textingView.text = ""
    }
    
    
    private func sendMessage() {
        guard let message = messageToBeSent else {return}
        FireService.sharedInstance.sendMessgeToAllFriendsInGroup(message: message, user: globalUser!, group: group!, completionHandler: { (result) in

            switch result{
                
            case .success( let bool):
                if bool {
                    print("messeage was sent ")
                    self.loadMessages()
                }
            case .failure(_):
                fatalError()
            }
        })
    }
    
    
    
    
    func loadMessages (){
        FireService.sharedInstance.loadMessagesWithGroup(user: globalUser!, group: group!) { (messages, error) in
           self.groupMessages.removeAll()
           self.groupChatTable.reloadData()
            guard let messages = messages else {return}
            print(messages.count , "this is printing is in groupvc")
            messages.forEach { (message) in
                self.groupMessages.append(message)
                print(message.content.content as! String, "this is printing in group vc")
            }


            self.groupMessages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }

            if !messages.isEmpty{
                self.groupChatTable.reloadData()
                let indexPath = IndexPath(row: self.groupMessages.count-1, section: 0)
                self.groupChatTable.scrollToRow(at:indexPath, at: .bottom, animated: true)
            }

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GroupInfoVC{
            destination.group = group
            destination.groupParticipants = groupParticipants
        }

    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        print(group!.name,"groupname")
        performSegue(withIdentifier: Constants.groupchatSBToGroupInfoIdentifier, sender: self)
    }
    @IBAction func addcontactsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "chatToContactsIdentifier", sender: self)
        Constants.chatPage.chatToContactsSegueSignal = true
    }
    
   //updates the background color for the tableview and nav bar.
   func updateBackgroundViews(){
    print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
       DispatchQueue.main.async {
           self.groupChatTable.darkmodeBackground()
           
        self.texterView.backgroundView.texterViewBackground()
           //self.navigationController?.navigationBar.darkmodeBackground()

           self.navigationBarBackgroundHandler()
           
       }
   }
   //handles the text color, background color and appearance of the nav bar
   func navigationBarBackgroundHandler(){
       
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
       if Constants.settingsPage.displayModeSwitch{
           let navBarAppearance = UINavigationBarAppearance()
           navBarAppearance.configureWithOpaqueBackground()
           navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.backgroundColor = .black
           self.navigationController?.navigationBar.isTranslucent = false
           self.navigationController?.navigationBar.standardAppearance = navBarAppearance
           self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
           self.navigationController?.navigationBar.setNeedsLayout()
           //handles TabBar
           self.tabBarController?.tabBar.barTintColor = .black
           tabBarController?.tabBar.isTranslucent = false
           
       }
       else{
           let navBarAppearance = UINavigationBarAppearance()
           navBarAppearance.configureWithOpaqueBackground()
           navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
           navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
           navBarAppearance.backgroundColor = .white
           self.navigationController?.navigationBar.isTranslucent = true
           self.navigationController?.navigationBar.standardAppearance = navBarAppearance
           self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
           self.navigationController?.navigationBar.setNeedsLayout()
           
           //handles TabBar
           self.tabBarController?.tabBar.barTintColor = .white
           self.tabBarController?.tabBar.backgroundColor = .white
           tabBarController?.tabBar.isTranslucent = true
       }
   }
    
    

}




extension GroupChatVC : GroupDelegate {
    func didSendGroup(group: Group) {
        self.group = group
        return
    }
    
    
}

extension GroupChatVC : TexterViewDelegate {
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
        cameraRoll.allowsEditing = true
        self.present(cameraRoll, animated: true, completion: nil)
        print("camera")
        
    }
    
    
}


extension GroupChatVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groupChatTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessgaeCell
        cell.groupVC = self
        let message = groupMessages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    //handles when the image is tapped.
    func handlesTappedInImage(startingImageview:UIImageView){
        print("HandlesImageTap")
        self.startingImageView = startingImageview
        startingImageView?.isHidden = true
        startingFrame = startingImageview.superview?.convert(startingImageview.frame, to: nil)
        print(startingFrame)
        
        let tappedImageFrame = UIImageView(frame: startingFrame!)
        tappedImageFrame.backgroundColor = .red
        tappedImageFrame.image = startingImageview.image
        tappedImageFrame.isUserInteractionEnabled = true
        tappedImageFrame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTappedOutImage)))
        
       
        var keywindow = UIWindow()
        for window in UIApplication.shared.windows{
            if window.isKeyWindow{
                keywindow = window
            }
        }
        blackBackgroundView = UIView(frame: keywindow.frame)
        blackBackgroundView?.alpha = 0
        blackBackgroundView?.backgroundColor = .black
        keywindow.addSubview(blackBackgroundView!)
        
        let height = (startingFrame!.height/startingFrame!.width)*keywindow.frame.width
        
        keywindow.addSubview(tappedImageFrame)
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            tappedImageFrame.frame = CGRect(x: 0, y: 0, width: keywindow.frame.width, height: height)
            self.blackBackgroundView?.alpha = 1
            self.texterView.alpha = 0
            tappedImageFrame.center = keywindow.center
        }, completion: nil)
       
    }
    
    @objc func handleTappedOutImage(tapGesture:UITapGestureRecognizer){
        
        print("Zooming out")
        
        if let tappedOutImageView = tapGesture.view,let startingFrame = startingFrame{
            
            tappedOutImageView.layer.cornerRadius = 8
            tappedOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1,initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 0
                tappedOutImageView.frame = startingFrame
            }, completion: {(completed: Bool) in
                tappedOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })

        }
        
    }
    
    
    
    
}
