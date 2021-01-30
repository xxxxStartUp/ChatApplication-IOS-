//
//  SavedMessagesVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 9/4/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import AVFoundation

class SavedMessagesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet var savedMessagesTable: UITableView!
    let identifier1 = "GroupchatInfoCellIdentifier"
    var cellID = "id"
    
    var savedMessagesDictionary : [String:Message] = [:]
    var savedMessagesKeys:[String] = []
    var savedMessages:[Message] = []
    
    var group: Group?
    var finalLabel:UILabel?
    var rightBarButton:UIBarButtonItem?
    var freind : Friend?
    
    let activityIndicator:UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
    }()
    
    var globalImageSent : UIImage?
    var globalVideoUrl: NSURL?
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBackgroundViews()
        setupTableView()
        loadMessages()
        setupRightNavItem()
        self.handleEmptySavedMessages()
        savedMessagesTable.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        finalLabel?.settingsPageLabels(type: Constants.settingsPage.labelTitles)
        loadMessages()
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateBackgroundViews()
        loadMessages()
        
        
        
    }
    
    func setupTableView(){
        savedMessagesTable.delegate = self
        savedMessagesTable.dataSource = self
        savedMessagesTable.register(MessgaeCell.self, forCellReuseIdentifier: cellID)
    }
    func setupRightNavItem(){
        let button:UIButton = {
            let rightButton = UIButton(type: .system)
            let image = UIImage(systemName: "minus.circle.fill")
            rightButton.setImage(image, for: .normal)
            rightButton.addTarget(self, action: #selector(handlesTappedRightNavBarItem), for: .touchUpInside)
            return rightButton
        }()
        
        var keywindow = UIWindow()
        for window in UIApplication.shared.windows{
            if window.isKeyWindow{
                keywindow = window
            }
        }
        let label:UILabel = {
            let finalLabel = UILabel(frame: keywindow.frame)
            finalLabel.text = "No Saved Messages"
            finalLabel.textAlignment = .center
            finalLabel.center = keywindow.center
            return finalLabel
        }()
        
        finalLabel = label
        savedMessagesTable.addSubview(finalLabel!)
        
        finalLabel?.isHidden = true
        finalLabel?.settingsPageLabels(type: Constants.settingsPage.labelTitles)
        
        let rightBarButtonItem = UIBarButtonItem(customView: button)
        rightBarButton = rightBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func loadFreindMessage(){
        
        FireService.sharedInstance.loadMessagesWithFriend(User: globalUser!, freind: freind!) { (messages, error) in
            
        }
    }
    
    
    
    func loadRightMessage(){
        
        
        if freind != nil {
            loadFreindMessage()
            
        }else if group != nil{
            loadMessages()
        }
    }
    
    
    
    
    @objc func handlesTappedRightNavBarItem(){
        savedMessagesTable.setEditing(true, animated: true)
        
        print("Right Bar button tapped")
        
    }
    func loadMessages (){
        
        FireService.sharedInstance.loadSavedMessages(user: globalUser!, group: group!) { (messages, error) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            self.savedMessages.removeAll()
            self.savedMessagesTable.reloadData()
            guard let messages = messages else {return}
            print(messages.count , "this is printing is in groupvc")
            
            messages.forEach { (message) in
                self.savedMessages.append(message)
                print(message.content.content as! String, "this is printing in group vc")
            }
            
            
            self.savedMessages.sort { (message1, message2) -> Bool in
                return message1.timeStamp < message2.timeStamp
            }
            
            if !messages.isEmpty{
                self.savedMessagesTable.reloadData()
                self.savedMessagesTable.separatorStyle = .singleLine
                self.finalLabel?.isHidden = true
                let indexPath = IndexPath(row: self.savedMessages.count-1, section: 0)
                self.savedMessagesTable.scrollToRow(at:indexPath, at: .bottom, animated: true)
                print(self.savedMessages[0].content.content)
            }
            else{
                self.savedMessagesTable.scrollsToTop = true
                self.savedMessagesTable.separatorStyle = .none
                self.finalLabel?.isHidden = false
            
            }

        }
        
    }
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        print("Display switch:\(Constants.settingsPage.displayModeSwitch)")
        navigationItem.title = "Saved Messages"
        DispatchQueue.main.async {
            self.savedMessagesTable.darkmodeBackground()
            
            //self.navigationController?.navigationBar.darkmodeBackground()
            
            self.navigationBarBackgroundHandler()
            
        }
    }
    func handleEmptySavedMessages(){
        if self.savedMessages.isEmpty{
            self.savedMessagesTable.separatorStyle = .none
            self.finalLabel?.isHidden = false
        }
        else{
            self.savedMessagesTable.separatorStyle = .singleLine
            self.finalLabel?.isHidden = true
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


extension SavedMessagesVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofrows: \(savedMessages.count)")
        return savedMessages.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = savedMessagesTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessgaeCell
        let message = savedMessages[indexPath.row]
        cell.savedVC1 = self
        cell.message = message
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let message = savedMessages[indexPath.row]
            print(savedMessages[indexPath.row].content)
            FireService.sharedInstance.deleteOneSavedMessage(user: globalUser!, group: group!, MessageToDelete: message) { (result) in
                switch result{
                    
                case .success(let bool):
                    if bool{
                        print("Saved Messages:\(self.savedMessages.count)")
                        self.savedMessages.remove(at: indexPath.row)
                        self.savedMessagesTable.deleteRows(at: [indexPath], with: .automatic)
                        self.savedMessagesTable.setEditing(false, animated: false)
                        self.handleEmptySavedMessages()
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
            
        }
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
