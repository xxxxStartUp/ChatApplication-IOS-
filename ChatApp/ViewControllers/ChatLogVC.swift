//
//  ChatLogVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatLogVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    @IBOutlet weak var chatLogTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatLogTableview.register(UINib(nibName: "ChatLogCell", bundle: nil), forCellReuseIdentifier: "ChatCellIdentifier")
        chatLogTableview.delegate = self
        chatLogTableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCellIdentifier") as! ChatLogCell
        cell.updateViews(indexPath: indexPath.row+1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = UIStoryboard(name: "ChatStoryBoard", bundle: nil).instantiateInitialViewController() else {return}
       
        navigationController?.pushViewController(vc, animated: true)
    }
    


}
