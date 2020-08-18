//
//  ContactsVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/21/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit
class FriendsVC: UIViewController {
    
    
    @IBOutlet weak var contactsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var addButton: UIBarButtonItem!
    
    
    var friendList : [Friend] = []
    let identifier = "ContactCell"
    var delegate : FreindDelegate?
    var filteredFriendList = [Friend]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        updateBackgroundViews()
        rightBarButtonItemTrick()
        setUpTableView()
        //contactsTable.allowsMultipleSelection = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateBackgroundViews()
                
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidAppear(true)
        loadFriends()
        
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
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "contactsToAddFriends", sender: self)
    }
    //handles hiding the rightbar button when contactstable appears from segueing from the chatscreen. The reason for this is so you can only add contacts from the contacts tab
    func rightBarButtonItemTrick(){
        if Constants.chatPage.chatToContactsSegueSignal{
            self.navigationItem.rightBarButtonItem = nil
        }
        else{
            self.navigationItem.rightBarButtonItem = addButton
        }
    }

    
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
    
    
    
    
}


extension FriendsVC : UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate{
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
            self.delegate = vc
            delegate?.didSendFriend(freind: friendList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
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
    
    
    
    
}
