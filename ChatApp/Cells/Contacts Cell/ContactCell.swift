//
//  ContactCell.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/21/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var FreindimageView: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var friend : Friend!{
        didSet{
            friendName.text = friend.username
            friendEmail.text = friend.email
            friendName.contactsPageLabels(type: Constants.contactsPage.UserNameHeader)
            friendEmail.contactsPageLabels(type: Constants.contactsPage.emailSubHeader)
            FreindimageView.chatLogImageView()
            FireService.sharedInstance.getFriendPictureDataFromFriendVC(user: globalUser!, friend: friend) { (url,completion,error) in
 
                    if let url = url{
                    //                self.profileImageView.af_setImage(withURL: url)
//                        self.profileImageview.af.setImage(withURL: url)
                        self.FreindimageView.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
                   
                    //                    self.groupImageView.contentMode = .scaleAspectFit
                    }
                if !completion{
                        self.FreindimageView.image = UIImage(systemName: "person.crop.circle.fill")
                    }
  
                }
//            FireService.sharedInstance.getFriendPictureData(user: globalUser!, friend: friend) { (result) in
//
//                switch result{
//
//                case .success(let url):
//                    //                self.profileImageView.af_setImage(withURL: url)
////                    self.FreindimageView.af.setImage(withURL: url)
//                    self.FreindimageView.loadImages(urlString: url.absoluteString, mediaType: Constants.groupInfoPage.GroupImageType)
//
//                    //                    self.groupImageView.contentMode = .scaleAspectFit
//
//                case .failure(_):
//                    print("failed to set image url")
//                }
//
//            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
    
}
