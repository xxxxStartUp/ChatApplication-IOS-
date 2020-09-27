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
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
       
       
        super.viewDidLoad()
        updateBackgroundViews()
        navigationBarBackgroundHandler()
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
        navBarButton.tintColor = #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        
        navigationItem.titleView = navBarButton
        navBarButton.addTarget(self, action: #selector(handleTapNavBarButton), for: .touchUpInside)
        let largeConfiguration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40))
        let image = UIImage(systemName:"person.crop.circle.fill",withConfiguration: largeConfiguration)
        navBarButton.setImage(image, for: .normal)
        handleNavBarImageView()
        

    }
    
    func handleNavBarImageView(){
        FireService.sharedInstance.searchOneUserWithEmail(email: r!.email) { (user, error) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            guard let user = user else {return}
            
            FireService.sharedInstance.getFriendPictureData(user: globalUser!, friend:user.asAFriend) { (result) in
                switch result{
                case .success(let url):
                    self.navBarButton.imageView?.af.setImage(withURL: url)
                    break
                case .failure(let error):
                    print("profileImageview Cannot be set")
                    break
                                }

            }
//            FireService.sharedInstance.getProfilePicture(user: user) { (result) in
//                switch result{
//                case .success(let url):
//                    self.navBarButton.imageView?.af.setImage(withURL: url)
//                    break
//                case .failure(let error):
//                    print("profileImageview Cannot be set")
//                    break
//                }
//            }
        }
        
    }
    
   @objc func handleTapNavBarButton(){
        
        guard let vc = UIStoryboard(name: "ContactInfoSB", bundle: nil).instantiateViewController(identifier: "ContactInfoVC") as? ContactInfoVC else {return}
        vc.friend = r
        vc.messages = messages
        navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleInfoBarButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "ContactInfoSB", bundle: nil).instantiateViewController(identifier: "ContactInfoVC") as? ContactInfoVC else {return}
        vc.friend = r
        vc.messages = messages
        navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateBackgroundViews()
        navigationBarBackgroundHandler()
        if r != nil {
            //It's not loading the view: messages don't show up
            loadMessages()
            handleNavBarImage()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        navigationBarBackgroundHandler()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContactInfoVC{
            destination.messages = messages
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
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
        DispatchQueue.main.async {
            self.chatTableView.darkmodeBackground()
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
        cell.chatVC = self
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
        cameraRoll.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
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
extension ChatVC_Dara{
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
//                self.texterView.alpha = 0
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
//            self.texterView.alpha = 0
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
//                self.texterView.alpha = 1
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
//            self.texterView.alpha = 1
            
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


