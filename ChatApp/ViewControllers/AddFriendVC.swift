//
//  AddFiend.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/29/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import FirebaseDynamicLinks

class AddFriendVC : UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var sendInviteButton: UIButton!
    @IBOutlet weak var addContactsHeader: UILabel!
    let dynamicLinkDomain = "https://soluchat.page.link"
    var shareURL:URL? = nil
    var shareURLString:String?
   
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        updateViews()
        updateBackgroundViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        updateViews()
        updateBackgroundViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.largeTitleDisplayMode = .never
        updateViews()
        updateBackgroundViews()
    }
    

    
    @IBAction func addFriend(_ sender: Any) {
        
        if let email = emailTextfield.text{
            self.searchAndAddFreindWith(email: email)
        }
        
    }
    @IBAction func openCameraApp(_ sender: Any) {
        let scannerView = ScannerViewController()
        scannerView.pastViewController = self
        self.present(scannerView, animated: true) {
            print("Success")
        }
    }
    
    func dynamicLinkSetup(){
        var component = URLComponents()
        component.scheme = "https"
        component.host = "www.example.com"
        //component.path = "\()"
    }
    func updateViews(){
        sendInviteButton.contactsPageButton()
        addContactsHeader.addContactsPageLabels(type: Constants.newContactsPage.newContactsHeader)
        emailTextfield.addContactPage()
    }
    func updateBackgroundViews(){
           DispatchQueue.main.async {
               self.view.darkmodeBackground()
               self.navigationController?.navigationBar.darkmodeBackground()
               self.navigationBarBackgroundHandler()

               
               
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
    
    
    
    
    
    func searchAndAddFreindWith(email : String)  {
        if let email = self.emailTextfield.text{
            if email == "" {
                let controller = UIAlertController.alertUser(title: "Empty email field", message: "Please enter an email address", whatToDo: "Try again")
                self.present(controller, animated: true, completion: nil)
                return
            }else{
        FireService.sharedInstance.searchOneFreindWithEmailAddFriend(email: email) { (freind, error) in
            if let error = error {
                print(error)
                fatalError("cannot add friend, deoes not exsist")
            }else{
                let email1 = email.lowercased()
                self.createDynamicLink(user: globalUser.toFireUser, friendEmail: email1) { (completion) in
                    if completion{
                        print("Completed showing composer")
                    }
                }
                
//                if let friend = freind {
//                    guard let globalUser = globalUser else {return}
//                    FireService.sharedInstance.addFriend(User: globalUser, friend: friend) { (sucess, error) in
//
//                        if let error = error{
//                            print(error)
//
//                            let controller = UIAlertController.alertUser(title: "Error", message: error.localizedDescription, whatToDo:  "make sure the email is complete")
//                            self.present(controller, animated: true, completion: nil)
//                        }else{
//                            if sucess {
//                                print("sucess")
//                                let controller = UIAlertController.alertUser(title: "Sucesss", message: "Sucessfully added a user", whatToDo: "Check contact sb")
//
//                                self.present(controller, animated: true, completion: nil)
//                            }
//                        }
//                    }
//
//                }
                }
            }

        }
    }
    }
    
}
extension AddFriendVC:MFMailComposeViewControllerDelegate{
    
    func createDynamicLink(user:FireUser,friendEmail:String,completion:@escaping (Bool) -> ()){
        print("this dynamic link func has been called")
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/Contacts"
        if let user = globalUser{
        let requestSenderEmail = URLQueryItem(name: "requestSenderEmail", value: user.email)
        let requestReceiverEmail = URLQueryItem(name: "requestReceiverEmail", value: friendEmail)
//            let requestReceiverEmail = URLQueryItem(name: "requestReceiverEmail", value: "")
        components.queryItems = [requestSenderEmail,requestReceiverEmail]
        
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
                //Added a Notification Log
                FireService.sharedInstance.notification(.FriendRequest, globalUser.toFireUser, url.absoluteString, friendEmail, "New Friend Request", "\(globalUser.toFireUser.name) added you as a friend") { (completions, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        fatalError()
                    }
                    FireService.sharedInstance.pushNotificationFriend(title: "New Friend Request", subtitle: "\(globalUser.toFireUser.name) added you as a friend", friends: [friendEmail]) { (pushResult) in
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
                }
                
                self.shareURL = url
                self.shareURLString = shortUrl
                self.composeMail(url:url,friendEmail: friendEmail)
                completion(true)
            }
        }
    }
    //handles sending mail invite to people invited to the group.
    func composeMail(url:URL,friendEmail:String){
        print("Func is called")
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services not available")
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([friendEmail])
        composer.setSubject("\(globalUser.toFireUser.name) sent a friend request on the Soluchat App")

        composer.setMessageBody("Hello," + "\n" + "\n\(globalUser.toFireUser.name) has invited you to be a friend. Use the link below to accept his request and start chatting!" + "\n" + "\nThanks for choosing our app for your messaging needs. From all of us here at Solustack, Happy chatting!" + "\n" + "\n" + "\(url)", isHTML: false)
        
        present(composer, animated: true, completion: nil)
        
    }
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
    


}
