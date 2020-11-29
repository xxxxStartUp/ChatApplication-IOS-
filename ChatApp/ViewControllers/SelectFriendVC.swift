//
//  SelectFriendVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/26/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class SelectFriendVC: UIViewController,MFMailComposeViewControllerDelegate{
    @IBOutlet var contactsTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var newGroupBtn: UIButton!
    
    var friendList : [Friend] = []
    var friendListEmail: [String] = []
    let identifier = "ContactCell"
    var delegate : FreindDelegate?
    var filteredFriendList = [Friend]()
    var searching = false

    var group:Group?

    let navBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var url:URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        updateBackgroundViews()
        //rightBarButtonItemTrick()
        setUpTableView()
        contactsTable.tableFooterView = footerviewSetUp()
        contactsTable.allowsMultipleSelection = true
        Constants.chatLogPage.chatLogToContactsSegueSignal = true
        
       
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
        Constants.chatLogPage.chatLogToContactsSegueSignal = true
        contactsTable.tableFooterView = footerviewSetUp()
        friendListEmail.removeAll()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidAppear(true)
        loadFriends()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        Constants.chatLogPage.chatLogToContactsSegueSignal = false
    }
    
    
    
    func loadFriends(){
        friendList.removeAll()
        guard let globalUser = globalUser else{return}
        FireService.sharedInstance.loadAllFriends(user: globalUser) { (friends, error) in
            
            if let friends = friends{
                for friend in friends{
                    self.friendList.append(friend)
                }
                
                DispatchQueue.main.async {
                    
                    self.contactsTable.reloadData()
                    
                }
                
            }
            
        }
    }

    //handles hiding the rightbar button when contactstable appears from segueing from the chatscreen. The reason for this is so you can only add contacts from the contacts tab
    //    func rightBarButtonItemTrick(){
    //        if Constants.chatPage.chatToContactsSegueSignal{
    //            self.navigationItem.rightBarButtonItem = nil
    //        }
    //        else{
    //            self.navigationItem.rightBarButtonItem = addButton
    //        }
    //    }
    
    
    func setUpTableView() -> Void {
        contactsTable.delegate = self
        contactsTable.dataSource = self
        searchBar.delegate = self
    }
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.contactsTable.darkmodeBackground()
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
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.setNeedsLayout()
            //handles TabBar
            self.tabBarController?.tabBar.barTintColor = .black
            tabBarController?.tabBar.isTranslucent = false
            searchBar.barStyle = .black
            
            
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
            searchBar.barStyle = .default
            
        }
    }
    @IBAction func newGroupPressed(_ sender: Any) {
        
        if friendListEmail.isEmpty{
            let controller = UIAlertController.alertUser(title: "No Contacts Selected", message: "Select the contacts that will be invited to the new group", whatToDo: "OK")
            self.present(controller, animated: true, completion: nil)
        }else{
            
             performSegue(withIdentifier: "contactsToNewGroupSB", sender: self)
        }
    }
    
    @IBAction func addContactPressed(_ sender: Any) {
        performSegue(withIdentifier: "contactsToAddFriends", sender: self)
    }
    
    
    
    
    
}


