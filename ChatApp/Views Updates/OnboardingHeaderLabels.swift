//
//  OnboardingHeaderLabels.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 7/3/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class OnboardingHeaderLabels: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        labelText()
        
        
    }
    func labelText(){
        self.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        self.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
    
    }

}
