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
    
    var searchBarr:UISearchBar?
    var finalLabel:UILabel?
    
    
    var friendList : [Friend] = []
    let identifier = "ContactCell"
    var delegate : FreindDelegate?
    var filteredFriendList = [Friend]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        contactsTable.tableHeaderView = headerViewSetUp()
        setupEmptyContactsLabel()
        handleEmptyContacts()
        updateBackgroundViews()
        setUpTableView()
        //contactsTable.allowsMultipleSelection = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupEmptyContactsLabel()
        handleEmptyContacts()
//        contactsTable.tableHeaderView = headerViewSetUp()
        updateBackgroundViews()
                
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidAppear(true)
        setupEmptyContactsLabel()
        handleEmptyContacts()
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


    
    func setUpTableView() -> Void {
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
        
    }
    
    //updates the background color for the tableview and nav bar.
    func updateBackgroundViews(){
        DispatchQueue.main.async {
            self.contactsTable.darkmodeBackground()
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
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.setNeedsLayout()
            //handles TabBar
            self.tabBarController?.tabBar.barTintColor = .black
            tabBarController?.tabBar.isTranslucent = false
            searchBarr?.barStyle = .black
            contactsTable.reloadData()
            
            
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
            searchBarr?.barStyle = .default
            contactsTable.reloadData()
            
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
            cell.FreindimageView.chatLogImageView()
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
        if !searching{
            guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
            self.delegate = vc
            delegate?.didSendFriend(freind: friendList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
            self.delegate = vc
            delegate?.didSendFriend(freind: filteredFriendList[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if !searching{
            print(friendList[indexPath.row].email)
            FireService.sharedInstance.deleteFriend(user: globalUser!, friend: friendList[indexPath.row]) { (error, completion) in
                if let error = error{
                    print(error.localizedDescription)
                }
                self.friendList.remove(at: indexPath.row)
                self.contactsTable.deleteRows(at: [indexPath], with: .automatic)
                self.handleEmptyContacts()

            }
            }else{
                print(filteredFriendList[indexPath.row].email)
                FireService.sharedInstance.deleteFriend(user: globalUser!, friend: filteredFriendList[indexPath.row]) { (error, completion) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    let friendToDelete = self.filteredFriendList.remove(at: indexPath.row)
                    self.friendList.remove(at: self.friendList.firstIndex(of: friendToDelete)!)
                    self.contactsTable.deleteRows(at: [indexPath], with: .automatic)
                    self.searching = false
                    self.searchBarr?.text = ""
                    self.contactsTable.reloadData()
                    self.handleEmptyContacts()

                }

            }
            
        }
        
    }
    
    func handleEmptyContacts(){
        if self.friendList.isEmpty{
            self.contactsTable.separatorStyle = .none
            self.finalLabel?.isHidden = false
        }
        else{
            self.contactsTable.separatorStyle = .singleLine
            self.finalLabel?.isHidden = true
        }
    }
    func setupEmptyContactsLabel(){
        let label:UILabel = {
            let finalLabel = UILabel()
            finalLabel.text = "No Contacts"
            finalLabel.textAlignment = .center
            
            return finalLabel
        }()
        
        finalLabel = label
        contactsTable.addSubview(finalLabel!)
        finalLabel?.center = contactsTable.center
        
        finalLabel?.isHidden = true
        finalLabel?.settingsPageLabels(type: Constants.settingsPage.labelTitles)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = {
        let searchBar = UISearchBar()//UIView(frame: CGRect(x: 0, y: 0, width: contactsTable.frame.width, height: 30))
        searchBar.placeholder = "Search Contacts"
        searchBar.darkmodeBackground()
        if Constants.settingsPage.displayModeSwitch{
            searchBar.barStyle = .black
        }else{
            searchBar.barStyle = .default
        }
        return searchBar
        }()
        searchBarr = view as? UISearchBar
        searchBarr!.delegate = self
        return searchBarr
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
//    func headerViewSetUp() -> UIView{
//        let view:UIView = {
//            let searchBar = UISearchBar()//UIView(frame: CGRect(x: 0, y: 0, width: contactsTable.frame.width, height: 30))
//            searchBar.placeholder = "Search Contacts"
//            searchBar.darkmodeBackground()
//            return searchBar
//        }()
//        searchBar = view as? UISearchBar
//        return view
//    }
        
    
    
    
    
}