extension SelectFriendVC : UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return filteredFriendList.count
        }else{
            return friendList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = contactsTable.dequeueReusableCell(withIdentifier: identifier) as? ContactCell {
            if searching{
                cell.friend = filteredFriendList[indexPath.row]
                print("This is FilteredfriendsList\(filteredFriendList)")
                cell.backgroundColor = .clear
                return cell
            }
            else{
                cell.friend = friendList[indexPath.row]
                print("This is friendsList\(friendList)")
                cell.backgroundColor = .clear
                return cell
            }
        }else{
            
            let cell = UITableViewCell()
            cell.textLabel?.text = "cell isnt working"
            return cell
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewGroupVC{
            destination.selectedFriendsListEmail = friendListEmail       
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Constants.chatLogPage.chatLogToContactsSegueSignal == false{
            guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
            self.delegate = vc
            delegate?.didSendFriend(freind: friendList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            friendListEmail.append(friendList[indexPath.row].email)
            print(friendListEmail)
            print(indexPath.row)
            print(friendList[indexPath.row].email)

        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let friendToRemove = friendList[indexPath.row].email
        let index = friendListEmail.firstIndex(of: friendToRemove)
        friendListEmail.remove(at: index!)
        print(friendListEmail)
        print(indexPath.row)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriendList = friendList.filter({$0.username.lowercased().prefix(searchText.count) == searchText.lowercased()})
        print("This is friendsList\(friendList)")
        print("This is FilteredfriendsList\(filteredFriendList)")
        searching = true
        contactsTable.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        contactsTable.reloadData()
    }
    func footerviewSetUp() -> UIView{
        let view:UIView = {
            let finalLabel = UIView(frame: CGRect(x: 0, y: 0, width: contactsTable.frame.width, height: 30))
            finalLabel.darkmodeBackground()
            return finalLabel
        }()
        let button:UIButton = {
            var addFriendsToGroup = UIButton(type: .system)
            addFriendsToGroup.frame = view.frame
            addFriendsToGroup.setTitle("Add To Group", for: .normal)
            addFriendsToGroup.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
            //               rightButton.setTitleColor(.red, for: .normal)
            addFriendsToGroup.settingsPageButtons()
            addFriendsToGroup.translatesAutoresizingMaskIntoConstraints = false
            addFriendsToGroup.addTarget(self, action: #selector(addFriendsToGroupTapped), for: .touchUpInside)
            return addFriendsToGroup
        }()
        
        view.addSubview(button)
//        groupOptionButton = button
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }
    @objc func addFriendsToGroupTapped(){
        if Constants.selectedContactsPage.fromChatLogIndicator{
        if friendListEmail.isEmpty{
            let controller = UIAlertController.alertUser(title: "No Contacts Selected", message: "Select the contacts that will be invited to the new group", whatToDo: "OK")
            self.present(controller, animated: true, completion: nil)
        }else{
            
             performSegue(withIdentifier: "contactsToNewGroupSB", sender: self)
        }
        }else if Constants.selectedContactsPage.fromGroupChatVCIndicator{
            if friendListEmail.isEmpty{
                let controller = UIAlertController.alertUser(title: "No Contacts Selected", message: "Select the contacts that will be invited to the new group", whatToDo: "OK")
                self.present(controller, animated: true, completion: nil)
            }else{
                if let group = group{
                FireService.sharedInstance.getGroupURL(user: globalUser!, group:group) { (url, completion, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    if let url = url, let finalURL = URL(string: url){
                        self.composeMail(url: finalURL)
                }
                }
                }
            }
        }
    }
    
//    handles sending mail invite to people invited to the group.
    func composeMail(url:URL){
        
                print("Func is called")
                guard MFMailComposeViewController.canSendMail() else {
                    print("Mail services not available")
                    return
                }
                let composer = MFMailComposeViewController()
                composer.mailComposeDelegate = self
                composer.setToRecipients(self.friendListEmail)
                composer.setSubject("\(globalUser!.name) has invited you to join a group on the Soluchat App")
                self.url = url
                composer.setMessageBody("Hello," + "\n" + "\n\(globalUser!.name) has invited you to join a groupchat. Use the link below to join the group and start chatting!" + "\n" + "\nThanks for choosing our app for your messaging needs. From all of us here at Solustack, Happy chatting!" + "\n" + "\n" + "\(url)", isHTML: false)

                self.present(composer, animated: true, completion: nil)

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
                if let url = self.url{
                let message = Message(content:Content(type: .string, content: "\(globalUser!.name) has invited you to join a groupchat. Use the link below to join the group and start chatting!" + "\(url)") , sender: globalUser!, timeStamp: Date(), recieved: false)
                FireService.sharedInstance.pushNotificationFriend(title: "New Friend Request from \(globalUser!.email)" , subtitle: "Hello," + "\n" + "\n\(globalUser!.name) has invited you to join a groupchat. Use the link below to join the group and start chatting!" + "\n" + "\nThanks for choosing our app for your messaging needs. From all of us here at Solustack, Happy chatting!" + "\n" + "\n" + "\(url)", friends: self.friendListEmail) { (pushResult) in
                switch pushResult{
                    case .success(true):
                      print("Push notification happened")
                        self.friendListEmail.forEach { (friend) in
                         
                            FireService.sharedInstance.notifications(User: globalUser!, message: message, freindEmail: friend) { (completion, error) in
                                if let error = error{
                                    print(error.localizedDescription)
                                    fatalError()
                                }
                        
                            }
                        }
                    
                    // create a collection of recent messages for the user
                    case .failure(let error):
                        print(error.localizedDescription)
                        fatalError()
               
                case .success(false):
                    fatalError()
                }
            
                }
                }}
        case .cancelled:
            
            print("The cancel button has been clicked")
        case .failed:
            // create the alert
            let alert = UIAlertController(title: "Invite not sent", message: "The invite failed to be sent.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        default:
            print("not sure")
            
        }
        controller.dismiss(animated: true, completion: nil)
    }

}





