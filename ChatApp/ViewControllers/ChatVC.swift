//
//  ChatVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/22/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var ChatTable: UITableView!
    
    let identifier = "ChatCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
  
        
    }
    
    
    func setUpTableView() -> Void {
        ChatTable.delegate = self
        ChatTable.dataSource = self
    }
    

}

extension ChatVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = ChatTable.dequeueReusableCell(withIdentifier: identifier) as? ChatCell_ebuka {
            
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    
    
}
