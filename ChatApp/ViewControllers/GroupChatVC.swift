//
//  GroupChatVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class GroupChatVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var groupChatTable: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    var globalImageSent : UIImage?
    var globalVideoUrl: NSURL?
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
    var messageToBeSent : Message?
    var cellID = "id"
    var loaded  = false
    var groupMessages : [Message] = []
    var groupDelegate : GroupDelegate?
    var startingFrame:CGRect?
    var videoFrame:CGRect?
    var startingImageView:UIImageView?
    var blackBackgroundView:UIView?
    var keywindow:UIWindow?
    var videoBackgroundView:UIView?
    var videoExitButton:UIButton?
    var pauseButton:UIButton?
    var trailingTimeLabel:UILabel?
    var leadingTimeLabel:UILabel?
    var videoSlider:UISlider?
    
    
    let activityIndicator:UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
    
        return aiv
    }()
    var group : Group?{
        didSet{
            title = group?.name
            loaded = true
        }
    }
    var groupParticipants = [Friend]()
    
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
    /// Takes a video, converts it to data and sends to firebase , collects the url and ceates a messagetobesent
    /// - Parameter image: image to be sent
    private func sendVideoMessage(url:NSURL){
        var messageUrl = String()
        FireService.sharedInstance.saveVideoToBeSentToGroupChat(url: url, user: globalUser!, group: group!) { (videoURL, error,properties) in
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            let thumbnailImage = properties["thumbNailImage"] as! UIImage
            guard let data = thumbnailImage.jpeg(.lowest) else {return}
            FireService.sharedInstance.saveImageToBeSentToGroupChat(data: data, user: globalUser!, group: self.group!) { (url, error) in
                
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
        
        getGroupName()
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
        getGroupName()
        updateBackgroundViews()
        loadMessages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGroupName()
        updateBackgroundViews()
        loadMessages()
        
        
        
    }
    func getGroupName(){
        FireService.sharedInstance.getGroupname(user: globalUser!, group: group!) { (group, true, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            print(group!.GroupAdmin.email)
            
            self.group = group
        }
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
        }else if let video = globalVideoUrl{
            sendVideoMessage(url: video)
            globalVideoUrl = nil
        }
        else{
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
        cameraRoll.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
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
    //handles when the video is tapped in from message cell.
    func handleVideoZoomedIn(url:String){
        if let videoURL = URL(string: url){
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            print(videoURL)
            print("Play Button Tapped")
            
            var keywindow = UIWindow()
            for window in UIApplication.shared.windows{
                if window.isKeyWindow{
                    keywindow = window
                }
            }
            blackBackgroundView = UIView(frame: keywindow.frame)
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.backgroundColor = .black
            self.blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleZoomedOutVideo)))
      
            
            keywindow.addSubview(activityIndicator)
            keywindow.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor).isActive = true
            keywindow.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor).isActive = true
            keywindow.widthAnchor.constraint(equalTo: activityIndicator.widthAnchor).isActive = true
            keywindow.heightAnchor.constraint(equalTo: activityIndicator.heightAnchor).isActive = true
            videoFrame = keywindow.frame
            keywindow.addSubview(blackBackgroundView!)
            keywindow.addSubview(activityIndicator)
            
            
            keywindow.layer.addSublayer(playerLayer!)
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.texterView.alpha = 0
                self.playerLayer?.frame = keywindow.frame
                self.player?.play()
                self.activityIndicator.startAnimating()
            
            }, completion: {(completed: Bool) in
                
                self.activityIndicator.removeFromSuperview()
                
            
        })
            
        }
    }
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
                self.texterView.alpha = 1 
                tappedOutImageView.frame = startingFrame
            }, completion: {(completed: Bool) in
                tappedOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
            
        }
        
    }
    @objc func handleZoomedOutVideo(tapGesture:UITapGestureRecognizer){
        print("video is tapped out")
        
        
        if let tappedOutBackgroundView = tapGesture.view{
            //play button anchors
            videoBackgroundView = tappedOutBackgroundView
            pauseButton = {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                let largeConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 70))
                let image = UIImage(systemName: "play.circle.fill",withConfiguration: largeConfiguration)
                button.setImage(image, for: .normal)
                button.tintColor = .lightGray
                button.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                return button
            }()
            videoExitButton = {
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                let largeConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))
                let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left",withConfiguration: largeConfiguration)
                button.setImage(image, for: .normal)
                button.tintColor = .lightGray
                button.addTarget(self, action: #selector(dismissVideo), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                return button
            }()
            
            trailingTimeLabel = {
                let label = UILabel()
                label.text = "0:00"
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 15)
                label.textAlignment = .right
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            leadingTimeLabel = {
                      let label = UILabel()
                      label.text = "0:00"
                      label.textColor = .white
                      label.font = UIFont.boldSystemFont(ofSize: 15)
                      label.textAlignment = .right
                      label.translatesAutoresizingMaskIntoConstraints = false
                      return label
                  }()
            videoSlider = {
                let slider = UISlider()
                slider.translatesAutoresizingMaskIntoConstraints = false
                return slider
            }()
            
            
            keywindow = UIWindow()
            for window in UIApplication.shared.windows{
                if window.isKeyWindow{
                    keywindow = window
                }
            }
            keywindow?.addSubview(pauseButton!)
            keywindow?.addSubview(videoExitButton!)
