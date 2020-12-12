//
//  ChatInfoCells.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ChatInfoCells: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func updateView(indexPath:Int){
        //using this as a temporary solution because cell tint color in xcode has a bug
        let image = UIImage(systemName: "chevron.right.circle.fill")
        let imageView = UIImageView(image: image)
        self.accessoryView = imageView
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
       
        switch indexPath {
        case 0:
            //using this as a temporary solution because cell tint color in xcode has a bug
            let image = UIImage(systemName: "chevron.right.circle.fill")
            let imageView = UIImageView(image: image)
            self.accessoryView = imageView
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
            label.text = "Saved Messages"
            label.settingsPageLabels(type: Constants.settingsPage.labelTitles)
//        case 1:
//            label.text = "Archived Chat"
//            label.settingsPageLabels(type: Constants.settingsPage.labelTitles)
        default:
            label.text = "Error"
        }
    }
    
}
