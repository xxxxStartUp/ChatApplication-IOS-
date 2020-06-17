//
//  AuthenticationButtonsView.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/16/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class AuthenticationButtonsView: UIButton {

    
    override func awakeFromNib() {
        cornerRadiusMod()
    }
    

    func cornerRadiusMod(){
        self.layer.cornerRadius = 5
        
    }
}
