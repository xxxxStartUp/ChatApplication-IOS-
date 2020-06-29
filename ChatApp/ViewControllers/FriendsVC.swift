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
    var friendList : [Friend] = []
    let identifier = "ContactCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        loadFriends()

        // Do any additional setup after loading the view.
    }
    
    
    
    func loadFriends(){
        guard let globalUser = globalUser else{return}
        FireService.sharedInstance.loadAllFriends(user: globalUser) { (friends, error) in
            
            if let friends = friends{
                for friend in friends{
                    self.friendList.append(friend)
                }
                self.contactsTable.reloadData()
            }
            
        }
    }
    
    func setUpTableView() -> Void {
        contactsTable.delegate = self
        contactsTable.dataSource = self
    }



}


extension FriendsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = contactsTable.dequeueReusableCell(withIdentifier: identifier) as? ContactCell {
            cell.friend = friendList[indexPath.row]
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = "cell isnt working"
            return cell
        }
        
        
    }
    
    
}