//            keywindow?.addSubview(trailingTimeLabel!)
//            keywindow?.addSubview(leadingTimeLabel!)
//            keywindow?.addSubview(videoSlider!)
            
            keywindow?.centerXAnchor.constraint(equalTo: pauseButton!.centerXAnchor).isActive = true
            keywindow?.centerYAnchor.constraint(equalTo: pauseButton!.centerYAnchor).isActive = true
            keywindow?.widthAnchor.constraint(equalTo: pauseButton!.widthAnchor).isActive = true
            keywindow?.heightAnchor.constraint(equalTo: pauseButton!.heightAnchor).isActive = true
            keywindow?.centerXAnchor.constraint(equalTo: videoExitButton!.centerXAnchor, constant: 16).isActive = true
            
            videoExitButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            videoExitButton!.heightAnchor.constraint(equalToConstant: 44).isActive = true
            videoExitButton!.leftAnchor.constraint(equalTo:keywindow!.leftAnchor,constant: 16).isActive = true
            videoExitButton!.trailingAnchor.constraint(equalTo: keywindow!.trailingAnchor,constant: -((keywindow?.frame.width)! - videoExitButton!.frame.width+10)).isActive = true
            videoExitButton!.topAnchor.constraint(equalTo: keywindow!.topAnchor,constant: 32).isActive = true
            
//            trailingTimeLabel!.widthAnchor.constraint(equalToConstant: 60).isActive = true
//            trailingTimeLabel!.heightAnchor.constraint(equalToConstant: 44).isActive = true
//            trailingTimeLabel?.topAnchor.constraint(equalTo: keywindow!.topAnchor,constant: 32).isActive = true
//            trailingTimeLabel?.rightAnchor.constraint(equalTo: keywindow!.rightAnchor, constant: -16).isActive = true
//            
//            leadingTimeLabel!.widthAnchor.constraint(equalToConstant: 60).isActive = true
//            leadingTimeLabel!.heightAnchor.constraint(equalToConstant: 44).isActive = true
//            leadingTimeLabel?.topAnchor.constraint(equalTo: keywindow!.topAnchor,constant: 32).isActive = true
//            leadingTimeLabel?.leftAnchor.constraint(equalTo: videoExitButton!.rightAnchor, constant: -16).isActive = true
//            
//            videoSlider?.heightAnchor.constraint(equalToConstant: 44).isActive = true
//            videoSlider?.rightAnchor.constraint(equalTo: trailingTimeLabel!.leftAnchor).isActive = true
//            videoSlider?.topAnchor.constraint(equalTo: keywindow!.topAnchor,constant: 32).isActive = true
//            videoSlider?.leftAnchor.constraint(equalTo: leadingTimeLabel!.rightAnchor).isActive = true
            
            
            
         
//           trailingTimeLabel!.leadingAnchor.constraint(equalTo: keywindow!.leadingAnchor,constant: ((keywindow?.frame.width)! - videoExitButton!.frame.width+10)).isActive = true
            
            
            
            player?.pause()
            
        }
        
        
    }
    
    @objc func dismissVideo(){
        
        UIView.animate(withDuration: 0.5, delay: 0.5,usingSpringWithDamping: 1,initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.pauseButton?.alpha = 0
            self.playerLayer?.isHidden = true
            self.videoExitButton?.alpha = 0
            self.videoBackgroundView?.alpha = 0
            self.pauseButton?.alpha = 0
            self.texterView.alpha = 1
            
        }, completion: {(completed: Bool) in
               self.playerLayer?.removeFromSuperlayer()
                self.videoExitButton?.removeFromSuperview()
                self.videoBackgroundView?.removeFromSuperview()
                self.pauseButton?.removeFromSuperview()
            
        })
  
        print("dismissVideo")
    }
    
    
    @objc func handlePlayAndPause(){
        player?.play()
        self.videoExitButton?.isHidden = true
        self.pauseButton?.isHidden = true
    }
    
    
}
