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
        if let email = emailTextField.text, let password = passwordTextField.text{
            //Need to complete validate class and functions in class before using it
            if Validate.isPasswordValid(password) && Validate.isValidEmail(email){

                FireService.sharedInstance.signIn(email: email, password: password) { (completed) in
                    if completed{
                        print("Signed In Successfully")
                        self.goToTab()
                    }
                    else{
                        print("Error occured while signing In")
                    }
                }

            }
            else{
                print("Wrong email or password format")
            }
        }
        
        
    }
    
    
    func goToTab(){
        let vc = UIStoryboard(name: "MainTabStoryboard", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

}