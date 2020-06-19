//
//  NewGroupVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatPageVC: UIViewController,UITableViewDataSource {

    

    @IBOutlet weak var ChatStoryTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatStoryTV.dataSource = self

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell", for: indexPath)
        return cell
        
    }
    


}
