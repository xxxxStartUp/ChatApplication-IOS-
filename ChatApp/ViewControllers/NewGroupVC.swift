//
//  CreateGroupVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/24/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDynamicLinks
import MessageUI

class NewGroupVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var newGroupLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var newGroupImageView: UIImageView!
    let dynamicLinkDomain = "https://soluchat.page.link"
    
    var selectedFriendsListEmail: [String] = []
    var shareURL:URL? = nil
    var shareURLString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        updateBackgroundViews()
        print("Selected Friend Email: \(selectedFriendsListEmail)")
//        createDynamicLink()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
        updateBackgroundViews()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        selectedFriendsListEmail.removeAll()
    }
    
    
    func createGroup() {
        if let groupName = self.groupNameTextField.text{
            if groupName == "" {
                let controller = UIAlertController.alertUser(title: "Error", message: "Add a name to the groupchat", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
                return
            }

            //new group is created and temp id is passed.
            let id = UUID().uuidString
            let newGroup = Group(GroupAdmin: globalUser!, id: id, name: groupName)
            //added final id to completion to get the latest id from backend and use for creating dynamic link.
            FireService.sharedInstance.createGroup(user: globalUser!, group: newGroup) { (completed, error) in
                if let error = error{
                    print(error.localizedDescription)
                    fatalError()
                }
                if completed{
                    self.createDynamicLink(admin: globalUser!, groupID: id, groupName: groupName) { (success) in
                        if success{
                            //call function to save the url in FB
                            if let shareURLString = self.shareURLString{
                            let data = ["groupInvitationUrl" : shareURLString]
                            FireService.sharedInstance.addCustomDataToGroup(data: data, user: globalUser!, group: newGroup) { (error, success) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    fatalError()
                                }
                                    print("Added custom URL data to group")
                            }
                            }
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "group"{

            let destination = segue.destination as! ChatVC
            destination.modalPresentationStyle = .currentContext

        }

        
    }
    func importSelectedFriends(friendsListEmail:[String]){
        selectedFriendsListEmail.removeAll()
        selectedFriendsListEmail = friendsListEmail
    }
    func updateViews(){
        
        navigationItem.largeTitleDisplayMode = .never
        //adding rightBarButton
        let rightBarButton = UIButton(type: .system)
        
        rightBarButton.addTarget(self, action: #selector(NewGroupVC.rightBarButtonPressed), for: .touchUpInside)
        
        //allows the cartbutton to glow when it is tapped on
        rightBarButton.showsTouchWhenHighlighted = true
        //sets title of rightbutton
        rightBarButton.setTitle("Done", for: .normal)
        //sets the font size and type.
        rightBarButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 12)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightBarButton)]
        newGroupLabel.newGroupPageLabels(type: Constants.newGroupPage.newGroupHeader)
        
    }
    
    @objc func rightBarButtonPressed(){
        //createDynamicLink()
        createGroup()
        
    }
    func createDynamicLink(admin:FireUser,groupID:String,groupName:String,completion:@escaping (Bool) -> ()){
        print("this dynamic link func has been called")
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/groups"
        
        let groupIDQueryItem = URLQueryItem(name: "groupID", value: groupID)
        let adminQueryItem = URLQueryItem(name: "admin", value: admin.email)
        let groupName = URLQueryItem(name: "groupName", value: groupName)
        components.queryItems = [groupIDQueryItem,adminQueryItem,groupName]
        
        guard let linkParameter = components.url else {return}
        
        print("I am sharing \(linkParameter.absoluteString)")
        
        //create the big dynamic link
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: dynamicLinkDomain) else{
            print("Couldn't create FDL components")
            return
        }
        
        if let myBundleId = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        shareLink.iOSParameters?.appStoreID = "962194608"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Join the chat in the soluchat app"
        shareLink.socialMetaTagParameters?.descriptionText = "This is Soluchat App"
        
        guard let longURL = shareLink.url else{return}
        print("This is the dynamiclink is \(longURL.absoluteString)")
        
        shareLink.shorten { (url, warnings, error) in
            if let error = error {
                print("Shortening Link Error:\(error)")
            }
            if let warnings = warnings{
                for warning in warnings{
                    print("FDL Warning:\(warning)")
                }
            }
            guard let url = url else{return}
            let shortUrl = url.absoluteString
            print("I have a short URL to share! \(url.absoluteString)")
            self.shareURL = url
            self.shareURLString = shortUrl
            self.composeMail(url:url)
            completion(true)
            
            //            self.showSheet(url: url)
        }
        
    }
    func showSheet(url:URL){
        let promoText = "Check out this app for solustack"
        let activityVC = UIActivityViewController(activityItems: [promoText,url], applicationActivities: nil)
        present(activityVC,animated: true)
    }
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.view.darkmodeBackground()
            self.navigationController?.navigationBar.darkmodeBackground()
            self.navigationBarBackgroundHandler()
            self.textField.newGroupPageTextField()
            
            
            //self.navigationController?.navigationBar.settingsPage()
            
            
        }
    }
    //handles the text color, background color and appearance of the nav bar
    func navigationBarBackgroundHandler(){
        
        if Constants.settingsPage.displayModeSwitch{
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            self.navigationController?.navigationBar.isTranslucent = false
            //                  textField.attributedPlaceholder = NSAttributedString(string: "Enter Group Name",
            //                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
            //                textField.attributedPlaceholder = NSAttributedString(string: "Enter Group Name",
            //                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.setNeedsLayout()
            
            //handles TabBar
            self.tabBarController?.tabBar.barTintColor = .white
            tabBarController?.tabBar.isTranslucent = false
        }
    }
    
    
}
extension NewGroupVC: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Hello is dismissed")
        controller.dismiss(animated: true, completion: nil)
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error{
            // create the alert
            let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            fatalError()
        }
        switch result {
            
        case .sent:
            DispatchQueue.main.async {
                // create the alert
                let alert = UIAlertController(title: "Invite Sent", message: "The invite has been sent to the selected contacts", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                 self.goToTab()
            }
        case .cancelled:
            self.goToTab()
            print("The cancel button has been clicked")
        case .failed:
            // create the alert
            let alert = UIAlertController(title: "Invite not sent", message: "The invite failed to be sent.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            self.goToTab()
        default:
            print("not sure")
            self.goToTab()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //handles sending mail invite to people invited to the group.
    func composeMail(url:URL){
        print("Func is called")
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services not available")
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(selectedFriendsListEmail)
        composer.setSubject("\(globalUser!.name) has invited you to join a group on the Soluchat App")

        composer.setMessageBody("Hello," + "\n" + "\n\(globalUser!.name) has invited you to join a groupchat. Use the link below to join the group and start chatting!" + "\n" + "\nThanks for choosing our app for your messaging needs. From all of us here at Solustack, Happy chatting!" + "\n" + "\n" + "\(url)", isHTML: false)
        
        present(composer, animated: true, completion: nil)
        
    }
    
    
}


