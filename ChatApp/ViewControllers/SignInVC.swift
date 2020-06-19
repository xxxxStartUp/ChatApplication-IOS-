//
//  SignInVC.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/19/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func Login(_ sender: Any) {
        goToTab()
        
    }
    
    
    func goToTab(){
        let vc = UIStoryboard(name: "MainTabStoryboard", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

}
