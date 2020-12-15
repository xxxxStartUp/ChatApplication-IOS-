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
import AlamofireImage
import Alamofire

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
    var messagelongTapped : Message?
    var MessagePopUpheightAnchor : NSLayoutConstraint?
    var MessagePopUpBottomAnchor : NSLayoutConstraint?
    var messagePopUptableView: UITableView!
    let messagePopUpCellId = "messagePopUpCellId"
    let messagePopUptableViewList  = [MessagepopUp(image: UIImage(named: "chat")!, title: "Save"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Archive"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Favorite"),
                                      MessagepopUp(image: UIImage(named: "chat")!, title: "Reply")]
    var keywindow:UIWindow?
    var videoBackgroundView:UIView?
    var videoExitButton:UIButton?
    var pauseButton:UIButton?
    var trailingTimeLabel:UILabel?
    var leadingTimeLabel:UILabel?
    var videoSlider:UISlider?
    let navBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
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
            //setGroupImagehere
            handleNavBarImage()
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
        FireService.sharedInstance.saveImageToBeSentToGroupChat(data: data, user: globalUser.toFireUser, group: group!) { (url, error) in
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            let id = UUID().uuidString
            
            let message = Message(id:id,content: Content(type: .image, content: url!), sender: globalUser.toFireUser, timeStamp: Date(), recieved: false)
            self.messageToBeSent = message
            self.sendMessage()
        }
    }
    /// Takes a video, converts it to data and sends to firebase , collects the url and ceates a messagetobesent
    /// - Parameter image: image to be sent
    private func sendVideoMessage(url:NSURL){
        var messageUrl = String()
        FireService.sharedInstance.saveVideoToBeSentToGroupChat(url: url, user: globalUser.toFireUser, group: group!) { (videoURL, error,properties) in
            if let error = error{
                print(error.localizedDescription)
                fatalError()
            }
            let thumbnailImage = properties["thumbNailImage"] as! UIImage
            guard let data = thumbnailImage.jpeg(.lowest) else {return}
            FireService.sharedInstance.saveImageToBeSentToGroupChat(data: data, user: globalUser.toFireUser, group: self.group!) { (url, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                    fatalError()
                }
                
                if let finalUrl = url, let videoURL = videoURL {
                    messageUrl = videoURL + "thumbNailURL\(finalUrl)"
                    //ebuka may need to refactor code for message to contain property dictionary for content.
                    let id = UUID().uuidString

                    let message = Message(id:id,content: Content(type: .video, content: messageUrl), sender: globalUser.toFireUser, timeStamp: Date(), recieved: false)
                    
                    
                    self.messageToBeSent = message
                    self.sendMessage()
                }
                
            }
            
        }
    }
    
    
    let texterView = TexterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeAnimateTableView))
        self.view.addGestureRecognizer(tapgesture)
        messagePopUptableView = UITableView(frame: CGRect(x: 0, y: 500, width: 0, height: 0))
        updateBackgroundViews()
        
        groupChatTable.delegate = self
        groupChatTable.dataSource = self
        
        groupChatTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
        self.setUptexter(texterView: texterView, controller: self)
        groupChatTable.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.groupChatTable.contentInset = insets
        
        messagePopUptableView.register(MessagePopUpCell.self, forCellReuseIdentifier: messagePopUpCellId)
        
        
        getGroupName()

        handleNavBarImage()

        loadGroupParticipants()
    }
    func loadGroupParticipants(){

        FireService.sharedInstance.viewGroupParticipants(user: globalUser.toFireUser, group: group!) { (participants, true, error) in
            if let error = error{
                print(error)
                fatalError()
            }
            self.groupParticipants = participants
            if !self.groupParticipants.contains(globalUser.toFireUser.asAFriend){
                self.texterView.isHidden = true
            }
        }

        
    }
    
    func handleNavBarImage(){
        //navBarButton.layer.cornerRadius = 20
        //navBarButton.backgroundColor = .red
        // let imageCache = AutoPurgingImageCache()
        navigationItem.titleView = navBarButton
        //        let cachedAvatar = imageCache.image(withIdentifier: "image")
        //        self.navBarButton.setImage(cachedAvatar, for: .normal)
        
        FireService.sharedInstance.getGroupPictureDataFromChatLog(user: globalUser.toFireUser,group: group!) { (url,completion,error) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            if let url = url{
                let largeConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 60))
                let image = UIImage(systemName:"person.2.circle.fill",withConfiguration: largeConfiguration)
            
                let imageView = UIImageView()
                imageView.af.setImage(withURL: url, cacheKey: nil, placeholderImage: image, serializer: nil, filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false) { (_) in
                    let data = imageView.image?.jpeg(.low)
                    let newImage = (UIImage(data: data!))!.af.imageRoundedIntoCircle()
                    self.navBarButton.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    self.navBarButton.imageView?.contentMode = .scaleAspectFit
                    self.navBarButton.setImage(newImage, for: .normal)
                    self.navBarButton.backgroundColor = .clear
                    self.navBarButton.tintColor = #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
                    
                    
                }

                }
            if !completion{
                let largeConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 60))
                let image = UIImage(systemName:"person.2.circle.fill",withConfiguration: largeConfiguration)
                self.navBarButton.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                self.navBarButton.imageView?.contentMode = .scaleAspectFit
                self.navBarButton.setImage(image, for: .normal)
                self.navBarButton.backgroundColor = .clear
                self.navBarButton.layer.cornerRadius = 20
                self.navBarButton.tintColor = #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getGroupName()
        loadGroupParticipants()
        updateBackgroundViews()
        loadMessages()
        handleNavBarImage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGroupName()
        loadGroupParticipants()
        updateBackgroundViews()
        loadMessages()
        handleNavBarImage()
    }
    
    func getGroupName(){
        FireService.sharedInstance.getGroupname(user: globalUser.toFireUser, group: group!) { (group, true, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            print(group!.GroupAdmin.email)
            
            self.group = group
        }
    }
    
    private func SendStringMessage(){
        if texterView.textingView.text.isEmpty{ return }
        guard let messageText = texterView.textingView.text else {
            return
        }
        let content = Content(type: .string, content: messageText)
        let id = UUID().uuidString
        
        let message = Message(id:id,content: content, sender: globalUser.toFireUser, timeStamp: Date(), recieved: false)
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
        FireService.sharedInstance.sendMessgeToAllFriendsInGroup(message: message, user: globalUser.toFireUser, group: group!, completionHandler: { (result) in
            
            switch result{
                
            case .success( let bool):
                if bool {
                    FireService.sharedInstance.pushNotificationGroup(title: self.group!.name , subtitle: message.content.content as! String, group: self.group!) { (pushResult) in
                    switch pushResult{
                        case .success(true):
                          print("Push notification happened")
                        // create a collection of recent messages for the user
                        case .failure(let error):
                            print(error.localizedDescription)
                            fatalError()
                    case .success(false):
                            fatalError()
                    }
                  
                    }
                    print("messeage was sent ")
                    self.loadMessages()
                }
                
            case .failure(_):
                fatalError()
            }
        })
    }
    
    
    
    
    func loadMessages (){
        FireService.sharedInstance.loadMessagesWithGroup(user: globalUser.toFireUser, group: group!) { (messages, error) in
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
            destination.messages = groupMessages
        }
        if let destination = segue.destination as? SelectFriendVC{
            destination.group = group
        }
        
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        print(group!.name,"groupname")
        performSegue(withIdentifier: Constants.groupchatSBToGroupInfoIdentifier, sender: self)
    }
    @IBAction func addcontactsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "chatToContactsIdentifier", sender: self)
        Constants.selectedContactsPage.fromChatLogIndicator = false
        Constants.selectedContactsPage.fromGroupChatVCIndicator = true
    }
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
        DispatchQueue.main.async {
            self.groupChatTable.darkmodeBackground()
            self.view.darkmodeBackground()
            
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
    
    
    @objc func  handleLongTap(gesture : UIGestureRecognizer){
        let cellView = gesture.view
        guard let newCellView = cellView else {return}
        let cell = newCellView as! MessgaeCell
        messagelongTapped = cell.message
        print("tapped for long")
        //remove tableView
        removeTableView(tableView: messagePopUptableView)
        //removeAnimateTableView()
        //add tableView
        messagePopUptableView.delegate = self
        messagePopUptableView.dataSource = self
        self.view.addSubview(messagePopUptableView)
        messagePopUptableView.estimatedRowHeight = 40
        messagePopUptableView.rowHeight = UITableView.automaticDimension
        constainMessagePopUpTableView()
        messagePopUptableView.isScrollEnabled = false
        messagePopUptableView.layer.cornerRadius = 15
        messagePopUptableView.layer.borderWidth = 0.4
        messagePopUptableView.layer.borderColor = UIColor.gray.cgColor
        messagePopUptableView.allowsSelection = true
        
        //add tableView frame auto layout
        //animateTableView
        animateTableView()
    }
    
    
    func constainMessagePopUpTableView(){
        messagePopUptableView.translatesAutoresizingMaskIntoConstraints = false
        messagePopUptableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        messagePopUptableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        MessagePopUpheightAnchor = messagePopUptableView.heightAnchor.constraint(equalToConstant: messagePopUptableView.contentSize.height)
        //messagePopUptableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        MessagePopUpBottomAnchor =  messagePopUptableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        MessagePopUpBottomAnchor?.isActive = true
        
        
    }
    
    private func removeTableView(tableView : UITableView){
        tableView.removeFromSuperview()
    }
    
    private func animateTableView(){
        MessagePopUpheightAnchor?.isActive = true
        MessagePopUpBottomAnchor?.isActive = true
        
        //  let y = 500
        UIView.animate(withDuration: 0.3) {
            //            self.messagePopUptableView.frame.origin.y = CGFloat(y)
            self.view.layoutIfNeeded()
        }
    }
    @objc private func removeAnimateTableView(){
        let y = self.view.frame.height
        UIView.animate(withDuration: 0.3) {
            self.messagePopUptableView.frame.origin.y = CGFloat(y)
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
    
    @objc func handlemessagePopUpTableViewTapped(gesture : UITapGestureRecognizer){
        print("tapped")
        //removeAnimateTableView()
        
        let tapped = gesture.view?.tag
        guard let realTapped = tapped else {
            return
        }
        switch realTapped {
        case 0:
            FireService.sharedInstance.saveMessages(user: globalUser.toFireUser,group: group!, messageToSave: messagelongTapped!) { (result) in
                switch result {
                case .success(let bool):
                    if bool {
                        self.removeAnimateTableView()
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.removeAnimateTableView()
                }
            }
        default:
            self.removeAnimateTableView()
            break
        }
        
        self.removeAnimateTableView()
        
    }
    
    
}


extension GroupChatVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == messagePopUptableView {
            print(indexPath.row)
        }
        if tableView == groupChatTable{
            print("tableview did select")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == messagePopUptableView {
            return messagePopUptableViewList.count
        }
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messagePopUptableView{
            
            let cell = messagePopUptableView.dequeueReusableCell(withIdentifier: messagePopUpCellId) as! MessagePopUpCell
            cell.tag = indexPath.row
            cell.icon = messagePopUptableViewList[indexPath.row]
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(handlemessagePopUpTableViewTapped(gesture:)))
            cell.addGestureRecognizer(tapgesture)
            
            
            return cell
        }
        
        
        let cell = groupChatTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessgaeCell
        cell.isUserInteractionEnabled = true
        cell.groupVC = self
        let message = groupMessages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let longMessageCellTapGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(gesture:)))
        cell.addGestureRecognizer(longMessageCellTapGesture)
        return cell
    }
    
    
    
}

