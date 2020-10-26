//
//  ChatLogVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatLogVC: UIViewController {
    
    
    @IBOutlet weak var chatLogTableview: UITableView!
    
    
    var activities : [Activity] = []
    var friendDelegate : FreindDelegate?
    var groupDelegate : GroupDelegate?
    var searchBarr:UISearchBar?
    var filteredActivity = [Activity]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarBackgroundHandler()
        chatLogTableview.register(UINib(nibName: "ChatLogCell", bundle: nil), forCellReuseIdentifier: "ChatCellIdentifier")
        chatLogTableview.delegate = self
        chatLogTableview.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        chatLogTableview.separatorStyle = .none
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarBackgroundHandler()
        updateBackgroundViews()
        loadActivity()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationBarBackgroundHandler()
        self.tabBarController?.tabBar.isHidden = false
        loadActivity()
    }
    
    
    func loadActivity(){
        FireService.sharedInstance.loadAllActivity(User: globalUser!) { (activities, error) in
            self.activities.removeAll()
            guard let loadedactivities = activities else{fatalError()}
            print(loadedactivities.count , "count of activities")
            loadedactivities.forEach { (ac) in
                print(ac.name)
                self.activities.append(ac)
            }
            
            DispatchQueue.main.async {
                self.chatLogTableview.reloadData()
            }
            
        }
        
    }

    
    
    func setUpfakeActivity(){
        
        let activity3 = Activity(activityType: .GroupChat(group: Group(GroupAdmin: FireUser(userID: "1", userName: "dara", userEmail: "daraegb@gmail.com", creationDate: Date()), id: "1", name: "Group1")))
        
        let activity1 = Activity(activityType: .FriendChat(friend: Friend(email: "ebukafake@gmail.com", username: "ebukaegb", id: "1")))
        let activity2 = Activity(activityType: .FriendChat(friend: Friend(email: "ebukadoublefake@gmail.com", username: "ebukaegb", id: "1")))
        let activity4 = Activity(activityType: .GroupChat(group: Group(GroupAdmin: FireUser(userID: "1", userName: "ramzi", userEmail: "ramzi@gmail.com", creationDate: Date()), id: "1", name: "Group2")))
        
        activities.append(activity1)
        activities.append(activity2)
        activities.append(activity3)
        
        
    }
    
    
    @IBAction func newGroupButtonPressed(_ sender: Any) {
        print("new groupButton Clicked")
        performSegue(withIdentifier: "chatLogToContactsIdentifier", sender: self)
        
        Constants.chatLogPage.chatLogToContactsSegueSignal = true
        Constants.selectedContactsPage.fromChatLogIndicator = true
        Constants.selectedContactsPage.fromGroupChatVCIndicator = false
    }
    @IBAction func contactButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "chatLogToFriendsVCIdentifier", sender: self)
    }
    
  
}


extension ChatLogVC : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCellIdentifier") as! ChatLogCell
        if searching{
            cell.updateViews(indexPath: indexPath.row+1)
            cell.activity = filteredActivity[indexPath.row]
            print("This is FilteredfriendsList\(filteredActivity)")
            cell.backgroundColor = .clear
            return cell
        }
        else{
            cell.updateViews(indexPath: indexPath.row+1)
            cell.activity = activities[indexPath.row]
            print("This is friendsList\(activities)")
            cell.backgroundColor = .clear
            return cell
        }
//        cell.updateViews(indexPath: indexPath.row+1)
//        cell.activity = activities[indexPath.row]
//        cell.backgroundColor = .clear
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searching{
        let activity = activities[indexPath.row]
        
        switch activity.type {
            
        case .GroupChat(group: let group):
            guard let vc = UIStoryboard(name: "GroupChatSB", bundle: nil).instantiateInitialViewController()  as? GroupChatVC else {return}
            self.groupDelegate = vc
            groupDelegate?.didSendGroup(group: group)
            navigationController?.pushViewController(vc, animated: true)
            return
            
        case .FriendChat(friend: let friend):
            guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
            self.friendDelegate = vc
            friendDelegate?.didSendFriend(freind: friend)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        }else{
            let activity = filteredActivity[indexPath.row]
            switch activity.type {
                
            case .GroupChat(group: let group):
                guard let vc = UIStoryboard(name: "GroupChatSB", bundle: nil).instantiateInitialViewController()  as? GroupChatVC else {return}
                self.groupDelegate = vc
                groupDelegate?.didSendGroup(group: group)
                navigationController?.pushViewController(vc, animated: true)
                return
                
            case .FriendChat(friend: let friend):
                guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController()  as? ChatVC_Dara else {return}
                self.friendDelegate = vc
                friendDelegate?.didSendFriend(freind: friend)
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return filteredActivity.count
        }else{
            return activities.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = {
        let searchBar = UISearchBar()//UIView(frame: CGRect(x: 0, y: 0, width: contactsTable.frame.width, height: 30))
        searchBar.placeholder = "Search groups/contacts"
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
    
    func updateBackgroundViews(){
        
        DispatchQueue.main.async {
            self.chatLogTableview.darkmodeBackground()
            self.navigationBarBackgroundHandler()
            self.view.darkmodeBackground()
            
            
            
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
            self.tabBarController?.tabBar.backgroundColor = .black
            
            //handles TabBar
            self.tabBarController?.tabBar.barTintColor = .black
            tabBarController?.tabBar.isTranslucent = false
            searchBarr?.barStyle = .black

            
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
            tabBarController?.tabBar.isTranslucent = false
            searchBarr?.barStyle = .default

            
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredActivity = activities.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        print("This is friendsList\(activities)")
        print("This is FilteredfriendsList\(filteredActivity)")
        searching = true
        chatLogTableview.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        chatLogTableview.reloadData()
    }
}
