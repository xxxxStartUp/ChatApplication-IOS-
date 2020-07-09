//
//  ProfileInfoCell.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/8/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    func updateViews(){
        
        //using this as a temporary solution because cell tint color in xcode has a bug
        let image = UIImage(systemName: "chevron.right.circle.fill")
        let imageView = UIImageView(image: image)
        self.accessoryView = imageView
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.1453940272, green: 0.6507653594, blue: 0.9478648305, alpha: 1)
    }
}
