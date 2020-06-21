//
//  SettingsVC.swift
//  ChatApp
//
//  Created by Daramfon Akpan on 6/20/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        FireService.sharedInstance.signOut()
        goToMainPage()
        
        
    }
    
    func goToMainPage(){
        let vc = UIStoryboard(name: "SignUpSB", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

}
