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
    
    let identifier = "ContactCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        // Do any additional setup after loading the view.
    }
    
    
    
    func setUpTableView() -> Void {
        contactsTable.delegate = self
        contactsTable.dataSource = self
    }



}


extension FriendsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = contactsTable.dequeueReusableCell(withIdentifier: identifier) as? ContactCell {
            
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = "cell isnt working"
            return cell
        }
        
        
    }
    
    
}
