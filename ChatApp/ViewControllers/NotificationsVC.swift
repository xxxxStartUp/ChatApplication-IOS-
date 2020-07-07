//
//  NotificationsVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/6/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var notificationsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.notificationsCellIdentifier, for: indexPath) as! NotificationsCell
        cell.updateViews()
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.notificationsCellIdentifier)
        navigationItem.title = "Notifications"
        
        

    }


}
