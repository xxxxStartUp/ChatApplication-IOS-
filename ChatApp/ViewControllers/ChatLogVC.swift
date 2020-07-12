//
//  ChatLogVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatLogVC: UIViewController{
    
    
    @IBOutlet weak var chatLogTableview: UITableView!
    
    
    var activities : [Activity] = []
    var friendDelegate : FreindDelegate?
    var groupDelegate : GroupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        chatLogTableview.register(UINib(nibName: "ChatLogCell", bundle: nil), forCellReuseIdentifier: "ChatCellIdentifier")
        chatLogTableview.delegate = self
        chatLogTableview.dataSource = self
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
            self.chatLogTableview.reloadData()
        }
        
    }
    
    func setUpfakeActivity(){
        
        let activity3 = Activity(activityType: .GroupChat(group: Group(GroupAdmin: FireUser(userID: 1, userName: "dara", userEmail: "daraegb@gmail.com", creationDate: Date()), id: 1, name: "Group1")))
        
        let activity1 = Activity(activityType: .FriendChat(friend: Friend(email: "ebukafake@gmail.com", username: "ebukaegb", id: 1)))
        let activity2 = Activity(activityType: .FriendChat(friend: Friend(email: "ebukadoublefake@gmail.com", username: "ebukaegb", id: 1)))
        let activity4 = Activity(activityType: .GroupChat(group: Group(GroupAdmin: FireUser(userID: 1, userName: "ramzi", userEmail: "ramzi@gmail.com", creationDate: Date()), id: 1, name: "Group2")))
        
        activities.append(activity1)
        activities.append(activity2)
        activities.append(activity3)
        activities.append(activity4)
        
        chatLogTableview.reloadData()
        
    }
    
    
    
}


extension ChatLogVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCellIdentifier") as! ChatLogCell
        cell.updateViews(indexPath: indexPath.row+1)
        cell.activity = activities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
}