extension GroupChatVC {
    
    
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
        self.startingImageView?.contentMode = .scaleAspectFit
        self.startingImageView = startingImageview
        startingImageView?.isHidden = true
        startingFrame = startingImageview.superview?.convert(startingImageview.frame, to: nil)
        print(startingFrame)
        
        let tappedImageFrame = UIImageView(frame: startingFrame!)
        //tappedImageFrame.backgroundColor = .red
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
            tappedImageFrame.contentMode = .scaleAspectFit
            tappedImageFrame.backgroundColor = .black
            self.startingImageView?.image?.withRenderingMode(.alwaysOriginal)
            
        }, completion: nil)
        
    }
    
    @objc func handleTappedOutImage(tapGesture:UITapGestureRecognizer){
        
        print("Zooming out")
        
        if let tappedOutImageView = tapGesture.view,let startingFrame = startingFrame{
            
            //tappedOutImageView.layer.cornerRadius = 8
            tappedOutImageView.clipsToBounds = true

            UIView.animate(withDuration: 0.7, delay: 0,usingSpringWithDamping: 1,initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 0
                self.texterView.alpha = 1
                tappedOutImageView.frame = startingFrame
            }, completion: {(completed: Bool) in
                tappedOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                self.startingImageView?.contentMode = .scaleAspectFill
                self.startingImageView?.image?.withRenderingMode(.alwaysOriginal)
                self.startingImageView?.layer.cornerRadius = 8
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
