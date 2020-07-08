//
//  ChatVC-Dara.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC_Dara: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath) as! ChatCell_Dara
        cell.updateViews()
        return cell
        
    }
    

    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self

    }
    
    
    
    



}
